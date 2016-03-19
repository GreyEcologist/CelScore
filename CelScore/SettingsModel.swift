//
//  SettingsModel.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 11/7/15.
//  Copyright © 2015 Gareth.K.Mensah. All rights reserved.
//

import Foundation
import RealmSwift


public class SettingsModel: Object, NSCopying {
    
    //MARK: Properties
    dynamic var id: String = "1"
    dynamic var userName: String = ""
    dynamic var defaultListIndex: Int = 0
    dynamic var loginTypeIndex: Int = 1
    dynamic var publicService: Bool = false
    dynamic var consensusBuilding: Bool = false
    dynamic var isFirstLaunch: Bool = true
    dynamic var isFirstRoad: Bool = true
    dynamic var isFirstPublic: Bool = true
    dynamic var isFirstFollow: Bool = true
    dynamic var isSynced: Bool = true
    
    //MARK: Initializer
    public convenience init(dictionary: Dictionary<String, AnyObject>) {
        self.init()
        self.userName = dictionary["userName"] as! String
        self.defaultListIndex = dictionary["defaultListIndex"] as! Int
        self.loginTypeIndex = dictionary["loginTypeIndex"] as! Int
        self.publicService = dictionary["publicService"] as! Bool
        self.consensusBuilding = dictionary["consensusBuilding"] as! Bool
        self.isFirstLaunch = dictionary["isFirstLaunch"] as! Bool
        self.isFirstRoad = dictionary["isFirstRoad"] as! Bool
        self.isFirstPublic = dictionary["isFirstPublic"] as! Bool
        self.isFirstFollow = dictionary["isFirstFollow"] as! Bool
        self.isSynced = true
    }
    
    //MARK: Methods
    override public class func primaryKey() -> String { return "id" }
    
    public func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = SettingsModel()
        copy.id = self.id
        copy.userName = self.userName
        copy.defaultListIndex = self.defaultListIndex
        copy.loginTypeIndex = self.loginTypeIndex
        copy.publicService = self.publicService
        copy.consensusBuilding = self.consensusBuilding
        copy.isFirstLaunch = self.isFirstLaunch
        copy.isFirstRoad = self.isFirstRoad
        copy.isFirstPublic = self.isFirstPublic
        copy.isFirstFollow = self.isFirstFollow
        copy.isSynced = self.isSynced
        return copy
    }
}
