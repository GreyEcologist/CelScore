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
import AIRTimer


final class CelebrityTableViewCell: ASCellNode {
    
    //MARK: Properties
    let celebST: CelebrityStruct
    let nameNode: ASTextNode
    let profilePicNode: ASNetworkImageNode
    let ratingsNode: ASDisplayNode
    let switchNode: ASDisplayNode
    let backgroundNode: ASDisplayNode
    let circleLayer = CAShapeLayer()
    let pathLayer = CAShapeLayer()
    var timer: AIRTimer?
    
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
        RatingsViewModel().hasUserRatingsSignal(ratingsId: self.celebST.id)
            .on(next: { (hasRatings:Bool) in
                cosmosView.settings.colorFilled = hasRatings ? Constants.kStarRatingShade : MaterialColor.white
                cosmosView.settings.borderColorEmpty = hasRatings ? Constants.kStarRatingShade : MaterialColor.white
            })
            .start()
        let followSwitch = MaterialSwitch(size: .Small, state: .Off)
        followSwitch.center = CGPoint(x: Constants.kScreenWidth - 50, y: 32)
        followSwitch.buttonOnColor = Constants.kWineShade
        followSwitch.trackOnColor = followSwitch.trackOffColor
        self.switchNode = ASDisplayNode(viewBlock: { () -> UIView in return followSwitch })
        self.switchNode.preferredFrameSize = CGSize(width: 20, height: 20)
        
        let cardView: MaterialView = MaterialView()
        cardView.borderWidth = 2.0
        cardView.borderColor = Constants.kDarkShade
        self.backgroundNode = ASDisplayNode(viewBlock: { () -> UIView in return cardView })
        self.backgroundNode.backgroundColor = Constants.kMainShade
        
        super.init()
        
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
        timer = AIRTimer.every(Constants.kAnimationInterval){ _ in self.setupCircleLayer() }
    }
    
    func restartClock() {
        self.circleLayer.removeFromSuperlayer()
        self.timer?.invalidate()
        self.setupCircleLayer()
        self.timer?.restart()
    }
    
    func setupCircleLayer() {
        let radius: CGFloat = (self.profilePicNode.frame.width - 2) / 2
        let centerX: CGFloat = self.profilePicNode.frame.centerX - 10
        let centerY: CGFloat = self.profilePicNode.frame.centerY - 10
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: degreeToRadian(-90.0), endAngle: degreeToRadian(-90 + 360.0), clockwise: true)
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.path = circlePath.CGPath
        animation.duration = 1//Constants.kAnimationInterval
        
        self.circleLayer.bounds = CGRect(x: 0, y: 0, width: 7, height: 7)
        self.circleLayer.path = UIBezierPath(roundedRect: self.circleLayer.bounds, cornerRadius: 3.5).CGPath
        self.circleLayer.fillColor = Constants.kWineShade.CGColor
        self.circleLayer.addAnimation(animation, forKey: "strokeEndAnimation")
        
        self.pathLayer.path = circlePath.CGPath
        self.pathLayer.fillColor = UIColor.clearColor().CGColor
        self.pathLayer.lineWidth = 2.5
        self.pathLayer.strokeColor = Constants.kWineShade.CGColor
        self.pathLayer.strokeStart = 0.0
        self.pathLayer.strokeEnd = 1.0
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 1//Constants.kAnimationInterval
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathLayer.addAnimation(pathAnimation, forKey: "strokeEndAnimation")
        
        self.profilePicNode.layer.addSublayer(self.circleLayer)
        self.profilePicNode.layer.addSublayer(self.pathLayer)
    }
    
    func degreeToRadian(degree: CGFloat) -> CGFloat { return CGFloat(M_PI / 180) * degree }
    func getId() -> String { return celebST.id }
}
