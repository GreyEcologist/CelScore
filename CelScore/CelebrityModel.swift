//
//  CelebrityModel.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 10/10/15.
//  Copyright © 2015 Gareth.K.Mensah. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON


struct CelebrityStruct {
    let id: String
    let imageURL: String
    let nickname: String
    let height: String
    let netWorth: String
    let prevScore: Double
    let isFollowed: Bool
    
    
}

extension CelebrityStruct: Equatable {}

func == (lhs: CelebrityStruct, rhs: CelebrityStruct) -> Bool { return lhs.nickname == rhs.nickname && lhs.id == rhs.id }


final class CelebrityModel: Object, NSCopying {
    
    //MARK: Properties
    dynamic var id: String = ""
    dynamic var birthdate: String = ""
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var middleName: String = ""
    dynamic var nickName: String = ""
    dynamic var height: String = ""
    dynamic var netWorth: String = ""
    dynamic var status: String = ""
    dynamic var twitter: String = ""
    dynamic var rank: String = ""
    dynamic var picture2x: String = ""
    dynamic var picture3x: String = ""
    dynamic var from: String = ""
    dynamic var prevScore: Double = 0
    dynamic var sex: Bool = false
    dynamic var isSynced: Bool = true
    dynamic var isFollowed: Bool = false
    
    //MARK: Initializer
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["celebrityID"].string!
        self.firstName = json["firstName"].string!
        self.lastName = json["lastName"].string!
        self.middleName = json["middleName"].string!
        self.nickName = json["nickname"].string!
        self.height = json["height"].string!
        self.birthdate = json["birthdate"].string!
        self.netWorth = json["netWorth"].string!
        self.picture2x = json["picture2x"].string!
        self.picture3x = json["picture3x"].string!
        self.from = json["from"].string!
        self.rank = json["rank"].string!
        self.status = json["status"].string!
        self.twitter = json["twitter"].string!
        self.prevScore = json["prevScore"].double!
        self.sex = json["sex"].bool!
        self.isSynced = true
        
        let realm = try! Realm()
        let celebrity: CelebrityModel? = realm.objects(CelebrityModel).filter("id = %@", self.id).first!
        if let object = celebrity { self.isFollowed = object.isFollowed }
    }
    
    //MARK: Methods
    override class func primaryKey() -> String { return "id" }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = CelebrityModel()
        copy.id = self.id
        copy.birthdate = self.birthdate
        copy.firstName = self.firstName
        copy.lastName = self.lastName
        copy.middleName = self.middleName
        copy.nickName = self.nickName
        copy.height = self.height
        copy.netWorth = self.netWorth
        copy.status = self.status
        copy.twitter = self.twitter
        copy.rank = self.rank
        copy.picture2x = self.picture2x
        copy.picture3x = self.picture3x
        copy.from = self.from
        copy.prevScore = self.prevScore
        copy.sex = self.sex
        copy.isFollowed = self.isFollowed
        copy.isSynced = self.isSynced
        return copy
    }
}



