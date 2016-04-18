//
//  TodayViewController.swift
//  CelScoreWidget
//
//  Created by Gareth.K.Mensah on 11/9/15.
//  Copyright © 2015 Gareth.K.Mensah. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift
import AIRTimer


final class TodayViewController: UITableViewController, NCWidgetProviding {
    
    //MARK: Properties
    let userDefaults: NSUserDefaults!
    let expandButton = UIButton()
    let defaultNumRows = 5
    let maxNumberOfRows = 10
    var items = [AnyObject]()
    var expanded: Bool {
        get { return userDefaults.boolForKey("expanded") }
        set (newExpanded) { self.userDefaults.setBool(newExpanded, forKey: "expanded"); self.userDefaults.synchronize() }
    }
    
    //MARK: Initializers
    required init(coder aDecoder: NSCoder) {
        self.userDefaults = NSUserDefaults(suiteName:"group.NotificationApp")!
        let rowsNumber = self.userDefaults.integerForKey("count")

        super.init(coder: aDecoder)!
        
        guard rowsNumber > 0 else { return }
        for index in 0...(rowsNumber-1) {
            let x = self.userDefaults.objectForKey(String(index))!
            self.items.append(x)
        }
    }
    
    //MARK: Methods
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    override func viewDidAppear(animated: Bool) { super.viewDidAppear(animated) }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.expandButton.addTarget(self, action: #selector(TodayViewController.toggleExpand), forControlEvents: .TouchUpInside)
        updateExpandButtonTitle()
        updatePreferredContentSize()
        AIRTimer.every(5) { timer in self.userDefaults.synchronize() } //TEST: synchronization
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) { return UIEdgeInsetsZero }
    
    func updatePreferredContentSize() {
        preferredContentSize = CGSizeMake(CGFloat(0), CGFloat(tableView(tableView, numberOfRowsInSection: 0)) * CGFloat(tableView.rowHeight) + tableView.sectionFooterHeight)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    // MARK: Table view data source
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return expandButton }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count > 0 { return min(items.count, expanded ? self.maxNumberOfRows : self.defaultNumRows) }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CelebItem", forIndexPath: indexPath) as! TodayTableViewCell
        let celebDictionary = items[indexPath.row]
        cell.nickNameLabel.text = celebDictionary["nickName"] as? String
        cell.celscoreLabel.text = String(celebDictionary["currentScore"]! as! Double)
        var percent: Double = (celebDictionary["currentScore"] as! Double)/(celebDictionary["prevScore"] as! Double)
        percent = (percent * 100) - 100
        cell.changeLabel.text = (percent < 0 ? String(percent.roundToPlaces(2)) : "+" + String(percent.roundToPlaces(2))) + "% "
        cell.changeLabel.textColor = percent < 0 ? UIColor(red: 225/255, green: 190/255, blue: 231/255, alpha: 1) : UIColor(red: 100/255, green: 255/255, blue: 218/255, alpha: 1)
        let changeBackView = UIView(frame:cell.changeLabel.frame)
        changeBackView.frame.origin.x += 7
        changeBackView.layer.cornerRadius = 4
        cell.addSubview(changeBackView)
        cell.sendSubviewToBack(changeBackView)
        cell.profileImage.image = NSURL(string: celebDictionary["image"] as! String).flatMap { NSData(contentsOfURL: $0) }.flatMap { UIImage(data: $0) }
        cell.profileImage.layer.cornerRadius = 19
        cell.profileImage.clipsToBounds = true
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.extensionContext?.openURL(NSURL(string: "CelScoreWidget://")!, completionHandler: nil)
    }
    
    // MARK: expand
    func updateExpandButtonTitle() { expandButton.setTitle(expanded ? "Show less" : "Show more", forState: .Normal) }
    func toggleExpand() { expanded = !expanded; updateExpandButtonTitle(); updatePreferredContentSize(); tableView.reloadData() }
}

extension Double {
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
