//
//  DetailViewController.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 11/2/15.
//  Copyright © 2015 Gareth.K.Mensah. All rights reserved.
//

import AsyncDisplayKit
import Material
import SMSegmentView
import Social
import ReactiveCocoa
import ReactiveSwift
import MessageUI
import Material
import Result


final class DetailViewController: UIViewController, DetailSubViewable, Sociable, Labelable, MFMailComposeViewControllerDelegate, CAAnimationDelegate {
    
    //MARK: Properties
    fileprivate let infoVC: InfoViewController
    fileprivate let ratingsVC: RatingsViewController
    fileprivate let celscoreVC: CelScoreViewController
    fileprivate let voteButton: Button
    fileprivate let celebST: CelebrityStruct
    fileprivate let socialButton: MenuController
    fileprivate var socialMessage: String = ""
    fileprivate var previousIndex: Int = 1
    internal let profilePicNode: ASNetworkImageNode
    
    //MARK: Initializers
    required init(coder aDecoder: NSCoder) { fatalError("storyboards are incompatible with truth and beauty") }
    
    init(celebrityST: CelebrityStruct) {
        self.celebST = celebrityST
        self.infoVC = InfoViewController(celebrityST: self.celebST)
        self.ratingsVC = RatingsViewController(celebrityST: self.celebST)
        self.celscoreVC = CelScoreViewController(celebrityST: self.celebST)
        self.voteButton = Button()
        self.socialButton = MenuController()
        self.profilePicNode = ASNetworkImageNode(webImage: ())
        super.init(nibName: nil, bundle: nil)
        CelebrityViewModel().updateUserActivitySignal(id: self.celebST.id)
            .start(on: QueueScheduler())
            .flatMapError { _ in SignalProducer.empty }
            .startWithValues({ activity in self.userActivity = activity })
        
        RatingsViewModel().cleanUpRatingsSignal(ratingsId: self.celebST.id).start()
    }
    
    //MARK: Methods
    override var prefersStatusBarHidden : Bool { return true }
    override func updateUserActivityState(_ activity: NSUserActivity) { activity.becomeCurrent() }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ratingsVC.delegate = self
        self.infoVC.delegate = self
        self.celscoreVC.delegate = self
        
        let navigationBarView: Toolbar = getNavigationView()
        let topView: View = getTopView()
        let segmentView: SMSegmentView = getSegmentView()
        self.setUpVoteButton()
        self.setUpSocialButton(menuView: self.socialButton, origin: CGPoint(x: -100, y: Constants.kTopViewRect.bottom - 35), buttonColor: Constants.kStarGoldShade)
        let first: Button? = self.socialButton.menu.views.first as? Button
        SettingsViewModel().getSettingSignal(settingType: .publicService)
            .startWithValues({ status in
                if (status as! Bool) == true {
                    first?.setImage(R.image.ic_add_black()!, for: .normal)
                    first?.setImage(R.image.ic_add_black()!, for: .highlighted)
                } else {
                    first?.setImage(R.image.cross()!, for: .normal)
                    first?.setImage(R.image.cross()!, for: .highlighted)
                }
            })
        
        RatingsViewModel().hasUserRatingsSignal(ratingsId: self.celebST.id)
            .flatMapError { _ in SignalProducer.empty }
            .startWithValues({ hasRatings in first?.backgroundColor = hasRatings ? Constants.kStarGoldShade : Constants.kGreyBackground
        })
        
