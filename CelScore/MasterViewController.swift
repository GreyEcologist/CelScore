//
//  MasterViewController.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 4/19/15.
//  Copyright (c) 2015 Gareth.K.Mensah. All rights reserved.
//

import AsyncDisplayKit
import FBSDKLoginKit
import ReactiveCocoa
import RealmSwift
import TwitterKit
import Material
import HMSegmentedControl
import AIRTimer
import OpinionzAlertView


final class MasterViewController: ASViewController, ASTableViewDataSource, ASTableViewDelegate, UITextFieldDelegate, UISearchBarDelegate, UIViewControllerTransitioningDelegate {
    
    //MARK: Properties
    let celebrityListVM: ListViewModel
    let celebrityTableView: ASTableView
    let segmentedControl: HMSegmentedControl
    let socialButton: MenuView
    let searchBar: UISearchBar
    
    //MARK: Initializers
    required init(coder aDecoder: NSCoder) { fatalError("storyboards are incompatible with truth and beauty") }
    
    init() {
        self.celebrityListVM = ListViewModel()
        self.celebrityTableView = ASTableView()
        self.segmentedControl = HMSegmentedControl(sectionTitles: ListInfo.getAll())
        self.socialButton = MenuView()
        self.searchBar = UISearchBar()
        super.init(node: ASDisplayNode())

        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onTokenUpdate:", name:FBSDKAccessTokenDidChangeNotification, object: nil)
    }
    
