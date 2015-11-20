//
//  SettingsViewModel.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 11/7/15.
//  Copyright © 2015 Gareth.K.Mensah. All rights reserved.
//


import Foundation
import RealmSwift
import ReactiveCocoa


final class SettingsViewModel: NSObject {

    //MARK: Properties
    var defaultListId: String { get { return SettingsModel().defaultListId }}
    enum SettingsError: ErrorType { case NoCelebrityModels, NoSettingsModel, NoFollowedCelebs }
    enum SettingType: Int { case DefaultListId = 0, LoginTypeIndex }
    enum LoginType: Int { case None = 1, Facebook, Twitter }
    
    
    //MARK: Initializers
    override init() { super.init() }
    
    
    //MARK: Methods
    func getUserRatingsPercentageSignal() -> SignalProducer<Int, SettingsError> {
        return SignalProducer { sink, _ in
            
            let realm = try! Realm()
            let userRatingsCount: Int = realm.objects(UserRatingsModel).count
            let celebrityCount: Int = realm.objects(CelebrityModel).count
            guard celebrityCount > 1 else { sendError(sink, .NoCelebrityModels); return }
            
            sendNext(sink, userRatingsCount/celebrityCount)
            sendCompleted(sink)
        }
    }
    
    func getSettingsFromLocalStoreSignal() -> SignalProducer<SettingsModel, SettingsError> {
        return SignalProducer { sink, _ in
            
            let realm = try! Realm()
            let model = realm.objects(SettingsModel).first
            guard let settings = model else { sendError(sink, .NoSettingsModel); return }
            
            sendNext(sink, settings)
            sendCompleted(sink)
        }
    }
    
    func updateSettingOnLocalStoreSignal(value value: AnyObject, settingType: SettingType) -> SignalProducer<SettingsModel, NoError> {
        return SignalProducer { sink, _ in
            
            let realm = try! Realm()
            realm.beginWrite()
            
            var model = realm.objects(SettingsModel).first
            if model == nil { model = SettingsModel() }
            let settings: SettingsModel = model!
            
            switch settingType {
            case .DefaultListId: settings.defaultListId = value as! String
            case .LoginTypeIndex: settings.loginTypeIndex = value as! Int
            }
            settings.isSynced = false
            realm.add(settings, update: true)
            try! realm.commitWrite()
            
            sendNext(sink, settings)
            sendCompleted(sink)
        }
    }
    
    //TODO: call in the background every 5 min
    //TODO: check for existing celebrities in Realm before calling it
    func getFollowedCelebritiesSignal() -> SignalProducer<Results<CelebrityModel>, NoError> {
        return SignalProducer { sink, _ in
            let realm = try! Realm()
            let predicate = NSPredicate(format: "isFollowed = false") //TODO: true
            let celebList = realm.objects(CelebrityModel).filter(predicate)
            let userDefaults = NSUserDefaults(suiteName:"group.NotificationApp")
            for (index, celeb) in celebList.enumerate() {
                let idPredicate = NSPredicate(format: "id = %@", celeb.id)
                let ratings: RatingsModel = realm.objects(RatingsModel).filter(idPredicate).first!.copy() as! RatingsModel
                let totalRatings: Double = ratings.map{ratings[$0] as! Double }.reduce(0, combine: { $0 + $1 })
                let currentScore: Double = totalRatings/10
                let today = ["nickName": celeb.nickName, "image": celeb.picture2x, "prevScore": celeb.prevScore, "currentScore": currentScore]
                userDefaults!.setObject(today, forKey: String(index))
            }
            userDefaults!.setInteger(celebList.count, forKey: "count")
            sendNext(sink, celebList)
            sendCompleted(sink)
        }
    }
}

