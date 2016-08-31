//
//  ViewPhotoVC.swift
//  AdrenaLens
//
//  Created by iParth on 8/31/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

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
        let imageView = UIImageView()
        imageView.sd_setImageWithURL(NSURL(string: selectedPhoto["photo"].string ?? ""))
        SDWebImageManager.sharedManager().downloadImageWithURL(NSURL(string: selectedPhoto["photo"].string ?? ""),
                                                               options: SDWebImageOptions.AllowInvalidSSLCertificates,
                                                               progress: nil)
        { (image, error, cacheType, bool, url) in
            self.imageSV.displayImage(image)
        }
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
    }
}
