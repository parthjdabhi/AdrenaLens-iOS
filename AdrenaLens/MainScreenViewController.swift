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
        
        //profile_photo
        if let profile_photo = userDetail["profile_photo"] as? String {
            profilePicture.sd_setImageWithURL(NSURL(string: profile_photo))
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(sender: AnyObject)
    {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userDetail")
        NSUserDefaults.standardUserDefaults().synchronize()
        
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

