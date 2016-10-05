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
import ReactiveCocoa


final class InfoViewController: ASViewController<ASDisplayNode>, Labelable {
    
    //MARK: Properties
    fileprivate let celebST: CelebrityStruct
    fileprivate let pulseView: View
    internal var delegate: DetailSubViewable?
    
    //MARK: Initializers
    required init(coder aDecoder: NSCoder) { fatalError("storyboards are incompatible with truth and beauty") }
    
    init(celebrityST: CelebrityStruct) {
        self.celebST = celebrityST
        self.pulseView = View(frame: Constants.kBottomViewRect)
        super.init(node: ASDisplayNode())
        self.view.isHidden = true
    }
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        CelebrityViewModel().getCelebritySignal(id: self.celebST.id)
            .on(starting: { celeb in
                
                let birthdate: NSDate = celeb.birthdate.dateFromFormat("MM/dd/yyyy")!
                let age: Int = (NSDate().month < birthdate.month || (NSDate().month == birthdate.month && NSDate().day < birthdate.day)) ? (NSDate().year - (birthdate.year+1)) : (NSDate().year - birthdate.year)
                let formatter = DateFormatter()
                formatter.dateStyle = .longStyle
                
                RatingsViewModel().getCelScoreSignal(ratingsId: self.celebST.id)
                    .startWithNext({ score in
                        for (index, quality) in Info.getAll().enumerate() {
                            let barHeight = UIDevice.getPulseBarHeight()
                            let qualityView: MaterialPulseView = MaterialPulseView(frame: CGRect(x: 0, y: CGFloat(index) * (Constants.kBottomHeight / 10) + Constants.kPadding, width: Constants.kMaxWidth, height: barHeight))
                            qualityView.tag = index+1
                            let qualityLabel: UILabel = self.setupLabel(title: quality, frame: CGRect(x: Constants.kPadding, y: 3, width: 120, height: barHeight - 5))
                            
                            var infoLabelText: String = ""
                            var attributedText: NSAttributedString = NSAttributedString()
                            switch quality {
                            case Info.FirstName.name(): infoLabelText = celeb.firstName
                            case Info.MiddleName.name(): infoLabelText = celeb.middleName
                            case Info.LastName.name(): infoLabelText = celeb.lastName
                            case Info.From.name(): infoLabelText = celeb.from
                            case Info.Birthdate.name(): infoLabelText = formatter.stringFromDate(birthdate) + String(" (\(age))")
                            case Info.Height.name(): infoLabelText = celeb.height
                            case Info.Zodiac.name(): infoLabelText = (celeb.birthdate.dateFromFormat("MM/dd/yyyy")?.zodiacSign().name())!
                            case Info.Status.name(): infoLabelText = celeb.status
                            case Info.CelScore.name(): attributedText = self.createCelScoreText(score)
                            case Info.Networth.name(): infoLabelText = celeb.netWorth
                            default: infoLabelText = ""
                            }
                            
                            let infoLabel: UILabel?
                            if case Info.CelScore.name() = quality {
                                infoLabel = UILabel(frame: CGRect(x: qualityLabel.width, y: 3, width: Constants.kMaxWidth - (qualityLabel.width + Constants.kPadding), height: barHeight - 5))
                                infoLabel!.attributedText = attributedText
                                infoLabel!.backgroundColor = Constants.kGreyBackground
                            } else {
                                infoLabel = self.setupLabel(title: infoLabelText, frame: CGRect(x: qualityLabel.width, y: 3, width: Constants.kMaxWidth - (qualityLabel.width + Constants.kPadding), height: barHeight - 5))
                            }
                            infoLabel!.textAlignment = .Right
                        
                            qualityView.depth = .Depth1
                            qualityView.backgroundColor = Constants.kGreyBackground
                            qualityView.addSubview(qualityLabel)
                            qualityView.addSubview(infoLabel!)
                            SettingsViewModel().getSettingSignal(settingType: .PublicService)
                                .observeOn(UIScheduler())
                                .startWithNext({ status in
                                if (status as! Bool) == true {
                                    qualityView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(InfoViewController.longPress(_:)))) }
                            })
                            self.pulseView.addSubview(qualityView)
                        }
                    })
            })
            .start()
        self.pulseView.backgroundColor = Color.clear
        self.view = self.pulseView
    }
    
    func createCelScoreText(_ score: Double) -> NSAttributedString {
        var attributedText = NSMutableAttributedString()
        let percent: Double = (score/self.celebST.prevScore) * 100 - 100
        let percentage: String = "(" + (percent < 0 ? String(percent.roundToPlaces(2)) : "+" + String(percent.roundToPlaces(2))) + "%)"
        let attr1 = [NSFontAttributeName: UIFont.systemFont(ofSize: 13.0), NSForegroundColorAttributeName : percent >= 0 ? Constants.kBlueText : Constants.kRedText]
        attributedText = NSMutableAttributedString(string: percentage, attributes: attr1)
        let attr2 = [NSFontAttributeName: UIFont.systemFont(ofSize: Constants.kFontSize), NSForegroundColorAttributeName : Color.black]
        let attrString = NSAttributedString(string: String(format: " %.2f", score), attributes: attr2)
        attributedText.append(attrString)
        return attributedText
    }
    
    func longPress(_ gesture: UIGestureRecognizer) {
        let celebIndex = gesture.view!.tag - 1
        let quality = Info(rawValue: celebIndex)!.text()
        
        CelebrityViewModel().getCelebritySignal(id: self.celebST.id)
            .startWithNext({ celeb in
                let birthdate: NSDate = celeb.birthdate.dateFromFormat("MM/dd/yyyy")! as NSDate
                let age: Int = (NSDate().month < birthdate.month || (NSDate().month == birthdate.month && NSDate().day < birthdate.day)) ? (NSDate().year - (birthdate.year+1)) : (NSDate().year - birthdate.year)
                let formatter = DateFormatter()
                formatter.dateStyle = DateFormatter.Style.LongStyle
                
                let infoText: String
                switch quality {
                case Info.firstName.text(): infoText = celeb.firstName
                case Info.middleName.text(): infoText = celeb.middleName
                case Info.lastName.text(): infoText = celeb.lastName
                case Info.from.text(): infoText = celeb.from
                case Info.birthdate.text(): infoText = formatter.string(from: birthdate as Date) + String(" (\(age))")
                case Info.height.text(): infoText = celeb.height
                case Info.zodiac.text(): infoText = (celeb.birthdate.dateFromFormat("MM/dd/yyyy")?.zodiacSign().name())!
                case Info.status.text(): infoText = celeb.status
                case Info.celScore.text(): infoText = String(format: "%.2f", celeb.prevScore)
                case Info.networth.text(): infoText = celeb.netWorth
                default: infoText = "n/a"
                }
                let who = self.celebST.nickname.characters.last == "s" ? "\(self.celebST.nickname)'" : "\(self.celebST.nickname)'s"
                self.delegate!.socialSharing(message: "\(who) \(quality) \(infoText)")
            })
    }
}
