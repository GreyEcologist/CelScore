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
import BEMCheckBox
import ReactiveCocoa
import ReactiveSwift
import Result


final class CelebrityTableViewCell: ASCellNode, BEMCheckBoxDelegate {
    
    //MARK: Properties
    fileprivate let ratingsNode: ASDisplayNode
    fileprivate let switchNode: ASDisplayNode
    fileprivate let backgroundNode: ASDisplayNode
    internal let nameNode: ASTextNode
    internal let trendNode: ASImageNode
    internal let consensusNode: ASImageNode
    internal let faceNode: ASImageNode
    internal let profilePicNode: ASNetworkImageNode
    internal let celebST: CelebrityStruct
    
    //MARK: Initializer
    init(celebrityStruct: CelebrityStruct) {
        self.celebST = celebrityStruct
        
        self.nameNode = ASTextNode()
        let attr = [NSFontAttributeName: UIFont.systemFont(ofSize: UIDevice.getFontSize() + 2), NSForegroundColorAttributeName : Color.black]
        self.nameNode.attributedString = NSMutableAttributedString(string: "\(celebST.nickname)", attributes: attr)
        self.nameNode.maximumNumberOfLines = 1
        self.nameNode.truncationMode = .byTruncatingTail
    
        self.profilePicNode = ASNetworkImageNode(webImage: ())
        self.profilePicNode.url = URL(string: self.celebST.imageURL)
        self.profilePicNode.defaultImage = R.image.anonymous()
        self.profilePicNode.contentMode = .scaleAspectFill
        self.profilePicNode.preferredFrameSize = CGSize(width: UIDevice.getRowHeight(), height: UIDevice.getRowHeight())
        
        let cosmosView: CosmosView = CosmosView()
        cosmosView.settings.starSize = 15
        cosmosView.settings.starMargin = 1.0
        cosmosView.settings.updateOnTouch = false
        self.ratingsNode = ASDisplayNode(viewBlock: { () -> UIView in return cosmosView })
        self.ratingsNode.preferredFrameSize = CGSize(width: 10, height: 20)
        RatingsViewModel().getCelScoreSignal(ratingsId: self.celebST.id).startWithValues { score in cosmosView.rating = score }
        RatingsViewModel().hasUserRatingsSignal(ratingsId: self.celebST.id)
            .flatMapError { error -> SignalProducer<Bool, NoError> in return .empty }
            .startWithValues{ hasRatings in
            cosmosView.settings.colorFilled = hasRatings ? Constants.kStarGoldShade : Constants.kStarGreyShade
            cosmosView.settings.borderColorEmpty = Constants.kStarGreyShade
        }
        
        let box: BEMCheckBox = BEMCheckBox(frame: CGRect(x: floor(UIDevice.getFollowCheckBoxPosition()), y: 30, width: 30, height: 30))
        box.onAnimationType = .bounce
        box.offAnimationType = .bounce
        box.onCheckColor = Color.white
        box.onFillColor = Constants.kRedShade
        box.onTintColor = Constants.kRedShade
        box.tintColor = Constants.kRedShade
        box.setOn(self.celebST.isFollowed, animated: true)
        self.switchNode = ASDisplayNode(viewBlock: { () -> UIView in return box })
        self.switchNode.preferredFrameSize = box.frame.size
        
        let cardView: PulseView = PulseView()
        cardView.borderWidth = 2.0
        cardView.borderColor = Constants.kBlueShade
        self.backgroundNode = ASDisplayNode(viewBlock: { () -> UIView in return cardView })
        self.backgroundNode.backgroundColor = Constants.kGreyBackground
        
        self.trendNode = ASImageNode()
        self.trendNode.preferredFrameSize = CGSize(width: Constants.kMiniCircleDiameter, height: Constants.kMiniCircleDiameter)
        
        self.consensusNode = ASImageNode()
        self.consensusNode.preferredFrameSize = CGSize(width: Constants.kMiniCircleDiameter, height: Constants.kMiniCircleDiameter)
        
        self.faceNode = ASImageNode()
        self.faceNode.preferredFrameSize = CGSize(width: Constants.kMiniCircleDiameter, height: Constants.kMiniCircleDiameter)
        
        super.init()
        self.selectionStyle = .none
        box.delegate = self
        
        RatingsViewModel().getCelScoreSignal(ratingsId: self.celebST.id).startWithValues { score in
            self.trendNode.image = score >= self.celebST.prevScore ? R.image.arrow_up()! : R.image.arrow_down()!
        }
        
        RatingsViewModel().getConsensusSignal(ratingsId: self.celebST.id).startWithValues { consensus in
            self.consensusNode.image = consensus >= Constants.kPositiveConsensus ? R.image.sphere_blue_mini()! : R.image.sphere_red_mini()!
        }
        
        RatingsViewModel().getRatingsSignal(ratingsId: self.celebST.id, ratingType: RatingsType.userRatings)
            .on(failed: { _ in self.faceNode.image = R.image.emptyCircle()! })
            .flatMapError { error -> SignalProducer<RatingsModel, NoError> in return .empty }
            .startWithValues ({ ratings in
                switch ratings.getCelScore() {
                case 4.5..<5.1: self.faceNode.image = R.image.happyFace()!
                case 3.5..<4.5: self.faceNode.image = R.image.smileFace()!
                case 3.0..<3.5: self.faceNode.image = R.image.nosmileFace()!
                case 2.0..<3.0: self.faceNode.image = R.image.sadFace()!
                case 1.0..<2.0: self.faceNode.image = R.image.angryFace()!
                default: self.faceNode.image = R.image.emptyCircle()!
                }
            })
        
        self.addSubnode(self.backgroundNode)
        self.addSubnode(self.profilePicNode)
        self.addSubnode(self.nameNode)
        self.addSubnode(self.ratingsNode)
        self.addSubnode(self.switchNode)
        self.addSubnode(self.trendNode)
        self.addSubnode(self.consensusNode)
        self.addSubnode(self.faceNode)
    }
    
