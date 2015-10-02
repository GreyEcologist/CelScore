//
//  UserViewModel.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 4/20/15.
//  Copyright (c) 2015 Gareth.K.Mensah. All rights reserved.
//

import Foundation
import AWSS3
import AWSCognito
import AWSLambda

class UserViewModel : NSObject {
    
    //MARK: Properties
    let cognitoIdentityPoolId = "us-east-1:7201b11b-c8b4-443b-9918-cf6913c05a21"
    
    enum listSetting {
        case A_List
        case B_List
        case Others
        case All
    }
    
    enum searchSetting {
        case Celebs
        case Lists
        case All
    }
    
    enum notificationSetting {
        case Daily
        case Twice_Daily
        case Never
    }
    
    enum loginSetting {
        case Guest
        case Facebook_User
        case Twitter_User
        case Google_User
    }
    
    //MARK: Initializers
    override init() {
        
        super.init()
        
        NSNotificationCenter.defaultCenter()
            .rac_addObserverForName(FBSDKProfileDidChangeNotification, object: nil)
            .flattenMap { (object: AnyObject!) -> RACStream! in
                return self.getUserInfoFromFacebookSignal().distinctUntilChanged()
            }
            .subscribeNext({ (object: AnyObject!) -> Void in
                self.updateUserInfoOnCognitoSignal(object)
                    .subscribeNext({ (object: AnyObject!) -> Void in
                        print("updateUserInfoOnCognitoSignal success.")
                        }, error: { (error: NSError!) -> Void in
                            print("updateUserInfoOnCognitoSignal failed.")
                    })
                }, error: { (error: NSError!) -> Void in
                    print("NSNotification failed.")
            })
    }
    
    //MARK: Methods
    func getCelebInfoLambdaSignal() -> RACSignal {
        return RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            
            let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.USEast1, identityPoolId: self.cognitoIdentityPoolId)
            let defaultServiceConfiguration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
            AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = defaultServiceConfiguration
            
            let transferManager: AWSS3TransferManager = AWSS3TransferManager.defaultS3TransferManager()
            let downloadRequest: AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
            downloadRequest.bucket = "celebjson"
            downloadRequest.key = "celebInfo.json"
            
