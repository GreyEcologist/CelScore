//
//  Socialized.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 3/22/16.
//  Copyright © 2016 Gareth.K.Mensah. All rights reserved.
//

import Foundation
import Material
import SVProgressHUD
import TwitterKit
import FBSDKLoginKit
import ReactiveCocoa
import RevealingSplashView
import PMAlertController
import MessageUI

protocol DetailSubViewable {
    func socialSharing(message message: String)
    func enableVoteButton(positive positive: Bool)
    func rippleEffect(positive positive: Bool, gold: Bool)
}

@objc protocol HUDable{}

extension HUDable{
    func showHUD() {
        SVProgressHUD.setDefaultStyle(.Custom)
        SVProgressHUD.setRingThickness(4)
        SVProgressHUD.setDefaultMaskType(.Black)
        SVProgressHUD.setBackgroundColor(Constants.kMainShade)
        SVProgressHUD.setForegroundColor(MaterialColor.white)
        SVProgressHUD.show()
    }
    
    func dismissHUD() { SVProgressHUD.dismiss() }
}

protocol Labelable{}

extension Labelable {
    func setupLabel(title title: String, frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = title
        label.textColor = MaterialColor.white
        label.backgroundColor = Constants.kMainShade
        label.font = UIFont(name: label.font.fontName, size: Constants.kFontSize)
        return label
    }
}

@objc protocol Sociable: HUDable, MFMailComposeViewControllerDelegate {
    var socialButton: MenuView { get }
    @objc func handleMenu(open: Bool)
    @objc func socialButton(button: UIButton)
    @objc func socialRefresh()
}

extension Sociable {
    func loginFlow(token token: String, with loginType: SocialLogin, hide hideButton: Bool, from: UIViewController) {
        guard Reachability.isConnectedToNetwork() else {
            return TAOverlay.showOverlayWithLabel(OverlayInfo.NetworkError.message(), image: OverlayInfo.NetworkError.logo(), options: OverlayInfo.getOptions())
        }
        
        self.showHUD()
        UserViewModel().loginSignal(token: token, with: loginType)
            .retry(Constants.kNetworkRetry)
            .observeOn(UIScheduler())
            .on(next: { _ in
                self.dismissHUD()
                self.handleMenu(false)
                TAOverlay.showOverlayWithLabel(OverlayInfo.LoginSuccess.message(), image: OverlayInfo.LoginSuccess.logo(), options: OverlayInfo.getOptions())
            })
            .on(failed: { _ in self.dismissHUD() })
            .observeOn(UIScheduler())
            .timeoutWithError(NetworkError.TimedOut as NSError, afterInterval: Constants.kTimeout, onScheduler: QueueScheduler.mainQueueScheduler)
            .flatMapError { error in
                if error.domain == "CelebrityScore.NetworkError" && error.code == NetworkError.TimedOut.hashValue { self.sendNetworkAlert(from) }
                return SignalProducer.empty }
            .flatMap(.Latest) { (value:AnyObject) -> SignalProducer<AnyObject, NSError> in
                return UserViewModel().getUserInfoFromSignal(loginType: loginType == .Facebook ? .Facebook : .Twitter) }
            .flatMap(.Latest) { (value:AnyObject) -> SignalProducer<AnyObject, NSError> in
                return UserViewModel().updateCognitoSignal(object: value, dataSetType: loginType == .Facebook ? .FacebookInfo : .TwitterInfo) }
            .flatMap(.Latest) { (value:AnyObject) -> SignalProducer<SettingsModel, NSError> in
                return SettingsViewModel().updateUserNameSignal(username: value.objectForKey(loginType == .Facebook ? "name" : "screen_name") as! String) }
            .flatMap(.Latest) { (value:AnyObject) -> SignalProducer<SettingsModel, NSError> in
                return SettingsViewModel().updateSettingSignal(value: loginType.rawValue, settingType: .LoginTypeIndex) }
            .flatMap(.Latest) { (_) -> SignalProducer<AnyObject, NSError> in
                return UserViewModel().getFromCognitoSignal(dataSetType: .UserRatings) }
            .flatMap(.Latest) { (_) -> SignalProducer<AnyObject, NSError> in
                return UserViewModel().getFromCognitoSignal(dataSetType: .UserSettings) }
            .map({ _ in self.socialRefresh() })
            .start()
    }
    
