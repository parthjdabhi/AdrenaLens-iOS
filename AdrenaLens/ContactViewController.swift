//
//  ContactViewController.swift
//  AdrenaLens
//
//  Created by Dustin Allen on 8/3/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import UIKit

class ContactViewController: UIViewController {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var subjectField: UITextField!
    @IBOutlet var subjectBody: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paddingForFourth = UIView(frame: CGRectMake(0, 0, 10, self.subjectField.frame.size.height))
        subjectField.leftView = paddingForFourth
        subjectField.leftViewMode = UITextFieldViewMode .Always
        subjectField.font = UIFont(name: subjectField.font!.fontName, size: 20)
        let paddingForFifth = UIView(frame: CGRectMake(0, 0, 10, self.emailField.frame.size.height))
        emailField.leftView = paddingForFifth
        emailField.leftViewMode = UITextFieldViewMode .Always
        emailField.font = UIFont(name: emailField.font!.fontName, size: 20)
        let borderColor : UIColor = UIColor.blackColor()
        subjectBody.layer.borderWidth = 2
        subjectBody.layer.borderColor = borderColor.CGColor
        subjectBody.layer.cornerRadius = 5.0
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.emailField.text = ""
        self.subjectField.text = ""
    }
    
    @IBAction func emailButton(sender: AnyObject) {
        
    }
    
    @IBAction func homeButton(sender: AnyObject) {
        let mainScreenViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainScreenViewController") as! MainScreenViewController!
        self.navigationController?.pushViewController(mainScreenViewController, animated: true)

    }
    
    @IBAction func starButton(sender: AnyObject) {
        
    }
    
    @IBAction func eyeButton(sender: AnyObject) {
        
    }
    
    @IBAction func uploadButton(sender: AnyObject) {
        
    }
    
    @IBAction func personButton(sender: AnyObject) {
        
    }

}