            transferManager.download(downloadRequest).continueWithExecutor(AWSExecutor.defaultExecutor(), withBlock: { (task: AWSTask!) -> AnyObject! in
                
                if task.error == nil {
                    let result : AWSS3TransferManagerDownloadOutput = task.result as! AWSS3TransferManagerDownloadOutput
                     print("getCelebInfoLambdaSignal object is \(result.body) and is canceled \(task.cancelled)")
                    subscriber.sendNext(task.result)
                    subscriber.sendCompleted()
                } else {
                    print("getCelebInfoLambdaSignal error is \(task.error)")
                    subscriber.sendError(task.error)
                }
                return task
            })
            return nil
        })
    }
    
    func getCelebRatingsLambdaSignal() -> RACSignal {
        return RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            
            let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.USEast1, identityPoolId: self.cognitoIdentityPoolId)
            let defaultServiceConfiguration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
            AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = defaultServiceConfiguration
            
            let lambdaInvoker: AWSLambdaInvoker = AWSLambdaInvoker.defaultLambdaInvoker()
            lambdaInvoker.invokeFunction("getCelebRatingsFunction", JSONObject: nil).continueWithBlock({ (task: AWSTask!) -> AnyObject! in
                if task.error == nil {
                    print("getCelebRatingsLambdaSignal object is \(task.result) and is canceled \(task.cancelled)")
                    subscriber.sendNext(task.result)
                    subscriber.sendCompleted()
                } else {
                    print("getCelebRatingsLambdaSignal error is \(task.error)")
                    subscriber.sendError(task.error)
                }
                return task
            })
            return nil
        })
    }
    
    
    func updateUserInfoOnCognitoSignal(object: AnyObject!) -> RACSignal
    {
        return RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            let syncClient = AWSCognito.defaultCognito()
            let dataset : AWSCognitoDataset = syncClient.openOrCreateDataset("UserInfo")
            dataset.synchronize() //dataset.conflictHandler
            
            print("HEY YA \(dataset.getAll().description) COUNT \(dataset.getAll().count)")
            if dataset.getAll().count == 0 {
                dataset.setString(object.objectForKey("name") as! String, forKey: "name")
                dataset.setString(object.objectForKey("first_name") as! String, forKey: "first_name")
                dataset.setString(object.objectForKey("last_name") as! String, forKey: "last_name")
                dataset.setString(object.objectForKey("email") as! String, forKey: "email")
                let timezone = object.objectForKey("timezone") as! NSNumber
                dataset.setString(timezone.stringValue, forKey: "timezone")
                dataset.setString(object.objectForKey("gender") as! String, forKey: "gender")
                dataset.setString(object.objectForKey("locale") as! String, forKey: "locale")
                dataset.setString(object.objectForKey("birthday") as! String, forKey: "birthday")
                dataset.setString(object.objectForKey("location")?.objectForKey("name") as! String, forKey: "location")
                dataset.synchronize()
            }
            return nil
        })
    }
    
    
    func getUserInfoFromFacebookSignal() -> RACSignal
    {
        return RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            _ = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, age_range, timezone, gender, locale, birthday, location"]).startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, object: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    print("getUserInfoFromFacebookSignal object is \(object)")
                    subscriber.sendNext(object)
                    subscriber.sendCompleted()
                } else
                {
                    print("getUserInfoFromFacebookSignal error is \(error)")
                    subscriber.sendError(error)
                }
            }
            return nil
        })
    }
    
    func loginCognitoSignal(token: String) -> RACSignal
    {
        return RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            
            AWSLogger.defaultLogger().logLevel = AWSLogLevel.Verbose
            
            let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.USEast1, identityPoolId: self.cognitoIdentityPoolId)
            let defaultServiceConfiguration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
            AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = defaultServiceConfiguration
            
            AWSCognito.registerCognitoWithConfiguration(defaultServiceConfiguration, forKey: "loginUserKey")
            
            let logins: NSDictionary = NSDictionary(dictionary: [AWSCognitoLoginProviderKey.Facebook.rawValue : token])
            credentialsProvider.logins = logins as [NSObject : AnyObject]
            credentialsProvider.refresh().continueWithBlock({ (task: AWSTask!) -> AnyObject! in
                if (task.error == nil) {
                    subscriber.sendNext(task)
                    subscriber.sendCompleted()
                } else
                {
                    subscriber.sendError(task.error)
                    print("credentialsProvider.refresh() error \(task.error)")
                }
                return task
            })
            return nil
        })
    }

    func updateUserRatingsOnCognitoSignal() -> RACSignal {
        //_ : RLMNotificationToken?
        return RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            
            let predicate = NSPredicate(format: "isSynced = false")
            let userRatingsArray = RatingsModel.objectsWithPredicate(predicate)
            //println("COUNT IS \(userRatingsArray.count)")
            
            let syncClient = AWSCognito.defaultCognito()
            let dataset : AWSCognitoDataset = syncClient.openOrCreateDataset("UserVotes")
            dataset.synchronize()
            
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            
            for var index: UInt = 0; index < userRatingsArray.count; index++
            {
                let ratings: RatingsModel = userRatingsArray.objectAtIndex(index) as! RatingsModel
                let ratingsString = "\(ratings.rating1)/\(ratings.rating2)/\(ratings.rating3)/\(ratings.rating4)/\(ratings.rating5)/\(ratings.rating6)/\(ratings.rating7)/\(ratings.rating8)/\(ratings.rating9)/\(ratings.rating10)"
                dataset.setString(ratingsString, forKey: ratings.id)
                
                ratings.isSynced = true
                realm.addOrUpdateObject(ratings)
            }
            //realm.commitWriteTransaction()
            dataset.synchronize()
 
            return nil
        })
    }
    
    func recurringUpdateUserRatingsOnCognitoSignal(frequency frequency: NSTimeInterval) -> RACSignal {
        let scheduler : RACScheduler =  RACScheduler(priority: RACSchedulerPriorityDefault)
        let recurringSignal = RACSignal.interval(frequency, onScheduler: scheduler).startWith(NSDate())
        
        return recurringSignal.flattenMap({ (text: AnyObject!) -> RACStream! in
            return self.updateUserRatingsOnCognitoSignal()
        })
    }
    
    func getUserRatingsFromCognitoSignal() -> RACSignal {
        return RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            
            let syncClient = AWSCognito.defaultCognito()
            let dataset : AWSCognitoDataset = syncClient.openOrCreateDataset("UserVotes")
            dataset.synchronize()
            print("Dataset is \(dataset.description) AND COUNT is \(dataset.numRecords)")
            
            return nil
        })
    }
}