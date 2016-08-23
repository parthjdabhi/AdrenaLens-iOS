//
//  IntroViewController.swift
//  AdrenaLens
//
//  Created by Dustin Allen on 8/3/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import UIKit

class IntroViewController: UIViewController {
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


    @IBAction func loginButton(sender: AnyObject) {
        let signInViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignInViewController") as! FirebaseSignInViewController!
        self.navigationController?.pushViewController(signInViewController, animated: true)
    }

    @IBAction func registerButton(sender: AnyObject) {
        let signUpViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController!
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }


    @IBAction func contactButton(sender: AnyObject) {
        let contactViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Contact2ViewController") as! Contact2ViewController!
        self.navigationController?.pushViewController(contactViewController, animated: true)
    }


}
