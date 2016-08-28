//
//  MyProfileVC.swift
//  AdrenaLens
//
//  Created by iParth on 8/23/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import Firebase

class MyProfileVC: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var cvMyPhotos: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func actionSetting(sender: UIButton) {
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
    
    @IBAction func actionEditProfile(sender: UIButton) {
    }
    @IBAction func actionUploadProfile(sender: UIButton) {
    }
    
    //Collectionview Delegate and datasource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    //    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    //        <#code#>
    //    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //Selected cell item
    }
}
