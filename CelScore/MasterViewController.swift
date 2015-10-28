//
//  MasterViewController.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 4/19/15.
//  Copyright (c) 2015 Gareth.K.Mensah. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import FBSDKLoginKit
import FBSDKCoreKit
import ReactiveCocoa
import RealmSwift

enum MasterViewError : ErrorType {
    case FacebookError
    case ProfileError
}

final class MasterViewController: UIViewController, ASTableViewDataSource, ASTableViewDelegate, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    //MARK: Properties
    var loadingIndicator: UIActivityIndicatorView!
    var signInButton: UIButton!
    var searchTextField : UITextField!
    var celebrityTableView : ASTableView!
    var loginButton : FBSDKLoginButton!
    var celscoreVM: CelScoreViewModel!
    var userVM: UserViewModel!
    
    enum periodSetting: NSTimeInterval {
        case Every_Minute = 60.0
        case Daily = 86400.0
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    init(viewModel:CelScoreViewModel)
    {
        self.celscoreVM = viewModel
        self.celebrityTableView = ASTableView(frame: CGRectMake(0 , 60, 300, 400), style: UITableViewStyle.Plain, asyncDataFetching: true)
        self.searchTextField = UITextField(frame: CGRectMake(10 , 5, 300, 50))
        
        super.init(nibName: nil, bundle: nil)
        
        self.bindWithViewModels()
        
        self.searchTextField.delegate = self
        self.searchTextField.placeholder = "look up a celebrity or a #list"
        
        self.celebrityTableView.asyncDataSource = self
        self.celebrityTableView.asyncDelegate = self
        
        self.view.addSubview(self.searchTextField)
        self.view.addSubview(self.celebrityTableView)
    }

    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        //self.celebrityTableView.frame = self.view.bounds
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func bindWithViewModels ()
    {
        userVM = UserViewModel()
        
        //LOGIN
        loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_location", "user_birthday"]
        loginButton.delegate = self

        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        if let accessToken = FBSDKAccessToken.currentAccessToken()
        {
            print("fb token \(accessToken)")
        } else
        {
            self.view.addSubview(loginButton)
        }
        
       //SEARCH
        self.celscoreVM.searchedCelebrityListVM.searchText <~ self.searchTextField.rac_textSignalProducer()
        
        //REACHABILITY
        self.celscoreVM.checkNetworkConnectivitySignal()
            .start { event in
                switch(event) {
                case let .Next(value):
                    print("checkNetworkConnectivitySignal Value: \(value)")
                case let .Error(error):
                    print("checkNetworkConnectivitySignal Error: \(error)")
                case .Completed:
                    print("checkNetworkConnectivitySignal Completed")
                case .Interrupted:
                    print("checkNetworkConnectivitySignal Interrupted")
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: ASTableView methods.
    func tableView(tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
        let celebId = self.celscoreVM.displayedCelebrityListVM.getIdForCelebAtIndex(indexPath.row)
        let celebProfile = try! self.celscoreVM.displayedCelebrityListVM.getCelebrityProfile(celebId: celebId)
        let node = CelebrityTableViewCell(profile: celebProfile)
        return node
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.celscoreVM.displayedCelebrityListVM.getCount()
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
    }
    
    
    // MARK: UITextFieldDelegate methods
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {}
    
    
    //MARK: FBSDKLoginButtonDelegate Methods.
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        guard error == nil else {
            print(error)
            return
        }
        guard result.isCancelled == false else {
            print("canceled")
            return
        }
        
        userVM.loginCognitoSignal(result.token.tokenString)
            .start { event in
                switch(event) {
                case let .Next(value):
                    print("userVM.loginCognitoSignal Next: \(value)")
                    
                    let realm = try! Realm()
                    let userRatingsArray = realm.objects(UserRatingsModel)
                    if userRatingsArray.count > 0
                    {
                        self.userVM.updateUserRatingsOnCognitoSignal()
                            .start { event in
                                switch(event) {
                                case let .Next(value):
                                    print("userVM.loginCognitoSignal Value: \(value)")
                                case let .Error(error):
                                    print("userVM.loginCognitoSignal Error: \(error)")
                                case .Completed:
                                    print("userVM.loginCognitoSignal Completed")
                                case .Interrupted:
                                    print("userVM.loginCognitoSignal Interrupted")
                                }
                        }
                    } else
                    {

// **** DO NOT DELETE *****
                        
//                        self.celscoreVM.timeNotifier.producer
//                            .start { event in
//                                switch(event) {
//                                case let .Next(value):
//                                    print("celscoreVM.timeNotifier.producer Value: \(value)")
//                                case let .Error(error):
//                                    print("celscoreVM.timeNotifier.producer Error: \(error)")
//                                case .Completed:
//                                    print("celscoreVM.timeNotifier.producer Completed")
//                                case .Interrupted:
//                                    print("celscoreVM.timeNotifier.producer Interrupted")
//                                }
//                        }
                        
//                        self.celscoreVM.getCelebsInfoFromAWSSignal()
//                            .start { event in
//                                switch(event) {
//                                case let .Next(value):
//                                    print("getCelebRatingsFromAWSSignal Value: \(value)")
//                                case let .Error(error):
//                                    print("getCelebRatingsFromAWSSignal Error: \(error)")
//                                case .Completed:
//                                    print("getCelebRatingsFromAWSSignal Completed")
//                                case .Interrupted:
//                                    print("getCelebRatingsFromAWSSignal Interrupted")
//                                }
//                        }
                        
                        self.celscoreVM.getCelebListsFromAWSSignal()
                            .start { event in
                                switch(event) {
                                case let .Next(value):
                                    print("getCelebListsFromAWSSignal Value: \(value)")
                                case let .Error(error):
                                    print("getCelebListsFromAWSSignal Error: \(error)")
                                case .Completed:
                                    print("getCelebListsFromAWSSignal Completed")
                                case .Interrupted:
                                    print("getCelebListsFromAWSSignal Interrupted")
                                }
                        }
                        
//                        self.celscoreVM.getCelebRatingsFromAWSSignal()
//                            .start { event in
//                                switch(event) {
//                                case let .Next(value):
//                                    print("getCelebRatingsFromAWSSignal Value: \(value)")
//                                case let .Error(error):
//                                    print("getCelebRatingsFromAWSSignal Error: \(error)")
//                                case .Completed:
//                                    print("getCelebRatingsFromAWSSignal Completed")
//                                case .Interrupted:
//                                    print("getCelebRatingsFromAWSSignal Interrupted")
//                                }
//                        }
                        
//                        self.userVM.getUserRatingsFromCognitoSignal()
//                            .start { event in
//                                switch(event) {
//                                case let .Next(value):
//                                    print("userVM.loginCognitoSignal Value: \(value)")
//                                case let .Error(error):
//                                    print("userVM.loginCognitoSignal Error: \(error)")
//                                case .Completed:
//                                    print("userVM.loginCognitoSignal Completed")
//                                case .Interrupted:
//                                    print("userVM.loginCognitoSignal Interrupted")
//                                }
//                        }
                    }
                case let .Error(error):
                    print("userVM.loginCognitoSignal Error: \(error)")
                case .Completed:
                    print("userVM.loginCognitoSignal Completed")
                case .Interrupted:
                    print("userVM.loginCognitoSignal Interrupted")
                }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {}
}

//MARK: Extensions
extension UITextField {
    func rac_textSignalProducer() -> SignalProducer<String, NoError> {
        return self.rac_textSignal().toSignalProducer()
            .map { $0 as! String }
            .flatMapError { _ in SignalProducer<String, NoError>.empty }
    }
}

