//
//  SignUpViewController.swift
//  
//
//  Created by Dustin Allen on 7/10/16.
//
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit
import Firebase
import Alamofire
import SwiftyJSON
import SVProgressHUD


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var confirmPasswordField: UITextField!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    var ref:FIRDatabaseReference!
    
    override func viewDidLoad() {
        
        passwordField.textColor = UIColor.blackColor()
        let paddingForFirst = UIView(frame: CGRectMake(0, 0, 10, self.passwordField.frame.size.height))
        passwordField.leftView = paddingForFirst
        passwordField.leftViewMode = UITextFieldViewMode .Always
        passwordField.font = UIFont(name: passwordField.font!.fontName, size: 20)
        let paddingForSecond = UIView(frame: CGRectMake(0, 0, 10, self.confirmPasswordField.frame.size.height))
        confirmPasswordField.leftView = paddingForSecond
        confirmPasswordField.leftViewMode = UITextFieldViewMode .Always
        confirmPasswordField.font = UIFont(name: confirmPasswordField.font!.fontName, size: 20)
        let paddingForThird = UIView(frame: CGRectMake(0, 0, 10, self.usernameField.frame.size.height))
        usernameField.leftView = paddingForThird
        usernameField.leftViewMode = UITextFieldViewMode .Always
        usernameField.font = UIFont(name: usernameField.font!.fontName, size: 20)
        let paddingForFourth = UIView(frame: CGRectMake(0, 0, 10, self.nameField.frame.size.height))
        nameField.leftView = paddingForFourth
        nameField.leftViewMode = UITextFieldViewMode .Always
        nameField.font = UIFont(name: nameField.font!.fontName, size: 20)
        let paddingForFifth = UIView(frame: CGRectMake(0, 0, 10, self.emailField.frame.size.height))
        emailField.leftView = paddingForFifth
        emailField.leftViewMode = UITextFieldViewMode .Always
        emailField.font = UIFont(name: emailField.font!.fontName, size: 20)
    }
    
    override func viewDidAppear(animated: Bool) {
        ref = FIRDatabase.database().reference()
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.emailField.frame.origin.y = -150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.emailField.frame.origin.y = 0
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func createProfile(sender: AnyObject)
    {
        let name = self.nameField.text!
        let username = self.usernameField.text!
        let email = self.emailField.text!
        let password = self.passwordField.text!
        // make sure the user entered both email & password
        if email != "" && password != "" {
            CommonUtils.sharedUtils.showProgress(self.view, label: "Registering...")
            
            let Parameters = ["submitted": "1",
                "name" : name,
                "email" : email,
                "username" : username,
                "password" : password]
            print(Parameters)
            
            Alamofire.request(.POST, url_Register, parameters: Parameters)
                .validate()
                .responseJSON { response in
                    CommonUtils.sharedUtils.hideProgress()
                switch response.result
                {
                    case .Success(let data):
                        
                        let json = JSON(data)
                        print(json.dictionary)
                        print(json.dictionaryObject)
                        
                        if let status = json["status"].string,
                            msg = json["msg"].string,
                            result = json["result"].dictionaryObject
                            where status == "1"
                        {
                            print(msg)
                            SVProgressHUD.showSuccessWithStatus(msg)
                            userDetail = result
                            
                            //self.navigationController?.popViewControllerAnimated(true)
                            let photoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoViewController") as! PhotoViewController!
                            self.navigationController?.pushViewController(photoViewController, animated: true)
                        } else {
                            SVProgressHUD.showErrorWithStatus("Unable to register!")
                            //CommonUtils.sharedUtils.showAlert(self, title: "Error", message: (error?.localizedDescription)!)
                        }
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                }
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter email & password!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
        }
        //"status": 1, "result": , "msg": Registraion success! Please check your email for activation key.
    }
    
    /*
    @IBAction func facebookButton(sender: AnyObject) {
        
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