    //MARK: Methods
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.profilePicNode.flexBasis = ASRelativeDimension(type: .points, value: UIDevice.getRowHeight())
        
        let minisStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: Constants.kPadding/2,
            justifyContent: .start,
            alignItems: .start,
            children: [self.trendNode, self.consensusNode, self.faceNode])
        minisStack.flexGrow = true
        
        let verticalStack = ASStackLayoutSpec(
        direction: .vertical,
        spacing: Constants.kPadding/4,
        justifyContent: .start,
        alignItems: .start,
        children: [self.nameNode, self.ratingsNode, minisStack])
        verticalStack.flexBasis = ASRelativeDimension(type: .percent, value: Constants.kVerticalStackPercent)
        verticalStack.flexGrow = true
        
        let horizontalStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: Constants.kPadding,
            justifyContent: .start,
            alignItems: .center,
            children: [self.profilePicNode, verticalStack, self.switchNode])
        horizontalStack.flexBasis = ASRelativeDimension(type: .percent, value: 1)
        
        return ASBackgroundLayoutSpec(child: ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: Constants.kPadding, left: Constants.kPadding, bottom: Constants.kPadding, right: 2*Constants.kPadding),
            child: horizontalStack),
            background: self.backgroundNode)
    }
    
    func getId() -> String { return celebST.id }
    
    //MARK: BEMCheckBoxDelegate
    func didTap(_ checkBox: BEMCheckBox) {
        self.updateCheckBox(checkBox)
        SettingsViewModel().updateTodayWidgetSignal().start()
    }
    
    func updateCheckBox(_ checkBox: BEMCheckBox) {
        if checkBox.on == false { CelebrityViewModel().followCebritySignal(id: self.celebST.id, isFollowing: false)
            .observe(on: UIScheduler())
            .start()
        } else {
            CelebrityViewModel().countFollowedCelebritiesSignal()
                .observe(on: UIScheduler())
                .flatMapError { error -> SignalProducer<Int, NoError> in return .empty }
                .startWithValues { count in
                    if count == 0 {
                        SettingsViewModel().getSettingSignal(settingType: .firstFollow).startWithValues({ first in
                        CelebrityViewModel().followCebritySignal(id: self.celebST.id, isFollowing: true).start()
                        let firstTime = first as! Bool
                        guard firstTime else { return }
                        TAOverlay.show(withLabel: OverlayInfo.firstFollow.message(), image: OverlayInfo.firstFollow.logo(), options: OverlayInfo.getOptions()) })
                        TAOverlay.setCompletionBlock({ _ in SettingsViewModel().updateSettingSignal(value: false as AnyObject, settingType: .firstFollow).start() })
                    }
                    else if count > 9 {
                        TAOverlay.show(withLabel: OverlayInfo.maxFollow.message(),
                                       image: OverlayInfo.maxFollow.logo(),
                                       options: OverlayInfo.getOptions())
                        TAOverlay.setCompletionBlock({ _ in checkBox.setOn(false, animated: true) })
                    } else { CelebrityViewModel().followCebritySignal(id: self.celebST.id, isFollowing: true).start() }
            }
        }
    }
}
