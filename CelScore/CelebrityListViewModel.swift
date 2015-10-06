//
//  CelebrityListViewModel.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 4/20/15.
//  Copyright (c) 2015 Gareth.K.Mensah. All rights reserved.
//

import Foundation
import ReactiveCocoa


class CelebrityListViewModel: NSObject {
    
    //MARK: Properties
    dynamic var searchText = ""
    var executeSearch: RACCommand!
    var connectionErrors: RACSignal!
    var title : String = "Default"
    var celebrityList : [AnyObject] = []
    
    //MARK: Initializers
    init(searchToken: String) {
    
        super.init()
    }
    
    init(listName: String) {
        
        super.init()
        
        initializeListSignal(listName: listName)
            .observeOn(RACScheduler.mainThreadScheduler())
            .start { event in
                switch(event) {
                case let .Next(value):
                    print("Next: \(value)")
                case let .Error(error):
                    print("Error: \(error)")
                case .Completed:
                    print("Completed")
                case .Interrupted:
                    print("Interrupted")
                }
        }

//        if let currentList = list
//        {
//            updateListSignal(listName: listName)
//        } else
//        {
//            initializeListSignal(listName: listName)
//        }
    }
    
    //MARK: Methods
    
    func initializeListSignal(listName listName: String) -> SignalProducer<Int, NSError> {
        return SignalProducer {
            sink, _ in
//            let query = PFQuery(className: "List")
//            query.fromLocalDatastore()
//            query.whereKey("name", equalTo: listName)
            if 2 == 4
            {
//                self.celebrityList = object.objectForKey("celebrities") as! Array
//                self.celebrityList = self.celebrityList.map({ CelebrityViewModel(celebrity: $0 as! PFObject)})
                
                sendNext(sink, 2)
                sendCompleted(sink)
            } else
            {
                sendError(sink, NSError.init(domain: "com.celscore", code: 1, userInfo: nil))
            }
        }.observeOn(QueueScheduler())
    }
    
    
    func updateListSignal(listName listName: String) -> SignalProducer<Int, NSError> {
        return SignalProducer {
            sink, _ in
            
        }
    }
    
//    func searchForCelebritiesSignal(searchToken searchToken: String) -> RACSignal {
//        return RACSignal.createSignal({
//            (subscriber: RACSubscriber!) -> RACDisposable! in
//            let query = PFQuery(className: "Celebrity")
//            query.fromLocalDatastore()
//            query.whereKey("nickName", matchesRegex: searchToken, modifiers: "i")
//            query.findObjectsInBackgroundWithBlock({ ( objects: [AnyObject]?, error :NSError?) -> Void in
//                //println("CELBRITIES ARE \(objects)")
//                if let object = objects
//                {
//                    self.celebrityList = object as Array
//                    self.celebrityList = self.celebrityList.map({ CelebrityViewModel(celebrity: $0 as! PFObject)})
//                    
//                    subscriber.sendNext(object)
//                    subscriber.sendCompleted()
//                } else
//                {
//                    subscriber.sendError(NSError.init(domain: "com.celscore", code: 1, userInfo: nil))
//                }
//            })
//            return nil
//        })
//    }
    
//    func searchForListsSignal(searchToken searchToken: String) -> RACSignal {
//        return RACSignal.createSignal({
//            (subscriber: RACSubscriber!) -> RACDisposable! in
//            let query = PFQuery(className: "List")
//            query.fromLocalDatastore()
//            query.whereKey("name", matchesRegex: searchToken, modifiers: "i")
//            query.findObjectsInBackgroundWithBlock({ ( objects: [AnyObject]?, error :NSError?) -> Void in
//                //println("LISTS ARE \(objects)")
//                if let object = objects
//                {
//                    self.celebrityList = object as Array
//                    self.celebrityList = self.celebrityList.map({ CelebrityViewModel(celebrity: $0 as! PFObject)})
//                    
//                    subscriber.sendNext(object)
//                    subscriber.sendCompleted()
//                } else
//                {
//                    subscriber.sendError(NSError.init(domain: "com.celscore", code: 1, userInfo: nil))
//                }
//            })
//            return nil
//        })
//    }
}