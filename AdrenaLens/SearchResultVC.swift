//
//  SearchResultVC.swift
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

class SearchResultVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblPhotos: UITableView!
    
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
    
    @IBAction func actionBack(sender: UIButton) {
        //Go To back
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTimeline.count
        //can show emplty lable when no post
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:PhotoTableViewCell = self.tblPhotos.dequeueReusableCellWithIdentifier(PhotoTableViewCell.identifier) as! PhotoTableViewCell!
        
        cell.lblCaption.text = searchTimeline[indexPath.row]["user_photo"].dictionaryObject?["name"] as? String ?? ""
        cell.lblDetail.text = searchTimeline[indexPath.row]["sport"].string ?? ""
        cell.lblDateTime.text = searchTimeline[indexPath.row]["user_upload_time"].string?.asDateUTC?.getElapsedInterval() ?? ""
        
        cell.imgPhoto.sd_setImageWithURL(NSURL(string: searchTimeline[indexPath.row]["photo"].string ?? ""))
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("You tapped cell at index \(indexPath.row).")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedPhoto = searchTimeline[indexPath.row]
        let viewPhotoVC = self.storyboard?.instantiateViewControllerWithIdentifier("ViewPhotoVC") as! ViewPhotoVC
        self.navigationController?.pushViewController(viewPhotoVC, animated: true)
        
    }

}
