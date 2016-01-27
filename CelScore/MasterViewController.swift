//
//  MasterViewController.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 4/19/15.
//  Copyright (c) 2015 Gareth.K.Mensah. All rights reserved.
//

import AsyncDisplayKit
import FBSDKLoginKit
import FBSDKCoreKit
import ReactiveCocoa
import RealmSwift
import TwitterKit
import CategorySliderView
import LLSlideMenu
import DynamicButton
import Material


final class MasterViewController: ASViewController, ASTableViewDataSource, ASTableViewDelegate, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    //MARK: Properties
    let celscoreVM: CelScoreViewModel
    let userVM: UserViewModel
    let settingsVM: SettingsViewModel
    let displayedCelebrityListVM: CelebrityListViewModel
    let searchedCelebrityListVM: SearchListViewModel
    let searchTextField: UITextField
    let celebrityTableView: ASTableView
    let loginButton: FBSDKLoginButton
    let settingsButton: DynamicButton
    let settingsMenu: LLSlideMenu
    let navigationBarView: NavigationBarView
    //let listSlider: CategorySliderView
    
    //MARK: Initializers
    required init(coder aDecoder: NSCoder) { fatalError("storyboards are incompatible with truth and beauty") }
    
    init(viewModel:CelScoreViewModel) {
        self.celscoreVM = viewModel
        self.userVM = UserViewModel()
        self.settingsVM = SettingsViewModel()
        self.displayedCelebrityListVM = CelebrityListViewModel()
        self.searchedCelebrityListVM = SearchListViewModel(searchToken: "")
        self.celebrityTableView = ASTableView()
        self.searchTextField = UITextField(frame: CGRectMake(0 , 0, 60, 0))
        self.loginButton = FBSDKLoginButton()
        self.settingsMenu = LLSlideMenu()
        self.settingsButton = DynamicButton(frame: CGRectMake(0, 0, 15.0, 15.0))
        self.navigationBarView = NavigationBarView()
        
        super.init(node: ASDisplayNode())
        
        self.searchTextField.placeholder = "look up a celebrity"
        self.searchTextField.delegate = self

        self.loginButton.readPermissions = ["public_profile", "email", "user_location", "user_birthday"]
        self.loginButton.delegate = self
        
        self.settingsMenu.ll_menuWidth = Constants.kMenuWidth
        self.settingsMenu.ll_springDamping = 20
        self.settingsMenu.ll_springVelocity = 15
        self.settingsMenu.ll_springFramesNum = 60
        self.settingsMenu.ll_menuBackgroundColor = Constants.kBackgroundColor
        self.settingsMenu.addSubview(SettingsView(frame: self.settingsMenu.frame))
        
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onTokenUpdate:", name:FBSDKAccessTokenDidChangeNotification, object: nil)
    }
    
    //MARK: Methods
    override func prefersStatusBarHidden() -> Bool { return true }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.kBackgroundColor
        
        let title = UILabel()
        title.text = "CelScore"
        title.textAlignment = .Center
        title.textColor = Constants.kBackgroundColor
        
        self.settingsButton.setStyle(.Hamburger, animated: true)
        self.settingsButton.addTarget(self, action: Selector("openSetings"), forControlEvents: .TouchUpInside)
        self.settingsButton.strokeColor = Constants.kBackgroundColor
        
        self.navigationBarView.titleLabel = title
        self.navigationBarView.leftButtons = [self.settingsButton]
        self.navigationBarView.backgroundColor = MaterialColor.green.lighten1
        
        self.view.addSubview(self.navigationBarView)
        //self.view.addSubview(self.searchTextField)
        self.view.addSubview(self.celebrityTableView)
        self.view.addSubview(self.settingsMenu)
        //self.view.addSubview(loginButton)
        self.configuration()
    }
    
    override func viewWillLayoutSubviews() {
        self.celebrityTableView.frame = CGRectMake(
            Constants.kCellPadding,
            Constants.kNavigationPadding,
            self.view.frame.width - 2 * Constants.kCellPadding,
            self.view.frame.height - 2 * Constants.kCellPadding)
    }
    
    func openSetings() {
        if self.settingsMenu.ll_isOpen { self.settingsMenu.ll_closeSlideMenu() }
        else { self.settingsMenu.ll_openSlideMenu() }
    }
    
    func configuration()
    {
        self.celebrityTableView.asyncDataSource = self
        self.celebrityTableView.asyncDelegate = self
        
        self.settingsVM.getSettingSignal(settingType: .DefaultListId)
            .observeOn(QueueScheduler.mainQueueScheduler)
            .flatMap(.Latest) { (value:AnyObject!) -> SignalProducer<AnyObject, NSError> in
                return self.displayedCelebrityListVM.getListSignal(listId: value as! String)
            }
            .on(next: { value in
                self.celebrityTableView.beginUpdates()
                self.celebrityTableView.reloadData()
                self.celebrityTableView.endUpdates()
            })
            .retry(1)
            .start()
    
        self.searchedCelebrityListVM.searchText <~ self.searchTextField.rac_textSignalProducer()
        self.celscoreVM.checkNetworkStatusSignal().start()
        self.settingsVM.updateTodayWidgetSignal().start()
    }
    
    func changeList(celebList celebList: CelebList) {
        self.displayedCelebrityListVM.getListSignal(listId: celebList.getId())
            .on(next: { value in
                self.celebrityTableView.beginUpdates()
                self.celebrityTableView.reloadData()
                self.celebrityTableView.endUpdates()
            })
            .start()
    }
    
    func onTokenUpdate(notification: NSNotification) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            self.userVM.updateCognitoSignal(object: nil, dataSetType: .UserRatings).start()
            //self.userVM.refreshFacebookTokenSignal().start()
        }
    }
    
    //MARK: ASTableView methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.displayedCelebrityListVM.count }
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        var node = ASCellNode()
        self.displayedCelebrityListVM.getCelebrityStructSignal(index: indexPath.row)
            .on(next: { value in node = CelebrityTableViewCell(celebrityStruct: value) })
            .start()
        return node
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let node: CelebrityTableViewCell = self.celebrityTableView.nodeForRowAtIndexPath(indexPath) as! CelebrityTableViewCell
        self.celebrityTableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.presentViewController(DetailViewController(celebrityId: node.getId()), animated: false, completion: nil)
    }
    
    //MARK: UITextFieldDelegate methods
    func textFieldShouldEndEditing(textField: UITextField) -> Bool { return false }
    func textFieldDidBeginEditing(textField: UITextField) {}
    func textFieldShouldReturn(textField: UITextField) -> Bool { textField.resignFirstResponder(); return true }
    
    //MARK: FBSDKLoginButtonDelegate Methods.
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        guard error == nil else { print("FBSDKLogin error: \(error)"); return }
        guard result.isCancelled == false else { return }
        FBSDKAccessToken.setCurrentAccessToken(result.token)
        
        self.userVM.loginSignal(token: result.token.tokenString, loginType: .Facebook)
            .observeOn(QueueScheduler.mainQueueScheduler)
            .flatMap(.Latest) { (_) -> SignalProducer<AnyObject, NSError> in
                return self.userVM.getUserInfoFromFacebookSignal()
            }
            .flatMap(.Latest) { (_) -> SignalProducer<AnyObject, NSError> in
                return self.celscoreVM.getFromAWSSignal(dataType: .Celebrity)
            }
            .flatMap(.Latest) { (_) -> SignalProducer<AnyObject, NSError> in
                return self.celscoreVM.getFromAWSSignal(dataType: .Ratings)
            }
            .flatMap(.Latest) { (_) -> SignalProducer<AnyObject, NSError> in
                return self.celscoreVM.getFromAWSSignal(dataType: .List)
            }
            .flatMap(.Latest) { (_) -> SignalProducer<AnyObject, NSError> in
                return self.userVM.getFromCognitoSignal(dataSetType: .UserRatings)
            }
            .flatMapError { _ in SignalProducer<AnyObject, NSError>.empty }
            .retry(2)
            .start()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) { self.userVM.logoutSignal(.Facebook).start() }
}


