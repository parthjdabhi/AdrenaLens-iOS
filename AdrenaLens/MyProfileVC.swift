//
//  MyProfileVC.swift
//  AdrenaLens
//
//  Created by iParth on 8/23/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SDWebImage

class MyProfileVC: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var cvMyPhotos: UICollectionView!
    
    var col3ViewLayout: Col3FlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.cvMyPhotos.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        //self.cvMyPhotos.registerClass(MyPhotoCollectionViewCell.self, forCellWithReuseIdentifier: MyPhotoCollectionViewCell.identifier)
//        let nibName = UINib(nibName: MyPhotoCollectionViewCell.identifier, bundle:nil)
//        cvMyPhotos.registerNib(nibName, forCellWithReuseIdentifier: MyPhotoCollectionViewCell.identifier)
        
        self.cvMyPhotos?.registerNib(UINib(nibName: MyPhotoCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MyPhotoCollectionViewCell.identifier)
        
        
        col3ViewLayout = Col3FlowLayout()
        cvMyPhotos.collectionViewLayout = col3ViewLayout
        cvMyPhotos.backgroundColor = .whiteColor()
        
        imgProfile.layoutSubviews()
        imgProfile.setCornerRadious(imgProfile.frame.size.width/2)
        imgProfile.setBorder(0.5, color: UIColor.blackColor())
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update Detail
        imgProfile.sd_setImageWithURL(NSURL(string: userDetail["profile_photo"] as? String ?? ""))
        lblName.text = userDetail["user_name"] as? String
        
        getMyTimeline()
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

    @IBAction func actionSetting(sender: UIButton)
    {
        let actionSheetController = UIAlertController (title: "Message", message: "Are you sure want to logout?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        actionSheetController.addAction(UIAlertAction(title: "Logout", style: UIAlertActionStyle.Destructive, handler: { (actionSheetController) -> Void in
            print("handle Logout action...")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userDetail")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignInViewController") as! FirebaseSignInViewController!
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }))
        
        presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func actionEditProfile(sender: UIButton) {
        let editProfileVC = self.storyboard?.instantiateViewControllerWithIdentifier("UpdateProfileVC") as! UpdateProfileVC
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @IBAction func actionUploadProfile(sender: UIButton) {
    }
    
    //Collectionview Delegate and datasource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myTimeline.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
//        let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
//        cell.backgroundView?.backgroundColor = UIColor.redColor()
//        return cell
        let cell:MyPhotoCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(MyPhotoCollectionViewCell.identifier, forIndexPath: indexPath) as! MyPhotoCollectionViewCell
        let url = NSURL(string: myTimeline[indexPath.row]["photo"].string ?? "")
        cell.img.sd_setImageWithURL(url)
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //Selected cell item
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    func getMyTimeline()
    {
        if let user_id = userDetail["user_id"] as? Int
        {
            CommonUtils.sharedUtils.showProgress(self.view, label: "Loading..")
            
            let Parameters = ["submitted" : "1",
                              "user_id" : "\(user_id)"]
            
            Alamofire.request(.POST, url_myTimeline, parameters: Parameters)
                .validate()
                .responseJSON { response in
                    CommonUtils.sharedUtils.hideProgress()
                    switch response.result
                    {
                    case .Success(let data):
                        let json = JSON(data)
                        print(json.dictionary)
                        
                        if let status = json["status"].int,
                            result = json["result"].array where status == 1
                        {
                            print(result)
                            myTimeline = result
                            self.cvMyPhotos.reloadData()
                            
                            //NSUserDefaults.standardUserDefaults().setObject(result, forKey: "myTimeline")
                            //NSUserDefaults.standardUserDefaults().synchronize()
                            
                        } else  if let msg = json["msg"].string {
                            SVProgressHUD.showErrorWithStatus(msg)
                        } else {
                            SVProgressHUD.showErrorWithStatus("Unable to get your timeline!")
                        }
                        
                        //"status": 1, "result": , "msg": Registraion success! Please check your email for activation key.
                        
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        //CommonUtils.sharedUtils.showAlert(self, title: "Error", message: (error?.localizedDescription)!)
                    }
            }
        }
    }
}
