//
//  DetailViewController.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 11/2/15.
//  Copyright © 2015 Gareth.K.Mensah. All rights reserved.
//

import UIKit
import AsyncDisplayKit

final class DetailViewController: UIViewController {
    
    //MARK: Properties
    let nickNameNode: ASTextNode
    let celscoreNode: ASTextNode
    let marginErrorNode: ASTextNode
    let celebPicNode: ASImageNode //TODO: ASMultiplexImageNode/ASNetworkImageNode
    let celebrityProfile: CelebrityProfile
    let celebrityVM: CelebrityViewModel
    let ratingsVM: RatingsViewModel
    enum PageType: Int { case CelScore = 0, Info, Ratings }
    
    
    //MARK: Initializers
    required init(coder aDecoder: NSCoder) { fatalError("storyboards are incompatible with truth and beauty") }
    
    init(profile: CelebrityProfile) {
        self.celebrityProfile = profile
        self.celebrityVM = CelebrityViewModel(celebrityId: profile.id)
        self.ratingsVM = RatingsViewModel(celebrityId: profile.id)
        self.nickNameNode = ASTextNode()
        self.celscoreNode = ASTextNode()
        self.marginErrorNode = ASTextNode()
        self.celebPicNode = ASImageNode()
        
        super.init(nibName: nil, bundle: nil)
        self.nickNameNode.attributedString = NSMutableAttributedString(string:"\(profile.nickname)")
    }
    
    
    //MARK: Methods
    override func viewWillLayoutSubviews() {}
    override func prefersStatusBarHidden() -> Bool { return true }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*CelScoreViewModel().shareVoteOnSignal(socialNetwork: .Facebook)
            .on(next: { socialVC in
                UIApplication.sharedApplication().keyWindow!.rootViewController!.presentViewController(socialVC, animated: true, completion: nil)
            })
            .start()*/
        
        //self.celebrityVM.getFromLocalStoreSignal(id: self.celebrityProfile.id).start()
        //self.ratingsVM.retrieveFromLocalStoreSignal(ratingType: .Ratings).start()
        //self.ratingsVM.retrieveFromLocalStoreSignal(ratingType: .UserRatings).start()
        //self.ratingsVM.updateUserRatingsSignal(ratingIndex: 6, newRating: 2).start()
        //self.ratingsVM.saveUserRatingsSignal().start()
    }
    
    func screenShotMethod() {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}