//
//  FBLoginVC.swift
//  YelpApp
//
//  Created by Rohan Tulsiani on 4/23/17.
//  Copyright © 2017 Rohan Tulsiani. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FBLoginVC: UIViewController, FBSDKLoginButtonDelegate{
    
    var loginButton : FBSDKLoginButton!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        
        if (error != nil)
        {
            errorMessageLabel.text = "\(error)"
            
        }
        else if(result.token != nil)
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            errorMessageLabel.text = "Please Input Username/Password"
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        
    }
}
