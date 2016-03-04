//
//  RatingsViewController.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 2/1/16.
//  Copyright © 2016 Gareth.K.Mensah. All rights reserved.
//

import AsyncDisplayKit
import Material
import AIRTimer
import OpinionzAlertView

final class RatingsViewController: ASViewController {
    
    //MARK: Properties
    let celebST: CelebrityStruct
    let pulseView: MaterialView
    var delegate: DetailSubViewDelegate?
    
    //MARK: Initializers
    required init(coder aDecoder: NSCoder) { fatalError("storyboards are incompatible with truth and beauty") }
    
    init(celebrityST: CelebrityStruct) {
        self.celebST = celebrityST
        self.pulseView = MaterialView(frame: Constants.kBottomViewRect)
        super.init(node: ASDisplayNode())
        self.view.hidden = true
    }
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RatingsViewModel().getRatingsSignal(ratingsId: self.celebST.id, ratingType: .Ratings)
            .on(next: { ratings in
                for (index, quality) in Qualities.getAll().enumerate() {
                    
                    let qualityView = MaterialPulseView(frame: CGRect(x: 0, y: CGFloat(index) * (Constants.kBottomHeight / 10) + Constants.kPadding, width: Constants.kDetailWidth, height: 30))
                    qualityView.tag = index+1
                    qualityView.depth = .Depth1
                    qualityView.backgroundColor = Constants.kMainShade
                    qualityView.pulseScale = false
                    qualityView.pulseColor = MaterialColor.clear
                    qualityView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPress:"))
                    
                    let qualityLabel = UILabel()
                    qualityLabel.text = quality
                    qualityLabel.textColor = MaterialColor.white
                    qualityLabel.frame = CGRect(x: Constants.kPadding, y: 3, width: 120, height: 25)
                    
                    let cosmosView = CosmosView(frame: CGRect(x: Constants.kDetailWidth - 140, y: 3, width: 140, height: 25))
                    cosmosView.tag = index
                    switch quality {
                    case Qualities.Talent.name(): cosmosView.rating = ratings.rating1
                    case Qualities.Originality.name(): cosmosView.rating = ratings.rating2
                    case Qualities.Authenticity.name(): cosmosView.rating = ratings.rating3
                    case Qualities.Generosity.name(): cosmosView.rating = ratings.rating4
                    case Qualities.RoleModel.name(): cosmosView.rating = ratings.rating5
                    case Qualities.HardWork.name(): cosmosView.rating = ratings.rating6
                    case Qualities.Smarts.name(): cosmosView.rating = ratings.rating7
                    case Qualities.Elegance.name(): cosmosView.rating = ratings.rating8
                    case Qualities.Charisma.name(): cosmosView.rating = ratings.rating9
                    case Qualities.SexAppeal.name(): cosmosView.rating = ratings.rating10
                    default: cosmosView.rating = 3 }
                    cosmosView.settings.starSize = 22
                    cosmosView.settings.starMargin = 5
                    cosmosView.settings.updateOnTouch = false
                    cosmosView.settings.previousRating = Int(cosmosView.rating)
                    RatingsViewModel().hasUserRatingsSignal(ratingsId: self.celebST.id)
                        .on(next: { (hasRatings:Bool) in
                            cosmosView.settings.colorFilled = hasRatings ? Constants.kStarRatingShade : MaterialColor.white
                            cosmosView.settings.borderColorEmpty = hasRatings ? MaterialColor.yellow.darken3 : MaterialColor.white
                        })
                        .start()
                    cosmosView.didTouchCosmos = { rating in
                        SettingsViewModel().isLoggedInSignal()
                            .on(next: { value in if value == false {
                                    self.delegate!.socialSharing("")
                                    let alertView = OpinionzAlertView(title: "Identification Required", message: "blah blah blah blah blah blah blah blah", cancelButtonTitle: "Ok", otherButtonTitles: nil)
                                    alertView.iconType = OpinionzAlertIconInfo
                                    alertView.show()
                                } else {
                                    cosmosView.settings.updateOnTouch = true
                                    cosmosView.settings.userRatingMode = true
                                    RatingsViewModel().updateUserRatingSignal(ratingsId: self.celebST.id, ratingIndex: cosmosView.tag, newRating: Int(rating))
                                        .on(next: { ratings in
                                            let unrated = ratings.filter{ (ratings[$0] as! Int) == 0 }
                                            var celScore: Double = 0
                                            for userRating in ratings { celScore += ratings[userRating] as! Double }
                                            let isPositive = celScore < 30 ? false : true
                                            if unrated.count == 0 { self.delegate!.enableVoteButton(isPositive) }
                                        })
                                        .start()
                                }
                            })
                            .start()
                    }
                    
                    qualityView.addSubview(qualityLabel)
                    qualityView.addSubview(cosmosView)
                    self.pulseView.addSubview(qualityView)
                }
            })
            .start()
        
        self.pulseView.backgroundColor = MaterialColor.clear
        self.view = self.pulseView
    }
    
    func longPress(gesture: UIGestureRecognizer) {
        let ratingIndex = gesture.view!.tag - 1
        RatingsViewModel().getRatingsSignal(ratingsId: self.celebST.id, ratingType: .Ratings)
            .on(next: { ratings in
                let value = String(format: "%.2f", ratings[ratings[ratingIndex]] as! Float)
                self.delegate!.socialSharing("\(self.celebST.nickname)'s \(Qualities(rawValue: ratingIndex)!.text()) \(value)")
            })
            .start()
    }
    
    func animateStarsToGold(positive positive: Bool) {
        RatingsViewModel().getRatingsSignal(ratingsId: self.celebST.id, ratingType: .Ratings)
            .on(next: { ratings in
                let viewArray: [MaterialPulseView] = self.view.subviews.sort({ $0.tag < $1.tag }) as! [MaterialPulseView]
                for (index, subview) in viewArray.enumerate() {
                    subview.pulseScale = true
                    subview.pulseColor = positive == true ? Constants.kDarkGreenShade : Constants.kWineShade
                    AIRTimer.after(0.1 * Double(index)){ timer in  subview.pulse()
                        let stars = subview.subviews.filter({ $0 is CosmosView })
                        let cosmos: CosmosView = stars.first as! CosmosView
                        cosmos.settings.colorFilled = Constants.kStarRatingShade
                        cosmos.settings.borderColorEmpty = MaterialColor.yellow.darken3
                        cosmos.settings.userRatingMode = false
                        cosmos.rating = ratings[ratings[index]] as! Double
                        cosmos.update()
                    }
                }
                AIRTimer.after(3.0){ timer in self.delegate!.sendFortuneCookie() }
            })
            .start()
    }
}