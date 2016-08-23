//
//  ViewController.swift
//  Dating App
//
//  Created by Dustin Allen on 7/10/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class MainScreenViewController: UIViewController {

    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var profileInfo: UILabel!
    var ref:FIRDatabaseReference!
    var user: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("users").child(userID!).observeEventType(.Value, withBlock: { (snapshot) in
            AppState.sharedInstance.currentUser = snapshot
            if let base64String = snapshot.value!["image"] as? String {
                // decode image
                self.profilePicture.image = CommonUtils.sharedUtils.decodeImage(base64String)
            } else {
                print("No Profile Picture")
            }
            /*
            if AppState.sharedInstance.currentUser.value?["userFirstName"] != nil && AppState.sharedInstance.currentUser.value?["userLastName"] != nil {
            let firstNameStr = AppState.sharedInstance.currentUser.value?["userFirstName"] as! String
            let lastNameStr = AppState.sharedInstance.currentUser.value?["userLastName"] as! String
            self.profileInfo.text = "\(firstNameStr) \(lastNameStr)"
            }*/
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            dismissViewControllerAnimated(true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
        let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignInViewController") as! FirebaseSignInViewController!
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    

}

