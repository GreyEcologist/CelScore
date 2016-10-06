//
//  RatingsViewController.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 2/1/16.
//  Copyright © 2016 Gareth.K.Mensah. All rights reserved.
//

import AsyncDisplayKit
import Material
import SwiftyTimer
import ReactiveCocoa
import ReactiveSwift


final class RatingsViewController: ASViewController<ASDisplayNode>, Labelable {
    
    //MARK: Properties
    fileprivate let celebST: CelebrityStruct
    fileprivate let pulseView: View
    internal var delegate: DetailSubViewable?
    
    //MARK: Initializers
    required init(coder aDecoder: NSCoder) { fatalError("storyboards are incompatible with truth and beauty") }
    
    init(celebrityST: CelebrityStruct) {
        self.celebST = celebrityST
        self.pulseView = View(frame: Constants.kBottomViewRect)
        super.init(node: ASDisplayNode())
        self.view.isHidden = true
    }
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupStars()
        self.pulseView.backgroundColor = Color.clear
        self.view = self.pulseView
    }
    
    func setupStars() {
        RatingsViewModel().getRatingsSignal(ratingsId: self.celebST.id, ratingType: .ratings)
            .startWithNext({ ratings in
                for (index, quality) in Qualities.getAll(isMale: self.celebST.sex).enumerated() {
                    let barHeight = UIDevice.getPulseBarHeight()
                    let qualityView = PulseView(frame: CGRect(x: 0, y: CGFloat(index) * (Constants.kBottomHeight / 10) + Constants.kPadding, width: Constants.kMaxWidth, height: barHeight))
                    qualityView.tag = index+1
                    qualityView.depthPreset = .depth1
                    qualityView.backgroundColor = Constants.kGreyBackground
                    qualityView.pulseAnimation = .centerWithBacking
                    qualityView.pulseColor = Color.clear
                    SettingsViewModel().getSettingSignal(settingType: .publicService)
                        .observe(on: UIScheduler())
                        .startWithNext({ status in
                            if (status as! Bool) == true {
                                qualityView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(RatingsViewController.longPress(_:)))) }
                        })
                    
                    let qualityLabel : UILabel = self.setupLabel(title: quality, frame: CGRect(x: Constants.kPadding, y: 3, width: 120, height: barHeight - 5))
                    qualityLabel.backgroundColor = UIColor.clear
                    let cosmosView = CosmosView(frame: CGRect(x: Constants.kMaxWidth - UIDevice.getStarsWidth(), y: 3, width: UIDevice.getStarsWidth(), height: barHeight - 5))
                    cosmosView.tag = index
                    switch quality {
                    case Qualities.talent.name(): cosmosView.rating = ratings.rating1
                    case Qualities.originality.name(): cosmosView.rating = ratings.rating2
                    case Qualities.authenticity.name(): cosmosView.rating = ratings.rating3
                    case Qualities.generosity.name(): cosmosView.rating = ratings.rating4
                    case Qualities.roleModel.name(): cosmosView.rating = ratings.rating5
                    case Qualities.hardWork.name(): cosmosView.rating = ratings.rating6
                    case Qualities.smarts.name(): cosmosView.rating = ratings.rating7
                    case Qualities.elegance.name(): cosmosView.rating = ratings.rating8
                    case Qualities.charisma.name() : cosmosView.rating = ratings.rating9
                    case Qualities.sexAppeal.name(): cosmosView.rating = ratings.rating10
                    default: cosmosView.rating = 3 }
                    cosmosView.settings.starSize = Double(barHeight) - 8
                    cosmosView.settings.starMargin = 5
                    cosmosView.settings.previousRating = Int(cosmosView.rating)
                    cosmosView.settings.updateOnTouch = false
                    cosmosView.settings.userRatingMode = false
                    SettingsViewModel().loggedInAsSignal()
                        .on(starting: { _ in cosmosView.settings.updateOnTouch = true })
                        .flatMapError { _ in SignalProducer.empty }
                        .flatMap(.latest){ (_) -> SignalProducer<Bool, NSError> in
                            return RatingsViewModel().hasUserRatingsSignal(ratingsId: self.celebST.id) }
                        .on(starting: { hasRatings in
                            cosmosView.settings.colorFilled = hasRatings ? Constants.kStarGoldShade : Constants.kStarGreyShade
                            cosmosView.settings.borderColorEmpty = Constants.kStarGreyShade
                            cosmosView.settings.updateOnTouch = hasRatings ? false : true })
                        .start()
                    cosmosView.didTouchCosmos = { (rating:Double) in
                        SettingsViewModel().loggedInAsSignal()
                            .observe(on: UIScheduler())
                            .on(failed: { _ in self.requestLogin() })
                            .flatMapError { _ in SignalProducer.empty }
                            .flatMap(.latest){ (_) -> SignalProducer<Bool, NSError> in
                                return RatingsViewModel().hasUserRatingsSignal(ratingsId: self.celebST.id) }
                            .filter{ hasUserRatings in
                                if hasUserRatings == false {
                                    cosmosView.settings.userRatingMode = true
                                    cosmosView.settings.updateOnTouch = true
                                    cosmosView.update()
                                }
                                return cosmosView.settings.userRatingMode == true }
                            .flatMapError { _ in SignalProducer.empty }
                            .flatMap(.latest) { (_) -> SignalProducer<RatingsModel, RatingsError> in
                                return RatingsViewModel().updateUserRatingSignal(ratingsId: self.celebST.id, ratingIndex: cosmosView.tag, newRating: Int(rating))}
                            .startWithNext({ userRatings in
                                self.delegate!.rippleEffect(positive: rating < 3 ? false : true, gold: false)
                                cosmosView.settings.updateOnTouch = true
                                cosmosView.settings.userRatingMode = true
                                let unrated = userRatings.filter{ (userRatings[$0] as! Int) == 0 }
                                if unrated.isEmpty { self.delegate!.enableVoteButton(positive: userRatings.getCelScore() < 3 ? false : true) }})
                    }
                    qualityView.addSubview(qualityLabel)
                    qualityView.addSubview(cosmosView)
                    self.pulseView.addSubview(qualityView)
                }
            })
    }
    
    func requestLogin() {
        SettingsViewModel().getSettingSignal(settingType: .firstVoteDisable).startWithNext({ first in let firstTime = first as! Bool
            guard firstTime else { return self.delegate!.socialSharing(message: "") }
            Animation.delay(time: 0.5) { TAOverlay.show(withLabel: OverlayInfo.firstVoteDisable.message(), image: OverlayInfo.firstVoteDisable.logo(), options: OverlayInfo.getOptions()) }
            TAOverlay.setCompletionBlock({ _ in
                self.delegate!.socialSharing(message: "")
                SettingsViewModel().updateSettingSignal(value: false as AnyObject, settingType: .firstVoteDisable).start()
            })
        })
    }
    
    func longPress(_ gesture: UIGestureRecognizer) {
        let ratingIndex = gesture.view!.tag - 1
        RatingsViewModel().getRatingsSignal(ratingsId: self.celebST.id, ratingType: .ratings)
            .startWithNext({ ratings in
                let value: Int = ratings[ratings[ratingIndex]] as! Int
                let stars: String = "\(value)" + (value < 2 ? " star" : " stars")
                let who: String = self.celebST.nickname.characters.last == "s" ? "\(self.celebST.nickname)'" : "\(self.celebST.nickname)'s"
                self.delegate!.socialSharing(message: "The consensus on \(who) \(Qualities(rawValue: ratingIndex)!.text()) \(stars)")})
    }
    
    func isUserRatingMode() -> Bool {
        let materialView: PulseView = self.view.subviews.first as! PulseView
        let stars = materialView.subviews.filter({ $0 is CosmosView })
        let cosmos: CosmosView = stars.first as! CosmosView
        return cosmos.settings.userRatingMode
    }
    
    func animateStarsToGold(positive: Bool) {
        RatingsViewModel().getRatingsSignal(ratingsId: self.celebST.id, ratingType: .ratings)
            .observe(on: UIScheduler())
            .on(starting: { ratings in
                let viewArray: [PulseView] = self.view.subviews.sorted(by: { $0.tag < $1.tag }) as! [PulseView]
                for (index, subview) in viewArray.enumerated() {
                    Timer.after(100.ms * Double(index)){ timer in
                        subview.pulse()
                        subview.pulseAnimation = .atPointWithBacking
                        let stars = subview.subviews.filter({ $0 is CosmosView })
                        let cosmos: CosmosView = stars.first as! CosmosView
                        cosmos.settings.colorFilled = Constants.kStarGoldShade
                        cosmos.settings.borderColorEmpty = Constants.kStarGreyShade
                        cosmos.settings.userRatingMode = false
                        cosmos.settings.updateOnTouch = false
                        cosmos.rating = ratings[ratings[index]] as! Double
                        cosmos.update()
                    }
                }})
            .start()
    }
    
    func displayRatings(_ userRatings: RatingsModel = RatingsModel()) {
        RatingsViewModel().getRatingsSignal(ratingsId: self.celebST.id, ratingType: .ratings)
            .startWithNext({ ratings in
                let viewArray: [PulseView] = self.view.subviews.sorted(by: { $0.tag < $1.tag }) as! [PulseView]
                for (index, subview) in viewArray.enumerated() {
                    let stars = subview.subviews.filter({ $0 is CosmosView })
                    let cosmos: CosmosView = stars.first as! CosmosView
                    cosmos.settings.colorFilled = userRatings.getCelScore() > 0 ? Constants.kStarGoldShade : Constants.kStarGreyShade
                    cosmos.settings.borderColorEmpty = Constants.kStarGreyShade
                    cosmos.settings.updateOnTouch = userRatings.getCelScore() > 0 ? false : true
                    cosmos.settings.userRatingMode = false
                    cosmos.rating = ratings[ratings[index]] as! Double
                    cosmos.update()
                }
            })
    }
    
    func displayUserRatings(_ userRatings: RatingsModel) {
        RatingsViewModel().getRatingsSignal(ratingsId: self.celebST.id, ratingType: .ratings)
            .startWithNext({ ratings in
                let viewArray: [PulseView] = self.view.subviews.sorted(by: { $0.tag < $1.tag }) as! [PulseView]
                for (index, subview) in viewArray.enumerated() {
                    subview.pulse()
                    subview.pulseAnimation = .atPointWithBacking
                    let stars = subview.subviews.filter({ $0 is CosmosView })
                    let cosmos: CosmosView = stars.first as! CosmosView
                    cosmos.settings.updateOnTouch = true
                    cosmos.settings.userRatingMode = true
                    cosmos.settings.borderColorEmpty = Constants.kStarGreyShade
                    cosmos.rating = userRatings[userRatings[index]] as! Double
                    cosmos.update()
                }
        })
    }
}
