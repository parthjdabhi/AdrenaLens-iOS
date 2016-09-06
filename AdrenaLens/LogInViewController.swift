//
//  LogInViewController.swift
//  AdrenaLens
//
//  Created by Dustin Allen on 7/10/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import SVProgressHUD

@objc(FirebaseSignInViewController)
class FirebaseSignInViewController: UIViewController {
    
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var facebook: UIButton!
    
    override func viewDidLoad() {
        
        let paddingView = UIView(frame:CGRectMake(0, 0, 10, 10))
        emailField.leftView = paddingView;
        emailField.leftViewMode = UITextFieldViewMode.Always
        emailField.textColor = UIColor.blackColor()
        passwordField.textColor = UIColor.blackColor()
        
        let paddingForFirst = UIView(frame: CGRectMake(0, 0, 10, self.passwordField.frame.size.height))
        //Adding the padding to the second textField
        passwordField.leftView = paddingForFirst
        passwordField.leftViewMode = UITextFieldViewMode .Always
        passwordField.font = UIFont(name: passwordField.font!.fontName, size: 20)
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @IBAction func didTapSignIn(sender: AnyObject) {
        
        callLoginAPI()
        
        // Sign In with credentials.
//        let email = emailField.text!
//        let password = passwordField.text!
//        if email.isEmpty || password.isEmpty {
//            CommonUtils.sharedUtils.showAlert(self, title: "Error", message: "Email or password is missing.")
//        }
//        else{
//            CommonUtils.sharedUtils.showProgress(self.view, label: "Signing in...")
//            FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
//                dispatch_async(dispatch_get_main_queue(), {
//                    CommonUtils.sharedUtils.hideProgress()
//                })
//                if let error = error {
//                    CommonUtils.sharedUtils.showAlert(self, title: "Error", message: error.localizedDescription)
//                    print(error.localizedDescription)
//                }
//                else{
//                    //                    self.signedIn(user!)
//                    let mainScreenViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainScreenViewController") as! MainScreenViewController!
//                    self.navigationController?.pushViewController(mainScreenViewController, animated: true)
//                }
//            }
//        }
    }
    
    @IBAction func contactButton(sender: AnyObject) {
        let contactViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Contact2ViewController") as! Contact2ViewController!
        self.navigationController?.pushViewController(contactViewController, animated: true)
    }
    
    func callLoginAPI()
    {
        let email = self.emailField.text!
        let password = self.passwordField.text!
        // make sure the user entered both email & password
        if email != "" && password != "" {
            CommonUtils.sharedUtils.showProgress(self.view, label: "Signing in...")
            
            let Parameters = ["submitted" : "1",
                //"email" : email,
                "username" : email,
                "password" : password]
            
            Alamofire.request(.POST, url_login, parameters: Parameters)
                .validate()
                .responseJSON { response in
                    CommonUtils.sharedUtils.hideProgress()
                    switch response.result
                    {
                    case .Success(let data):
                        let json = JSON(data)
                        print(json.dictionary)
                        
                        if let status = json["status"].int, result = json["result"].dictionaryObject where status == 1 {
                            
                            userDetail = result
                            NSUserDefaults.standardUserDefaults().setObject(result, forKey: "userDetail")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            
                            
                            //Go To Main Screen
                            self.performSegueWithIdentifier("segueMainScreen", sender: nil)
                            
//                            let mainScreenViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainScreenViewController") as! MainScreenViewController!
//                            self.navigationController?.pushViewController(mainScreenViewController, animated: true)
                        } else  if let msg = json["msg"].string {
                            SVProgressHUD.showErrorWithStatus(msg)
                        } else {
                            SVProgressHUD.showErrorWithStatus("Unable to sign in!")
                        }
                        
                        //"status": 1, "result": , "msg": Registraion success! Please check your email for activation key.
                        
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        //CommonUtils.sharedUtils.showAlert(self, title: "Error", message: (error?.localizedDescription)!)
                    }
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter email & password!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
        }
    }
    
    /*
    @IBAction func didRequestPasswordReset(sender: AnyObject) {
        let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordResetWithEmail(userInput!) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        prompt.addTextFieldWithConfigurationHandler(nil)
        prompt.addAction(okAction)
        presentViewController(prompt, animated: true, completion: nil);
    }*/
    
    /*
    @IBAction func facebookLogin(sender: AnyObject) {
        
        let manager = FBSDKLoginManager()
        CommonUtils.sharedUtils.showProgress(self.view, label: "Loading...")
        manager.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self) { (result, error) in
            CommonUtils.sharedUtils.hideProgress()
            if error != nil {
                print(error.localizedDescription)
            }
            else if result.isCancelled {
                print("Facebook login cancelled")
            }
            else {
                let token = FBSDKAccessToken.currentAccessToken().tokenString
                
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(token)
                CommonUtils.sharedUtils.showProgress(self.view, label: "Uploading Information...")
                FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                        CommonUtils.sharedUtils.hideProgress()
                    }
                    else {
                        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,first_name,last_name,email,gender,friends,picture"])
                        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                            CommonUtils.sharedUtils.hideProgress()
                            if ((error) != nil) {
                                // Process error
                                print("Error: \(error)")
                            } else {
                                print("fetched user: \(result)")
                                self.ref.child("users").child(user!.uid).setValue(["facebookData": ["userFirstName": result.valueForKey("first_name") as! String!, "userLastName": result.valueForKey("last_name") as! String!, "gender": result.valueForKey("gender") as! String!, "email": result.valueForKey("email") as! String!], "userFirstName": result.valueForKey("first_name") as! String!, "userLastName": result.valueForKey("last_name") as! String!])
                                if let picture = result.objectForKey("picture") {
                                    if let pictureData = picture.objectForKey("data"){
                                        if let pictureURL = pictureData.valueForKey("url") {
                                            print(pictureURL)
                                            self.ref.child("users").child(user!.uid).child("facebookData").child("profilePhotoURL").setValue(pictureURL)
                                        }
                                    }
                                }
                                let mainScreenViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainScreenViewController") as! MainScreenViewController!
                                self.navigationController?.pushViewController(mainScreenViewController, animated: true)
                            }
                        })
                    }
                })
            }
        }
        
    }*/
    
}
