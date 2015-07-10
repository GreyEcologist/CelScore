//
//  RatingsViewModel.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 4/20/15.
//  Copyright (c) 2015 Gareth.K.Mensah. All rights reserved.
//

import Foundation

class RatingsViewModel: NSObject {
    
    //MARK: Properties
    var ratings : RatingsModel?
    typealias allRatings = (Double, Double, Double, Double, Double, Double, Double, Double, Double, Double)
    
    //MARK: Initializers
    init(rating: PFObject) {
        
        super.init()
        
        var ratingsCollection = allRatings((rating.valueForKey("ratingOne") as? Double)!, (rating.valueForKey("ratingTwo") as? Double)!, (rating.valueForKey("ratingThree") as? Double)!, (rating.valueForKey("ratingFour") as? Double)!, (rating.valueForKey("ratingFive") as? Double)!, (rating.valueForKey("ratingSix") as? Double)!, (rating.valueForKey("ratingSeven") as? Double)!, (rating.valueForKey("ratingEight") as? Double)!, (rating.valueForKey("ratingNine") as? Double)!, (rating.valueForKey("ratingTen") as? Double)!)
        
        ratings = RatingsModel(ratings: ratingsCollection)
    }
    
    func storeUserRatingsInLocalDataStoreSignal(#ratings: PFObject) -> RACSignal {
        return RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            
            
            return nil
        })
    }

}