        let statusView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.kScreenWidth, height: 20))
        statusView.backgroundColor = Constants.kBlueShade
        
        self.profilePicNode.url = URL(string: celebST.imageURL)
        self.profilePicNode.frame = CGRect(x: self.view.centerX - UIDevice.getProfileDiameter()/2,
                                           y: topView.centerY - UIDevice.getProfileDiameter()/2,
                                           width: UIDevice.getProfileDiameter(),
                                           height: UIDevice.getProfileDiameter())
        self.profilePicNode.cornerRadius = UIDevice.getProfileDiameter()/2
        topView.clipsToBounds = false

        self.view.addSubview(statusView)
        self.view.addSubview(navigationBarView)
        self.view.sendSubview(toBack: navigationBarView)
        self.view.addSubview(topView)
        self.view.addSubview(segmentView)
        self.view.addSubview(self.socialButton.menu)
        //Layout.size(parent: self.view, child: self.socialButton.menu, size: CGSize(width: Constants.kFabDiameter, height: Constants.kFabDiameter))
        self.view.addSubview(self.voteButton)
        self.view.addSubview(self.profilePicNode.view)
        self.view.addSubview(self.infoVC.view)
        self.view.addSubview(self.ratingsVC.view)
        self.view.addSubview(self.celscoreVC.view)
        self.view.backgroundColor = Constants.kBlueShade
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showingButtons()
    }
    
    func showingButtons() {
        let first: Button? = self.socialButton.menu.views.first as? Button
        first!.animate(animation: Motion.animate(group: [
            Motion.rotate(rotation: 3),
            Motion.translationX(by: Constants.kPadding + 100)
            ]))
        
        self.voteButton.animate(animation: Motion.animate(group: [
            Motion.rotate(rotation: 3),
            Motion.translationX(by: -(Constants.kFabDiameter + 100))
            ]))
        
        for subview in self.socialButton.menu.views.enumerated() {
            if subview.element.tag == 1 || subview.element.tag == 2 {
                subview.element.frame.offsetBy(dx: Constants.kPadding + 100, dy: 0)
            }
        }
    }
    
    func hideButtons() {
        let first: Button? = self.socialButton.menu.views.first as? Button
        first!.animate(animation: Motion.animate(group: [
            Motion.rotate(rotation: 3),
            Motion.translationX(by: -(Constants.kPadding + 100))
            ]))
        
        self.voteButton.animate(animation: Motion.animate(group: [
            Motion.rotate(rotation: 3),
            Motion.translationX(by: Constants.kFabDiameter + 100)
            ]))
    }
    
    func backAction() {
        self.hideButtons()
        RatingsViewModel().cleanUpRatingsSignal(ratingsId: self.celebST.id).start()
        Motion.delay(time: 0.15){ self.dismiss(animated: true, completion: nil) }
    }
    
    func infoAction() {
       TAOverlay.show(withLabel: OverlayInfo.infoSource.message(), image: OverlayInfo.infoSource.logo(), options: OverlayInfo.getOptions())
    }
    
    func helpAction() {
        TAOverlay.show(withLabel: OverlayInfo.voteHelp.message(), image: OverlayInfo.voteHelp.logo(), options: OverlayInfo.getOptions())
    }
    
    func voteAction() {
        RatingsViewModel().getRatingsSignal(ratingsId: self.celebST.id, ratingType: .userRatings)
            .filter({ (ratings: RatingsModel) -> Bool in return ratings.filter{ (ratings[$0] as! Int) == 0 }.isEmpty })
            .flatMap(.latest) { (ratings: RatingsModel) -> SignalProducer<RatingsModel, RatingsError> in
                return RatingsViewModel().voteSignal(ratingsId: self.celebST.id) }
            .observe(on: UIScheduler())
            .map { userRatings in
                let first: Button? = self.socialButton.menu.views.first as? Button
                first?.backgroundColor = Constants.kStarGoldShade
                self.enableUpdateButton()
                self.rippleEffect(positive: false, gold: true)
                self.ratingsVC.animateStarsToGold(positive: userRatings.getCelScore() < 3 ? false : true)
                Motion.delay(time: 2.5) {
                    self.voteButton.backgroundColor = Constants.kStarGoldShade
                    self.voteButton.setImage(R.image.heart_black()!, for: .normal)
                    self.voteButton.setImage(R.image.heart_black()!, for: .highlighted)
                }}
            .delay(2.1, on: QueueScheduler.main)
            .flatMapError { _ in SignalProducer.empty }
            .flatMap(.latest) { (_) -> SignalProducer<AnyObject, NoError> in
                return SettingsViewModel().getSettingSignal(settingType: .consensusBuilding)}
            .filter({ (value: AnyObject) -> Bool in let isConsensus = value as! Bool
                if isConsensus == false {
                    SettingsViewModel().calculateUserRatingsPercentageSignal().startWithValues { value in
                        if value > 99.0 { TAOverlay.show(withLabel: "Thank you for voting!", image: R.image.mic_yellow(), options: OverlayInfo.getOptions()) }
                        else { TAOverlay.show(withLabel: "Thank you for voting!", image: R.image.mic_red(), options: OverlayInfo.getOptions()) }
                        TAOverlay.setCompletionBlock({ _ in self.trollAction() })
                    }
                }
                return isConsensus })
            .flatMapError { _ in SignalProducer.empty }
            .flatMap(.latest) { (value: AnyObject) -> SignalProducer<String, RatingsError> in
                return RatingsViewModel().consensusBuildingSignal(ratingsId: self.celebST.id)}
            .map { message in
                SettingsViewModel().calculateUserRatingsPercentageSignal().startWithValues { value in
                    if value > 99.0 { TAOverlay.show(withLabel: message, image: R.image.sphere_yellow(), options: OverlayInfo.getOptions()) }
                    else { TAOverlay.show(withLabel: message, image: R.image.sphere_blue(), options: OverlayInfo.getOptions()) }
                    TAOverlay.setCompletionBlock({ _ in self.trollAction() })
                }
            }
            .start()
    }
    
    func trollAction() {
        Motion.delay(time: 0.5) {
            SettingsViewModel().calculateUserAverageCelScoreSignal()
                .filter({ (score:CGFloat) -> Bool in
                    if score > Constants.kTrollingWarning { self.progressAction() }
                    return score < Constants.kTrollingWarning })
                .flatMap(.latest) { (score:CGFloat) -> SignalProducer<AnyObject, NoError> in
                    return SettingsViewModel().getSettingSignal(settingType: .firstTrollWarning) }
                .map { first in let firstTime = first as! Bool
                    guard firstTime else { return }
                    TAOverlay.show(withLabel: OverlayInfo.firstTrollWarning.message(), image: OverlayInfo.firstTrollWarning.logo(), options: OverlayInfo.getOptions())
                    TAOverlay.setCompletionBlock({ _ in SettingsViewModel().updateSettingSignal(value: false as AnyObject, settingType: .firstTrollWarning).start() })
                    }
                .start()
        }
    }
    
    func progressAction() {
        SettingsViewModel().calculateUserRatingsPercentageSignal().startWithValues({ value in
            switch value * 100.0 {
            case 100.0:
                SettingsViewModel().getSettingSignal(settingType: .firstCompleted).startWithValues({ first in let firstTime = first as! Bool
                    guard firstTime else { return }
                    TAOverlay.show(withLabel: OverlayInfo.firstCompleted.message(), image: OverlayInfo.firstCompleted.logo(), options: OverlayInfo.getOptions())
                    TAOverlay.setCompletionBlock({ _ in SettingsViewModel().updateSettingSignal(value: false as AnyObject, settingType: .firstCompleted).start() })
                })
            case 75.0..<100.0:
                SettingsViewModel().getSettingSignal(settingType: .first75).startWithValues({ first in let firstTime = first as! Bool
                    guard firstTime else { return }
                    TAOverlay.show(withLabel: OverlayInfo.first75.message(), image: OverlayInfo.first75.logo(), options: OverlayInfo.getOptions())
                    TAOverlay.setCompletionBlock({ _ in SettingsViewModel().updateSettingSignal(value: false as AnyObject, settingType: .first75).start() })
                })
            case 50.0..<75.0:
                SettingsViewModel().getSettingSignal(settingType: .first50).startWithValues({ first in let firstTime = first as! Bool
                    guard firstTime else { return }
                    TAOverlay.show(withLabel: OverlayInfo.first50.message(), image: OverlayInfo.first50.logo(), options: OverlayInfo.getOptions())
                    TAOverlay.setCompletionBlock({ _ in SettingsViewModel().updateSettingSignal(value: false as AnyObject, settingType: .first50).start() })
                })
            case 25.0..<50.0:
                SettingsViewModel().getSettingSignal(settingType: .first25).startWithValues({ first in let firstTime = first as! Bool
                    guard firstTime else { return }
                    TAOverlay.show(withLabel: OverlayInfo.first25.message(), image: OverlayInfo.first25.logo(), options: OverlayInfo.getOptions())
                    TAOverlay.setCompletionBlock({ _ in SettingsViewModel().updateSettingSignal(value: false as AnyObject, settingType: .first25).start() })
                })
            default: break
            }
        })
    }
    
    func updateAction() {
        RatingsViewModel().getRatingsSignal(ratingsId: self.celebST.id, ratingType: .userRatings)
            .observe(on: UIScheduler())
            .flatMapError { _ in SignalProducer.empty }
            .startWithValues({ (userRatings:RatingsModel) in
                self.rippleEffect(positive: false, gold: true)
                self.enableVoteButton(positive: userRatings.getCelScore() < 3.0 ? false : true)
                self.ratingsVC.displayUserRatings(userRatings)
            })
    }
    
    //MARK: Sociable
    func handleMenu(_ open: Bool = false) {
        if open { self.openHandleMenu() }
        else if self.socialButton.menu.isOpened { self.closeHandleMenu() }
        else { TAOverlay.show(withLabel: OverlayInfo.noSharing.message(), image: OverlayInfo.noSharing.logo(), options: OverlayInfo.getOptions()) }
    }
    
    func menu(menu: Menu, tappedAt point: CGPoint, isOutside: Bool) {
        print("YAYA TOURE 2")
    }
    
    func openHandleMenu() {
        let first: Button? = self.socialButton.menu.views.first as? Button
        first?.backgroundColor = Constants.kBlueShade
        first?.pulseAnimation = .centerWithBacking
        first?.animate(animation: Motion.rotate(rotation: 1))
        self.socialButton.menu.open()
        let image = R.image.ic_close_white()?.withRenderingMode(.alwaysTemplate)
        first?.setImage(image, for: .normal)
        first?.setImage(image, for: .highlighted)
    }
    
    func closeHandleMenu() {
       let first: Button? = self.socialButton.menu.views.first as? Button
        if self.socialButton.menu.isOpened { first?.animate(animation: Motion.rotate(rotation: 1)) }
        self.socialButton.menu.close()
        SettingsViewModel().getSettingSignal(settingType: .publicService)
            .observe(on: UIScheduler())
            .startWithValues({ status in
                if (status as! Bool) == true {
                    first?.setImage(R.image.ic_add_black()!, for: .normal)
                    first?.setImage(R.image.ic_add_black()!, for: .highlighted)
                } else {
                    first?.setImage(R.image.cross()!, for: .normal)
                    first?.setImage(R.image.cross()!, for: .highlighted)
                }
            })
        RatingsViewModel().hasUserRatingsSignal(ratingsId: self.celebST.id).startWithValues({ hasRatings in
            first?.backgroundColor = hasRatings ? Constants.kStarGoldShade : Constants.kGreyBackground
        })
    }
    
    func socialButton(_ button: UIButton) {
        SettingsViewModel().loggedInAsSignal()
            .flatMapError { _ in
                self.socialButtonTapped(buttonTag: button.tag, hideButton: false)
                return SignalProducer.empty }
            .startWithValues { _ in
                CelScoreViewModel().shareVoteOnSignal(socialLogin: (button.tag == 1 ? .facebook: .twitter), message: self.socialMessage).startWithValues { socialVC in
                    let isFacebookAvailable: Bool = SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)
                    let isTwitterAvailable: Bool = SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
                    guard (button.tag == 1 ? isFacebookAvailable : isTwitterAvailable) == true else {
                        TAOverlay.show(withLabel: SocialLogin(rawValue: button.tag)!.serviceUnavailable(),
                                       image: OverlayInfo.loginError.logo(), options: OverlayInfo.getOptions())
                        return }
                    self.present(socialVC, animated: true, completion: { Motion.delay(time: 2.0) { self.socialButton.menu.close() }})
                }}
    }
    
    func socialRefresh() {
        RatingsViewModel().getRatingsSignal(ratingsId: self.celebST.id, ratingType: .userRatings)
            .observe(on: UIScheduler())
            .flatMapError { _ in
                self.ratingsVC.displayRatings()
                return SignalProducer.empty }
            .startWithValues({ userRatings in
                self.ratingsVC.displayRatings(userRatings)
                guard userRatings.getCelScore() > 0 else { return }
                self.enableUpdateButton()
                self.voteButton.backgroundColor = Constants.kStarGoldShade
                self.voteButton.setImage(R.image.heart_black()!, for: .normal)
                self.voteButton.setImage(R.image.heart_black()!, for: .highlighted)
            })
    }
    
    func enableUpdateButton() {
        self.voteButton.pulseAnimation = .centerWithBacking
        self.voteButton.backgroundColor = Constants.kStarGoldShade
        self.voteButton.setImage(R.image.heart_black()!, for: .normal)
        self.voteButton.setImage(R.image.heart_black()!, for: .highlighted)
        self.voteButton.removeTarget(self, action: #selector(DetailViewController.voteAction), for: .touchUpInside)
        self.voteButton.addTarget(self, action: #selector(DetailViewController.updateAction), for: .touchUpInside)
        
        Motion.delay(time: 1) {
            self.voteButton.pulseAnimation = .centerWithBacking
            self.voteButton.pulse()
        }
    }

    func disableVoteButton(_ image: UIImage) {
        self.voteButton.setImage(image, for: .normal)
        self.voteButton.setImage(image, for: .highlighted)
        self.voteButton.removeTarget(self, action: nil, for: .touchUpInside)
        self.voteButton.addTarget(self, action: #selector(DetailViewController.helpAction), for: .touchUpInside)
        RatingsViewModel().hasUserRatingsSignal(ratingsId: self.celebST.id).startWithValues({ hasRatings in
            self.voteButton.tintColor = hasRatings ? Constants.kStarGoldShade : Constants.kGreyBackground
            self.voteButton.backgroundColor = hasRatings ? Constants.kStarGoldShade : Constants.kGreyBackground
        })
    }
    
    //MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: SMSegmentViewDelegate
    func segmentView(_ segmentView: SMSegmentView) {
        let infoView: UIView = self.getSubView(atIndex: segmentView.selectedSegmentIndex)
        infoView.isHidden = false
        infoView.frame = Constants.kBottomViewRect
        let removingView = self.getSubView(atIndex: previousIndex)
        
        if segmentView.selectedSegmentIndex == 0 || (segmentView.selectedSegmentIndex == 1 && self.previousIndex == 2 ){ self.slide(right: false, newView: infoView, oldView: removingView) }
        else { self.slide(right: true, newView: infoView, oldView: removingView) }
        self.closeHandleMenu()
        
        if segmentView.selectedSegmentIndex == 2 {
            RatingsViewModel().getRatingsSignal(ratingsId: self.celebST.id, ratingType: .userRatings)
                .flatMapError { _ in SignalProducer.empty }
                .startWithValues({ userRatings in
                guard userRatings.getCelScore() > 0 else { return }
                if self.ratingsVC.isUserRatingMode() { self.enableVoteButton(positive: userRatings.getCelScore() < 3.0 ? false : true) }
                else { self.enableUpdateButton() }
            })
        } else { disableVoteButton(R.image.heart_black()!) }
        self.previousIndex = segmentView.selectedSegmentIndex
    }
    
    func slide(right: Bool, newView: UIView, oldView: UIView) {
        UIView.animate(withDuration: 1.0, animations: { _ in
            if right { oldView.left = -newView.width; newView.slide(right: true, duration: 1.0, completionDelegate: self) }
            else { oldView.left = newView.width + 45; newView.slide(right: false, duration: 1.0, completionDelegate: self) }
        })
    }
    
    func getSubView(atIndex index: Int) -> UIView {
        let subview: UIView
        switch index {
        case 1: subview = self.infoVC.view
        case 2: subview = self.ratingsVC.view
        default: subview = self.celscoreVC.view
        }
        return subview
    }
    
    //MARK: RatingsViewDelegate
    func rippleEffect(positive: Bool, gold: Bool = false) {
        if gold { self.profilePicNode.view.rippleColor = Constants.kStarGoldShade }
        else { self.profilePicNode.view.rippleColor = positive ? Constants.kBlueText : Constants.kRedText }
        self.profilePicNode.view.rippleTrailColor = Color.clear
        self.profilePicNode.view.dya_ripple(self.profilePicNode.view.bounds.center)
    }
    
    func enableVoteButton(positive: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.voteButton.setImage(R.image.heart_white()!, for: .normal)
            self.voteButton.setImage(R.image.heart_white()!, for: .highlighted)
            self.voteButton.removeTarget(self, action: #selector(DetailViewController.updateAction), for: .touchUpInside)
            self.voteButton.addTarget(self, action: #selector(DetailViewController.voteAction), for: .touchUpInside)
            self.voteButton.backgroundColor = positive == true ? Constants.kBlueLight : Constants.kRedLight },
            completion: { _ in Motion.delay(time: 2) {
                self.voteButton.pulseAnimation = .centerWithBacking
                self.voteButton.pulse() }
        })
    }

    func socialSharing(message: String) {
        self.openHandleMenu()
        self.socialMessage = message
    }
    
    //MARK: ViewDidLoad Helpers
    func getNavigationView() -> Toolbar {
        let backButton: FlatButton = FlatButton()
        backButton.pulseColor = Color.white
        backButton.setTitle("BACK", for: .normal)
        backButton.setTitleColor(Color.clear, for: .normal)
        backButton.pulseAnimation = .none
        backButton.accessibilityLabel = "Back Button"
        backButton.isAccessibilityElement = true
        backButton.setImage(R.image.arrow_white()!, for: .normal)
        backButton.setImage(R.image.arrow_white()!, for: .highlighted)
        backButton.addTarget(self, action: #selector(DetailViewController.backAction), for: .touchUpInside)
        
        let infoButton: FlatButton = FlatButton()
        infoButton.pulseColor = Color.white
        infoButton.pulseAnimation = .none
        infoButton.accessibilityLabel = "Info Button"
        infoButton.isAccessibilityElement = true
        infoButton.setImage(R.image.info_button()!, for: .normal)
        infoButton.setImage(R.image.info_button()!, for: .highlighted)
        infoButton.addTarget(self, action: #selector(DetailViewController.infoAction), for: .touchUpInside)
        
        let navigationBarView: Toolbar = Toolbar()
        navigationBarView.frame = Constants.kDetailNavigationBarRect
        if self.celebST.nickname.characters.count > 13 {
            let decomposedName = self.celebST.nickname.components(separatedBy: " ")
            let index = decomposedName[1].index(decomposedName[1].startIndex, offsetBy: 1)
            let lastName = String("\(decomposedName[0]) \(decomposedName[1].substring(to: index)).")
            let title = self.celebST.nickname.characters.count > 13 ? lastName : self.celebST.nickname
            navigationBarView.title = "★  " + title! + "   ★"
        } else { navigationBarView.title = "★  " + self.celebST.nickname + "   ★" }
    
        navigationBarView.titleLabel.textColor = UIColor.white
        navigationBarView.titleLabel.adjustsFontSizeToFitWidth = true
        navigationBarView.leftViews = [backButton]
        navigationBarView.rightViews = [infoButton]
        navigationBarView.depthPreset = .depth3
        navigationBarView.backgroundColor = Constants.kRedShade
        return navigationBarView
    }
    
    func getTopView() -> View {
        let topView: View = View(frame: Constants.kTopViewRect)
        topView.depthPreset = .depth2
        topView.backgroundColor = Constants.kBlueShade
        topView.isOpaque = true
        topView.image = R.image.topView()
        return topView
    }
    
    func getSegmentView() -> SMSegmentView {
        let appearance = SMSegmentAppearance()
        appearance.segmentOnSelectionColour = Constants.kRedShade
        appearance.segmentOffSelectionColour = Constants.kGreyBackground
        appearance.titleOnSelectionFont = UIFont.systemFont(ofSize: 0)
        appearance.titleOffSelectionFont = UIFont.systemFont(ofSize: 0)
        appearance.contentVerticalMargin = 5.0
        
        let segmentView: SMSegmentView = SMSegmentView(frame: Constants.kSegmentViewRect,
                                                       dividerColour: Color.black,
                                                       dividerWidth: 1,
                                                       segmentAppearance: appearance)
        
        segmentView.addSegmentWithTitle(nil, onSelectionImage: R.image.scale_white()!, offSelectionImage: R.image.scale_black()!)
        segmentView.addSegmentWithTitle(nil, onSelectionImage: R.image.info_white()!, offSelectionImage: R.image.info_black()!)
        segmentView.addSegmentWithTitle(nil, onSelectionImage: R.image.star_icon()!, offSelectionImage: R.image.star_black()!)
        segmentView.addTarget(self, action: #selector(self.segmentView(_:)), for: .valueChanged)
        segmentView.selectedSegmentIndex = 0
        segmentView.clipsToBounds = false
        segmentView.layer.shadowColor = Color.black.cgColor
        segmentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        segmentView.layer.shadowOpacity = 0.3
        return segmentView
    }
    
    func setUpVoteButton() {
        let diameter: CGFloat = Constants.kFabDiameter
        self.voteButton.frame = CGRect(x: Constants.kMaxWidth + 100, y: Constants.kTopViewRect.bottom - 35, width: diameter, height: diameter)
        self.voteButton.shapePreset = .circle
        self.voteButton.depthPreset = .depth2
        self.voteButton.pulseAnimation = .center
        self.voteButton.accessibilityLabel = "Vote Button"
        self.disableVoteButton(R.image.heart_black()!)
        RatingsViewModel().hasUserRatingsSignal(ratingsId: self.celebST.id).startWithValues({ hasRatings in
            self.voteButton.tintColor = hasRatings ? Constants.kStarGoldShade : Constants.kGreyBackground
        })
    }
}




