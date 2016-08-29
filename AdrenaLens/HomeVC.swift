//
//  HomeVC.swift
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

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSetting: NSLayoutConstraint!
    @IBOutlet weak var tblPhotos: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getTimeline()
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
    
    func getTimeline()
    {
        if let unique_id = userDetail["unique_id"] as? String , user_id = userDetail["user_id"] as? String
        {
            CommonUtils.sharedUtils.showProgress(self.view, label: "Loading..")
            
            let Parameters = ["submitted" : "1",
                            "unique_id" : unique_id,
                            "user_id" : user_id]
            
            Alamofire.request(.POST, url_timeline, parameters: Parameters)
                .validate()
                .responseJSON { response in
                    CommonUtils.sharedUtils.hideProgress()
                    switch response.result
                    {
                    case .Success(let data):
                        let json = JSON(data)
                        print(json.dictionary)
                        
                        if let status = json["status"].string,
                            result = json["result"].array where status == "1"
                        {
                            print(result)
                            timeline = result
                            self.tblPhotos.reloadData()

                            //NSUserDefaults.standardUserDefaults().setObject(result, forKey: "timeline")
                            //NSUserDefaults.standardUserDefaults().synchronize()
                            
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
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline.count
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:PhotoTableViewCell = self.tblPhotos.dequeueReusableCellWithIdentifier(PhotoTableViewCell.identifier) as! PhotoTableViewCell!
        
        cell.lblCaption.text = timeline[indexPath.row]["user_photo"].dictionaryObject?["user_name"] as? String ?? ""
        cell.lblDetail.text = timeline[indexPath.row]["caption"].string ?? ""
        cell.lblDateTime.text = timeline[indexPath.row]["user_upload_time"].string ?? ""
        
        cell.imgPhoto.sd_setImageWithURL(NSURL(string: timeline[indexPath.row]["photo"].string ?? ""))
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You tapped cell at index \(indexPath.row).")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