    func sendNetworkAlert(from: UIViewController) {
        self.dismissHUD()
        let alertVC = PMAlertController(title: "bad cloud", description: OverlayInfo.TimeoutError.message(), image: R.image.cloud_green_big()!, style: .Alert)
        alertVC.addAction(PMAlertAction(title: "Ok", style: .Cancel, action: { _ in from.dismissViewControllerAnimated(true, completion: nil) }))
        alertVC.addAction(PMAlertAction(title: "Contact Us", style: .Default, action: { _ in
            from.dismissViewControllerAnimated(true, completion: { _ in MaterialAnimation.delay(0.5) { self.sendEmail(from) }})
        }))
        alertVC.view.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.7)
        alertVC.view.opaque = false
        from.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func sendEmail(from: UIViewController) {
        guard MFMailComposeViewController.canSendMail() else {
            return TAOverlay.showOverlayWithLabel("We are unable to verify that an email has been setup on this device.", image: OverlayInfo.NetworkError.logo(), options: OverlayInfo.getOptions())
        }
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["gmensah@gmail.com"]) //TODO: change email address
        mail.setSubject("CelScore Issue Report")
        mail.setMessageBody("Please provide some information about the issue.", isHTML: false)
        MaterialAnimation.delay(0.5) { from.presentViewController(mail, animated: true, completion: nil) }
    }
    
    func socialButtonTapped(buttonTag buttonTag: Int, from: UIViewController, hideButton: Bool) {
        if buttonTag == 1 {
            let readPermissions = ["public_profile", "email", "user_location", "user_birthday"]
            FBSDKLoginManager().logInWithReadPermissions(readPermissions, fromViewController: from, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                guard error == nil else { print("Facebook Login error: \(error!.localizedDescription)"); return }
                guard result.isCancelled == false else { return }
                FBSDKAccessToken.setCurrentAccessToken(result.token)
                self.loginFlow(token: result.token.tokenString, with: .Facebook, hide: hideButton, from: from)
            })
        } else {
            Twitter.sharedInstance().logInWithCompletion { (session: TWTRSession?, error: NSError?) -> Void in
                guard error == nil else { print("Twitter login error: \(error!.localizedDescription)"); return }
                self.loginFlow(token: "", with: .Twitter, hide: hideButton, from: from)
            }
        }
    }
    
    func setUpSocialButton(menuView: MenuView, controller: UIViewController, origin: CGPoint, buttonColor: UIColor) {
        let btn1: FabButton = FabButton()
        btn1.depth = .Depth2
        btn1.pulseAnimation = .None
        btn1.backgroundColor = buttonColor
        btn1.tintColor = MaterialColor.white
        btn1.setImage(R.image.ic_add_black()!, forState: .Disabled)
        btn1.setImage(R.image.ic_add_white()!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        btn1.setImage(R.image.ic_add_white()!.imageWithRenderingMode(.AlwaysTemplate), forState: .Highlighted)
        btn1.addTarget(controller, action: #selector(self.handleMenu(_:)), forControlEvents: .TouchUpInside)
        menuView.addSubview(btn1)
        
        var image = R.image.facebooklogo()!
        let btn2: FabButton = FabButton()
        btn2.tag = 1
        btn2.clipsToBounds = true
        btn2.contentMode = .ScaleToFill
        btn2.depth = .Depth1
        btn2.pulseColor = MaterialColor.white
        btn2.backgroundColor = MaterialColor.indigo.darken1
        btn2.borderColor = MaterialColor.white
        btn2.borderWidth = 2
        btn2.setImage(image, forState: .Normal)
        btn2.setImage(image, forState: .Highlighted)
        btn2.addTarget(controller, action: #selector(self.socialButton(_:)), forControlEvents: .TouchUpInside)
        menuView.addSubview(btn2)
        
        image = R.image.twitterlogo()!
        let btn3: FabButton = FabButton()
        btn3.tag = 2
        btn3.contentMode = .ScaleToFill
        btn3.clipsToBounds = true
        btn3.depth = .Depth1
        btn3.backgroundColor = MaterialColor.lightBlue.base
        btn3.pulseColor = MaterialColor.white
        btn3.borderColor = MaterialColor.white
        btn3.borderWidth = 2
        btn3.setImage(image, forState: .Normal)
        btn3.setImage(image, forState: .Highlighted)
        btn3.addTarget(controller, action: #selector(self.socialButton(_:)), forControlEvents: .TouchUpInside)
        menuView.addSubview(btn3)
        
        menuView.menu.origin = origin
        menuView.menu.baseSize = CGSize(width: Constants.kFabDiameter, height: Constants.kFabDiameter)
        menuView.menu.direction = .Up
        menuView.menu.views = [btn1, btn2, btn3]
        menuView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func hideSocialButton(menuView: MenuView, controller: UIViewController) {
        menuView.menu.close()
        menuView.hidden = true
        let first: MaterialButton? = menuView.menu.views?.first as? MaterialButton
        first!.removeTarget(controller, action: #selector(self.handleMenu(_:)), forControlEvents: .TouchUpInside)
    }
    
    func showSocialButton(menuView: MenuView, controller: UIViewController) {
        menuView.hidden = false
        let first: MaterialButton? = menuView.menu.views?.first as? MaterialButton
        first!.addTarget(controller, action: #selector(self.handleMenu(_:)), forControlEvents: .TouchUpInside)
    }
}
