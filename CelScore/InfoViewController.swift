//
//  InfoViewController.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 2/1/16.
//  Copyright © 2016 Gareth.K.Mensah. All rights reserved.
//

import AsyncDisplayKit
import UIKit
import Material

public protocol DetailSubViewDelegate {
    func enableVoteButton(positive: Bool)
    func sendFortuneCookie()
    func socialSharing(message: String)
}


final class InfoViewController: ASViewController {
    
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
        CelebrityViewModel().getCelebritySignal(id: self.celebST.id)
            .on(next: { celeb in
                
                let birthdate = celeb.birthdate.dateFromFormat("MM/dd/yyyy")
                var age = 0
                if NSDate().month < birthdate!.month || (NSDate().month == birthdate!.month && NSDate().day < birthdate!.day )
                { age = NSDate().year - (birthdate!.year+1) } else { age = NSDate().year - birthdate!.year }
                let formatter = NSDateFormatter()
                formatter.dateStyle = NSDateFormatterStyle.LongStyle
                
                RatingsViewModel().getCelScoreSignal(ratingsId: self.celebST.id)
                    .on(next: { score in
                        for (index, quality) in Info.getAll().enumerate() {
                            let qualityView = MaterialPulseView(frame: CGRect(x: 0, y: CGFloat(index) * (Constants.kBottomHeight / 10) + Constants.kPadding, width: Constants.kDetailWidth, height: 30))
                            qualityView.tag = index+1
                            let qualityLabel = Constants.setupLabel(title: quality, frame: CGRect(x: Constants.kPadding, y: 3, width: 120, height: 25))
                            
                            let infoLabel = UILabel()
                            switch quality {
                            case Info.FirstName.name(): infoLabel.text = celeb.firstName
                            case Info.MiddleName.name(): infoLabel.text = celeb.middleName
                            case Info.LastName.name(): infoLabel.text = celeb.lastName
                            case Info.From.name(): infoLabel.text = celeb.from
                            case Info.Birthdate.name(): infoLabel.text = formatter.stringFromDate(birthdate!) + String(" (\(age))")
                            case Info.Height.name(): infoLabel.text = celeb.height
                            case Info.Zodiac.name(): infoLabel.text = (celeb.birthdate.dateFromFormat("MM/dd/yyyy")?.zodiacSign().name())!
                            case Info.Status.name(): infoLabel.text = celeb.status
                            case Info.CelScore.name(): infoLabel.text = String(format: "%.2f", score)
                            case Info.Networth.name(): infoLabel.text = celeb.netWorth
                            default: infoLabel.text = "n/a"
                            }
                            
                            infoLabel.frame = CGRect(x: qualityLabel.width, y: 3, width: Constants.kDetailWidth - (qualityLabel.width + Constants.kPadding), height: 25)
                            infoLabel.textColor = MaterialColor.white
                            infoLabel.textAlignment = .Right
                            qualityView.depth = .Depth1
                            qualityView.backgroundColor = Constants.kMainShade
                            qualityView.addSubview(qualityLabel)
                            qualityView.addSubview(infoLabel)
                            qualityView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPress:"))
                            self.pulseView.addSubview(qualityView)
                        }
                    })
                    .start()
            })
            .start()
        
        self.pulseView.backgroundColor = MaterialColor.clear
        self.view = self.pulseView
    }
    
    func longPress(gesture: UIGestureRecognizer) {
        let celebIndex = gesture.view!.tag - 1
        let quality = Info(rawValue: celebIndex)!.text()
        
        CelebrityViewModel().getCelebritySignal(id: self.celebST.id)
            .on(next: { celeb in
                let birthdate = celeb.birthdate.dateFromFormat("MM/dd/yyyy")
                var age = 0
                if NSDate().month < birthdate!.month || (NSDate().month == birthdate!.month && NSDate().day < birthdate!.day )
                { age = NSDate().year - (birthdate!.year+1) } else { age = NSDate().year - birthdate!.year }
                let formatter = NSDateFormatter()
                formatter.dateStyle = NSDateFormatterStyle.LongStyle
                
                let infoText: String
                switch quality {
                case Info.FirstName.text(): infoText = celeb.firstName
                case Info.MiddleName.text(): infoText = celeb.middleName
                case Info.LastName.text(): infoText = celeb.lastName
                case Info.From.text(): infoText = celeb.from
                case Info.Birthdate.text(): infoText = formatter.stringFromDate(birthdate!) + String(" (\(age))")
                case Info.Height.text(): infoText = celeb.height
                case Info.Zodiac.text(): infoText = (celeb.birthdate.dateFromFormat("MM/dd/yyyy")?.zodiacSign().name())!
                case Info.Status.text(): infoText = celeb.status
                case Info.CelScore.text(): infoText = String(format: "%.2f", celeb.prevScore)
                case Info.Networth.text(): infoText = celeb.netWorth
                default: infoText = "n/a"
                }
                self.delegate!.socialSharing("\(self.celebST.nickname)'s \(quality) \(infoText)")
            })
            .start()
    }
}