    //MARK: Methods
    override func prefersStatusBarHidden() -> Bool { return true }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    override func viewWillAppear(animated: Bool) {
        if let index = self.celebrityTableView.indexPathForSelectedRow {
            self.celebrityTableView.reloadRowsAtIndexPaths([index], withRowAnimation: .Fade)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        SettingsViewModel().isLoggedInSignal()
            .on(next: { value in
                if value == false {
                }
            })
            .start()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.celebrityTableView.asyncDataSource = self
        self.celebrityTableView.asyncDelegate = self
        self.celebrityTableView.backgroundColor = MaterialColor.clear
        
        self.searchBar.delegate = self
        self.searchBar.searchBarStyle = .Minimal
        let attr = [NSForegroundColorAttributeName: MaterialColor.white, NSFontAttributeName : UIFont.systemFontOfSize(14.0)]
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).defaultTextAttributes = attr
        
        let navigationBarView: NavigationBarView = getNavigationView()
        self.setupSegmentedControl()
        self.setUpSocialButton()
        
        self.view.backgroundColor = Constants.kDarkShade
        self.view.addSubview(navigationBarView)
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.celebrityTableView)
        self.view.addSubview(self.socialButton)
        MaterialLayout.size(self.view, child: self.socialButton, width: Constants.kFabDiameter, height: Constants.kFabDiameter)
        self.configuration()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.sideNavigationViewController!.setLeftViewWidth(Constants.kSettingsViewWidth, hidden: true, animated: false)
        self.celebrityTableView.frame = Constants.kCelebrityTableViewRect
    }
    
    func onTokenUpdate(notification: NSNotification) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            UserViewModel().updateCognitoSignal(object: nil, dataSetType: .UserRatings).start()
            //TODO: UserViewModel().refreshFacebookTokenSignal().start()
        }
    }
    
    func openSettings() {
        SettingsViewModel().isLoggedInSignal()
            .on(next: { value in
                if value == true { self.sideNavigationViewController!.openLeftView() }
                else {
                    self.sideNavigationViewController!.openLeftView()
                    self.socialButton.menu.open()
                }
            })
            .start()
    }
    
    func configuration() {
        SettingsViewModel().getSettingSignal(settingType: .DefaultListIndex)
            .observeOn(QueueScheduler.mainQueueScheduler)
            .flatMap(.Latest) { (value:AnyObject!) -> SignalProducer<AnyObject, NSError> in
                self.segmentedControl.setSelectedSegmentIndex(value as! UInt, animated: true)
                return self.celebrityListVM.getListSignal(listId: ListInfo(rawValue: (value as! Int))!.getId())
            }
            .on(next: { value in
                self.celebrityTableView.beginUpdates()
                self.celebrityTableView.reloadData()
                self.celebrityTableView.endUpdates()
            })
            .start()
        CelScoreViewModel().checkNetworkStatusSignal().start() //TODO
    }
    
    func changeList() {
        let list: ListInfo = ListInfo(rawValue: self.segmentedControl.selectedSegmentIndex)!
        self.celebrityListVM.getListSignal(listId: list.getId())
            .on(next: { _ in
                self.celebrityTableView.beginUpdates()
                self.celebrityTableView.reloadData()
                self.celebrityTableView.endUpdates()
            })
            .start()
        //ListViewModel().updateListSignal(listId: "0001").start() //TODO: save list in Realm
    }
    
    func handleMenu() {
        let image: UIImage?
        if self.socialButton.menu.opened {
            self.socialButton.menu.close()
            image = UIImage(named: "ic_add_white")?.imageWithRenderingMode(.AlwaysTemplate)
        } else {
            self.socialButton.menu.open() { (v: UIView) in
                (v as? MaterialButton)?.pulse()
            }
            image = UIImage(named: "ic_close_white")?.imageWithRenderingMode(.AlwaysTemplate)
        }
        
        let first: MaterialButton? = self.socialButton.menu.views?.first as? MaterialButton
        first?.animate(MaterialAnimation.rotate(1))
        first?.setImage(image, forState: .Normal)
        first?.setImage(image, forState: .Highlighted)
    }
    
    func handleButton(button: UIButton) {
       //TODO: LOGINS
    }
    
    //MARK: ASTableView methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.celebrityListVM.getCount() }
    
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        var node = ASCellNode()
        self.celebrityListVM.getCelebrityStructSignal(index: indexPath.row)
            .on(next: { value in node = CelebrityTableViewCell(celebrityStruct: value) })
            .start()
        return node
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let node: CelebrityTableViewCell = self.celebrityTableView.nodeForRowAtIndexPath(indexPath) as! CelebrityTableViewCell
        let detailVC = DetailViewController(celebrityST: node.celebST)
        detailVC.modalTransitionStyle = .CrossDissolve
        self.presentViewController(detailVC, animated: true, completion: nil)
    }
    
    //MARK: UITextFieldDelegate methods
    func textFieldShouldEndEditing(textField: UITextField) -> Bool { return false }
    func textFieldDidBeginEditing(textField: UITextField) {}
    func textFieldShouldReturn(textField: UITextField) -> Bool { textField.resignFirstResponder(); return true }
    
    func showSearchBar() {
        if self.view.subviews.contains(self.searchBar) { hideSearchBar() }
        else {
            self.searchBar.alpha = 0
            self.view.addSubview(self.searchBar)
            UIView.animateWithDuration(0.5, animations: {
                self.searchBar.alpha = 1
                self.searchBar.showsCancelButton = true
                self.searchBar.tintColor = Constants.kBrightShade
                self.searchBar.backgroundColor = Constants.kDarkShade
                self.searchBar.barTintColor = MaterialColor.white
                self.searchBar.frame = Constants.kSegmentedControlRect
                }, completion: { finished in self.searchBar.becomeFirstResponder() })
        }
    }
    
    func hideSearchBar() {
        UIView.animateWithDuration(0.3, animations: {
            self.searchBar.alpha = 0 },
            completion: { _ in
                self.searchBar.removeFromSuperview()
                self.changeList()
        })
    }
    
    //MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) { hideSearchBar() }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 2 {
            self.celebrityListVM.searchSignal(searchToken: searchText)
                .on(next: { _ in
                    self.celebrityTableView.beginUpdates()
                    self.celebrityTableView.reloadData()
                    self.celebrityTableView.endUpdates()
                })
                .start()
        }
    }
    
    //MARK: ViewDidLoad Helpers
    func getNavigationView() -> NavigationBarView {
        let menuButton: FlatButton = FlatButton()
        menuButton.pulseColor = MaterialColor.white
        menuButton.pulseScale = false
        menuButton.addTarget(self, action: Selector("openSettings"), forControlEvents: .TouchUpInside)
        menuButton.setImage(UIImage(named: "ic_menu_white"), forState: .Normal)
        menuButton.setImage(UIImage(named: "ic_menu_white"), forState: .Highlighted)
        
        let searchButton: FlatButton = FlatButton()
        searchButton.pulseColor = MaterialColor.white
        searchButton.pulseScale = false
        searchButton.setImage(UIImage(named: "ic_search_white"), forState: .Normal)
        searchButton.setImage(UIImage(named: "ic_search_white"), forState: .Highlighted)
        searchButton.addTarget(self, action: "showSearchBar", forControlEvents: .TouchUpInside)
        
        let navigationBarView: NavigationBarView = NavigationBarView(titleLabel: nil, detailLabel: nil, leftControls: [menuButton], rightControls: [searchButton])!
        navigationBarView.backgroundColor = Constants.kMainShade
        let celscoreImageView = UIImageView(image: UIImage(named: "celscore_white"))
        celscoreImageView.frame = CGRect(x: navigationBarView.width/2, y: navigationBarView.centerY - 5, width: 25, height: 25)
        navigationBarView.addSubview(celscoreImageView)
        return navigationBarView
    }
    
    func setupSegmentedControl() {
        self.segmentedControl.frame = Constants.kSegmentedControlRect
        self.segmentedControl.backgroundColor = Constants.kDarkShade
        self.segmentedControl.selectionIndicatorColor = Constants.kWineShade
        self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        self.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : MaterialColor.white,
            NSFontAttributeName: UIFont.systemFontOfSize(18)]
        self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.clipsToBounds = false
        self.segmentedControl.layer.shadowColor = MaterialColor.black.CGColor
        self.segmentedControl.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.segmentedControl.layer.shadowOpacity = 0.3
        self.segmentedControl.addTarget(self, action: "changeList", forControlEvents: .ValueChanged)
    }
    
    func setUpSocialButton() {
        var image: UIImage? = UIImage(named: "ic_add_white")?.imageWithRenderingMode(.AlwaysTemplate)
        let btn1: FabButton = FabButton()
        btn1.depth = .Depth2
        btn1.pulseScale = false
        btn1.backgroundColor = Constants.kDarkGreenShade
        btn1.tintColor = MaterialColor.white
        btn1.setImage(image, forState: .Normal)
        btn1.setImage(image, forState: .Highlighted)
        btn1.addTarget(self, action: "handleMenu", forControlEvents: .TouchUpInside)
        self.socialButton.addSubview(btn1)
        
        image = UIImage(named: "facebooklogo")
        let btn2: FabButton = FabButton()
        btn2.tag = 1
        btn2.clipsToBounds = true
        btn2.contentMode = .ScaleToFill
        btn2.depth = .Depth1
        btn2.pulseColor = MaterialColor.white
        btn2.backgroundColor = MaterialColor.indigo.darken1
        btn2.borderColor = MaterialColor.white
        btn2.borderWidth = 2
        btn2.setImage(image, forState: .Normal)
        btn2.setImage(image, forState: .Highlighted)
        btn2.addTarget(self, action: "handleButton:", forControlEvents: .TouchUpInside)
        self.socialButton.addSubview(btn2)
        
        image = UIImage(named: "twitterlogo")
        let btn3: FabButton = FabButton()
        btn3.tag = 2
        btn3.contentMode = .ScaleToFill
        btn3.clipsToBounds = true
        btn3.depth = .Depth1
        btn3.backgroundColor = MaterialColor.lightBlue.base
        btn3.pulseColor = MaterialColor.white
        btn3.borderColor = MaterialColor.white
        btn3.borderWidth = 2
        btn3.setImage(image, forState: .Normal)
        btn3.setImage(image, forState: .Highlighted)
        btn3.addTarget(self, action: "handleButton:", forControlEvents: .TouchUpInside)
        self.socialButton.addSubview(btn3)
        
        self.socialButton.menu.origin = CGPoint(x: Constants.kScreenWidth - 70, y: Constants.kScreenHeight - 70)
        self.socialButton.menu.baseViewSize = CGSize(width: Constants.kFabDiameter, height: Constants.kFabDiameter)
        self.socialButton.menu.direction = .Up
        self.socialButton.menu.views = [btn1, btn2, btn3]
        self.socialButton.translatesAutoresizingMaskIntoConstraints = false
    }
}


