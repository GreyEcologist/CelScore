//
//  AppDelegate.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 4/19/15.
//  Copyright (c) 2015 Gareth.K.Mensah. All rights reserved.
//

import UIKit
import RealmSwift
import Fabric
import TwitterKit
import AWSCognito
import AWSPinpoint
import Material
import RateLimit
import Fabric
import Crashlytics
import ReactiveCocoa
import ReactiveSwift
import FBSDKCoreKit
import SafariServices
import UserNotifications


@UIApplicationMain

final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: Property
    var window: UIWindow?
    var pinpoint: AWSPinpoint?
    
    //MARK: Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         UIApplication.shared.statusBarStyle = .lightContent
       
        //Realm
        let config = Realm.Configuration(
            schemaVersion: 40,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 39 {
                    migration.enumerateObjects(ofType: CelebrityModel.className()) { oldObject, newObject in
                        newObject!["googleName"] = ""
                    }
                }
        })
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
        
        //AWS
        AWSDDLog().logLevel = .error
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: Constants.kCredentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        //pinpoint = AWSPinpoint.init(configuration:AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: launchOptions))
        //UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in }
        //UIApplication.shared.registerForRemoteNotifications()
        
        let configurationAnonymous = AWSServiceConfiguration(region: .USEast1, credentialsProvider: AWSAnonymousCredentialsProvider())
        JUCelScoreAPIClient.registerClient(withConfiguration: configurationAnonymous!, forKey: "anonymousAccess")
        
        //UI
        CelScoreViewModel().getFromAWSSignal(dataType: .list).start()
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let nav: NavigationDrawerController = NavigationDrawerController(rootViewController: MasterViewController(), leftViewController: SettingsViewController())
        nav.contentViewController.view.backgroundColor = .clear
        self.window!.rootViewController = nav
        let statusView = UIView(frame: Constants.kStatusViewRect)
        statusView.backgroundColor = Constants.kBlueShade
        window!.rootViewController!.view.addSubview(statusView)
        self.window!.backgroundColor = Constants.kBlueShade
        self.window!.makeKeyAndVisible()

        Twitter.sharedInstance().start(withConsumerKey: "EKczkoEeUbMNkBplemTY7rypt", consumerSecret: "Vldif166LG2VOdgMBmlVqsS0XaN071JqEMZTXqut7cL7pVZPFm")
        Fabric.with([Twitter.self, AWSCognito.self, Crashlytics.self])
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        pinpoint!.notificationManager.interceptDidRegisterForRemoteNotifications(withDeviceToken: deviceToken as Data)
    }
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        pinpoint!.notificationManager.interceptDidReceiveRemoteNotification(userInfo, fetchCompletionHandler: completionHandler)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        pinpoint!.notificationManager.interceptDidReceiveRemoteNotification(response.notification.request.content.userInfo) { (UIBackgroundFetchResult) in}
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.absoluteString.contains("TheScore://") {
            CelebrityViewModel().getCelebritySignal(id: url.query!)
                .flatMapError { _ in .empty }
                .startWithValues({ celeb in
                let celebST = CelebrityStruct(
                    id: celeb.id,
                    imageURL: celeb.picture3x,
                    nickname: celeb.nickName,
                    prevScore: celeb.prevScore,
                    prevWeek: celeb.prevWeek,
                    prevMonth: celeb.prevMonth,
                    sex: celeb.sex,
                    isFollowed: celeb.isFollowed,
                    isKing: celeb.isKing)
                application.keyWindow!.rootViewController!.present(DetailViewController(celebrityST: celebST), animated: false, completion: nil)
            })
        }
        else { FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) }
        return true
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//            print("Message")
//    }
//    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("Message Fetched")
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
//    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("APNs token retrieved: \(deviceToken)")
//        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
//    }
    
//    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.unknown)
//        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        print("Device Token:", deviceTokenString)
//    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        if url.absoluteString.contains("TheScore://") {
            CelebrityViewModel().getCelebritySignal(id: url.query!)
                .flatMapError { _ in .empty }
                .startWithValues({ celeb in
                let celebST = CelebrityStruct(
                    id: celeb.id,
                    imageURL: celeb.picture3x,
                    nickname: celeb.nickName,
                    prevScore: celeb.prevScore,
                    prevWeek: celeb.prevWeek,
                    prevMonth: celeb.prevMonth,
                    sex: celeb.sex,
                    isFollowed: celeb.isFollowed,
                    isKing: celeb.isKing)
                app.keyWindow!.rootViewController!.present(DetailViewController(celebrityST: celebST), animated: false, completion: nil)
            })
        }
        else if Twitter.sharedInstance().application(app, open:url, options: options) { return true }
        else if FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: nil) { return true }
        return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard userActivity.activityType == CelebrityStruct.domainIdentifier else { return true }
        guard let id = userActivity.userInfo!["id"] else { return true }
        
        let celebST = CelebrityStruct(
            id: id as! String,
            imageURL: userActivity.userInfo!["imageURL"] as! String,
            nickname: userActivity.userInfo!["nickname"] as! String,
            prevScore: userActivity.userInfo!["prevScore"] as! Double,
            prevWeek: userActivity.userInfo!["prevWeek"] as! Double,
            prevMonth: userActivity.userInfo!["prevMonth"] as! Double,
            sex: userActivity.userInfo!["sex"] as! Bool,
            isFollowed: userActivity.userInfo!["isFollowed"]as! Bool,
            isKing: userActivity.userInfo!["isKing"]as! Bool)
        
        application.keyWindow!.rootViewController!.present(DetailViewController(celebrityST: celebST), animated: false, completion: nil)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let refresh = TimedLimiter(limit: Constants.kUpdateRatings)
        _ = refresh.execute { CelScoreViewModel().getFromAWSSignal(dataType: .ratings).start() }
    }
    
    func applicationWillResignActive(_ application: UIApplication) { FBSDKAppEvents.activateApp() }
    func applicationDidEnterBackground(_ application: UIApplication) { }
    func applicationWillEnterForeground(_ application: UIApplication) { }
}
