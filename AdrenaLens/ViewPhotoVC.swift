//
//  ViewPhotoVC.swift
//  AdrenaLens
//
//  Created by iParth on 8/31/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import SVProgressHUD
import SDWebImage
import WebBrowser

class ViewPhotoVC: UIViewController {

    @IBOutlet weak var imageSV: PDImageScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    var photoName: String!
    
    override func viewDidLoad() {
        //imageView.image = UIImage(named: photoName)
        
        //imageSV.displayImage(images[index])
//        let imageView = UIImageView()
//        imageView.sd_setImageWithURL(NSURL(string: selectedPhoto["photo"].string ?? ""), placeholderImage: UIImage(named: "bg_Placeholder@3x.png"))
//        SDWebImageManager.sharedManager().downloadImageWithURL(NSURL(string: selectedPhoto["photo"].string ?? ""),
//                                                               options: SDWebImageOptions.AllowInvalidSSLCertificates,
//                                                               progress: nil)
//        { (image, error, cacheType, bool, url) in
//            self.imageSV.displayImage(image)
//        }
        
        self.imageSV.displayImage(UIImage(named: "bg_Placeholder@3x.png")!)
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
    
    @IBAction func actionBack(sender: UIButton) {
        //Go To back
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func actionBuyPhoto(sender: UIButton) {
        // Redirect To web
        
        print(selectedPhoto)
        if let user_id = userDetail["user_id"] as? String
        {
            CommonUtils.sharedUtils.showProgress(self.view, label: "Loading..")
            
            let Parameters = ["submitted" : "1",
                              "user_id" : "\(user_id)",
                              "product_id" : "\(selectedPhoto["product_id"].int ?? 0)"]
            
            Alamofire.request(.POST, url_Purchase, parameters: Parameters)
                .validate()
                .responseJSON { response in
                    CommonUtils.sharedUtils.hideProgress()
                    switch response.result
                    {
                    case .Success(let data):
                        let json = JSON(data)
                        print(json.dictionary)
                        //print(json.dictionaryObject)
                        
                        if let status = json["status"].int, redirect_url = json["redirect_url"].string where status == 1 {
                            print(redirect_url)
                            //SVProgressHUD.showSuccessWithStatus(msg)
                            
                            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
                            
                            let webBrowserViewController = WebBrowserViewController()
                            //assign delegate
                            //webBrowserViewController.delegate = self
                            webBrowserViewController.language = .English
                            webBrowserViewController.tintColor = UIColor.orangeColor()
                            webBrowserViewController.barTintColor = UIColor.blackColor()
                            webBrowserViewController.toolbarHidden = false
                            webBrowserViewController.showActionBarButton = true
                            webBrowserViewController.toolbarItemSpace = 50
                            webBrowserViewController.showURLInNavigationBarWhenLoading = true
                            webBrowserViewController.showsPageTitleInNavigationBar = true
                            //webBrowserViewController.customApplicationActivities = ...
                            
                            webBrowserViewController.loadURLString(redirect_url)
                            
                            //self.navigationController?.pushViewController(webBrowserViewController, animated: true)
                            let navigationWebBrowser = WebBrowserViewController.rootNavigationWebBrowser(webBrowser: webBrowserViewController)
                            self.presentViewController(navigationWebBrowser, animated: true, completion: nil)
                        }
                        else  if let msg = json["msg"].string {
                            SVProgressHUD.showErrorWithStatus(msg)
                        } else {
                            SVProgressHUD.showErrorWithStatus("Unable to get your timeline!")
                        }
                                                
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        //CommonUtils.sharedUtils.showAlert(self, title: "Error", message: (error?.localizedDescription)!)
                    }
            }
        }
    }
}
