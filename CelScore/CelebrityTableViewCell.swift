//
//  CelebrityTableViewCell.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 5/23/15.
//  Copyright (c) 2015 Gareth.K.Mensah. All rights reserved.
//

import AsyncDisplayKit
import WebASDKImageManager
import Material


final class CelebrityTableViewCell: ASCellNode, MaterialSwitchDelegate {
    
    //MARK: Properties
    private let nameNode: ASTextNode
    private let profilePicNode: ASNetworkImageNode
    private let ratingsNode: ASDisplayNode
    private let switchNode: ASDisplayNode
    private let backgroundNode: ASDisplayNode
    let celebST: CelebrityStruct
    
    //MARK: Initializer
    init(celebrityStruct: CelebrityStruct) {
        self.celebST = celebrityStruct
        
        self.nameNode = ASTextNode()
        let attr = [NSFontAttributeName: UIFont.systemFontOfSize(20.0), NSForegroundColorAttributeName : MaterialColor.white]
        self.nameNode.attributedString = NSMutableAttributedString(string: "\(celebST.nickname)", attributes: attr)
        self.nameNode.maximumNumberOfLines = 1
        self.nameNode.truncationMode = .ByTruncatingTail
    
        self.profilePicNode = ASNetworkImageNode(webImage: ())
        self.profilePicNode.URL = NSURL(string: celebST.imageURL)
        self.profilePicNode.contentMode = .ScaleAspectFit
        self.profilePicNode.preferredFrameSize = CGSize(width: 50, height: 50)
        self.profilePicNode.imageModificationBlock = { (originalImage: UIImage) -> UIImage? in
            return ASImageNodeRoundBorderModificationBlock(12.0, Constants.kDarkShade)(originalImage)
        }
        
        let cosmosView = CosmosView()
        cosmosView.settings.starSize = Constants.kStarSize
        cosmosView.settings.starMargin = Constants.kStarMargin
        cosmosView.settings.updateOnTouch = false
        self.ratingsNode = ASDisplayNode(viewBlock: { () -> UIView in return cosmosView })
        self.ratingsNode.preferredFrameSize = CGSize(width: 10, height: 20)
        RatingsViewModel().hasUserRatingsSignal(ratingsId: self.celebST.id).startWithNext { hasRatings in
            cosmosView.settings.colorFilled = hasRatings ? Constants.kStarRatingShade : MaterialColor.white
            cosmosView.settings.borderColorEmpty = hasRatings ? Constants.kStarRatingShade : MaterialColor.white
        }
        RatingsViewModel().getCelScoreSignal(ratingsId: self.celebST.id).startWithNext { score in
            cosmosView.rating = score
        }
        
        let followSwitch = MaterialSwitch(size: .Small, state: self.celebST.isFollowed == true ? .On : .Off)
        followSwitch.center = CGPoint(x: Constants.kScreenWidth - 50, y: 32)
        followSwitch.buttonOnColor = Constants.kWineShade
        followSwitch.trackOnColor = followSwitch.trackOffColor
        self.switchNode = ASDisplayNode(viewBlock: { () -> UIView in return followSwitch })
        self.switchNode.preferredFrameSize = CGSize(width: 20, height: 20)
        
        let cardView: MaterialPulseView = MaterialPulseView()
        cardView.borderWidth = 2.0
        cardView.borderColor = Constants.kDarkShade
        self.backgroundNode = ASDisplayNode(viewBlock: { () -> UIView in return cardView })
        self.backgroundNode.backgroundColor = Constants.kMainShade
        
        super.init()
        self.selectionStyle = .None
        followSwitch.delegate = self
        
        self.addSubnode(self.backgroundNode)
        self.addSubnode(self.profilePicNode)
        self.addSubnode(self.nameNode)
        self.addSubnode(self.ratingsNode)
        self.addSubnode(self.switchNode)
    }
    
    //MARK: Methods
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.profilePicNode.flexBasis = ASRelativeDimension(type: .Points, value: 50)
        self.nameNode.flexBasis = ASRelativeDimension(type: .Percent, value: 0.42)
        self.ratingsNode.flexBasis = ASRelativeDimension(type: .Percent, value: 0.2)
        self.switchNode.flexBasis = ASRelativeDimension(type: .Percent, value: 0.12)
        
        let horizontalStack = ASStackLayoutSpec(
            direction: .Horizontal,
            spacing: Constants.kPadding,
            justifyContent: .Start,
            alignItems: .Center,
            children: [self.profilePicNode, self.nameNode, self.ratingsNode])
        horizontalStack.flexBasis = ASRelativeDimension(type: .Percent, value: 0.9)
        
        return ASBackgroundLayoutSpec(child: ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(Constants.kPadding, Constants.kPadding, Constants.kPadding, Constants.kPadding),
            child: horizontalStack),
            background: self.backgroundNode)
    }
    
    override func layoutDidFinish() {
        super.layoutDidFinish()
        RatingsViewModel().getCelScoreSignal(ratingsId: self.celebST.id)
            .startWithNext({ score in self.setupCircleLayer(positive: score < self.celebST.prevScore ? false : true) })
    }

    func setupCircleLayer(positive positive: Bool) {
        let radius: CGFloat = (self.profilePicNode.frame.width - 2) / 2
        let centerX: CGFloat = self.profilePicNode.frame.centerX - 10
        let centerY: CGFloat = self.profilePicNode.frame.centerY - 10
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: Constants.degreeToRadian(-90.0), endAngle: Constants.degreeToRadian(-90 + 360.0), clockwise: true)
        
        let pathLayer = CAShapeLayer()
        pathLayer.path = circlePath.CGPath
        pathLayer.fillColor = UIColor.clearColor().CGColor
        pathLayer.lineWidth = 2.5
        
        pathLayer.strokeColor = positive ? Constants.kLightGreenShade.CGColor : Constants.kWineShade.CGColor
        pathLayer.strokeStart = 0.0
        pathLayer.strokeEnd = 1.0
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 1.1
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathLayer.addAnimation(pathAnimation, forKey: "strokeEndAnimation")
        self.profilePicNode.layer.addSublayer(pathLayer)
    }
    
    func getId() -> String { return celebST.id }
    
    //MARK: MaterialSwitchDelegate
    func materialSwitchStateChanged(control: MaterialSwitch) {
        if control.switchState == .Off { CelebrityViewModel().followCebritySignal(id: self.celebST.id, isFollowing: false).start() }
        else {
            CelebrityViewModel().countFollowedCelebritiesSignal()
                .startWithNext { count in
                    if count == 0 { SettingsViewModel().getSettingSignal(settingType: .FirstFollow).startWithNext({ first in
                        CelebrityViewModel().followCebritySignal(id: self.celebST.id, isFollowing: true).start()
                        let firstTime = first as! Bool
                        if firstTime {
                            TAOverlay.showOverlayWithLabel(OverlayInfo.FirstFollow.message(),
                                image: OverlayInfo.FirstFollow.logo(),
                                options: OverlayInfo.getOptions())}})
                            TAOverlay.setCompletionBlock({ _ in SettingsViewModel().updateSettingSignal(value: false, settingType: .FirstFollow).start() })
                    }
                    else if count > 9 {
                        TAOverlay.showOverlayWithLabel(OverlayInfo.MaxFollow.message(),
                            image: OverlayInfo.MaxFollow.logo(),
                            options: OverlayInfo.getOptions())
                        TAOverlay.setCompletionBlock({ _ in control.setOn(false, animated: true) })
                    } else { CelebrityViewModel().followCebritySignal(id: self.celebST.id, isFollowing: true).start() }
            }
        }
    }
}
