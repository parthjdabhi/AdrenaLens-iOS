//
//  FindPhotosVC.swift
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
import IQKeyboardManagerSwift
import IQDropDownTextField

class FindPhotosVC: UIViewController, IQDropDownTextFieldDelegate {
    
    //@IBOutlet weak var txtImages: UITextField!
    @IBOutlet weak var txtSport: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtDate: IQDropDownTextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLocation.hidden = true
        txtSport.setBorder()
        txtLocation.setBorder()
        txtDate.setBorder()
        
        txtSport.setLeftMargin(8)
        txtLocation.setLeftMargin(8)
        txtDate.setLeftMargin(8)
        
        txtDate?.isOptionalDropDown = false
        txtDate?.dropDownMode = IQDropDownMode.DatePicker
        txtDate?.setDate(NSDate(), animated: true)
        txtDate.maximumDate = NSDate()
        
        //txtLocation.text = "Select Location"
        
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

    @IBAction func actionCantFindLocation(sender: UIButton) {
    }
    
    @IBAction func actionSearchPhotos(sender: UIButton) {
        
        /*
         http://adrenalensapp.com/API/search.php
         
         Parameters :
         
         submitted = 1
         sport
         location
         photo_date : same format as we pass while upload photo
         */
        
        searchPicture()
    }
    
    
    func searchPicture() {
        if txtSport.text?.characters.count == 0 {
            CommonUtils.sharedUtils.showAlert(self, title: "Message", message: "Please write something to search sport!")
            return
        }
        
        if let unique_id = userDetail["unique_id"] as? String , user_id = userDetail["user_id"] as? String
        {
            CommonUtils.sharedUtils.showProgress(self.view, label: "Searching..")
            
            let Parameters = ["submitted" : "1",
                              "unique_id" : unique_id,
                              "user_id" : user_id,
                              "sport" : txtSport.text ?? "",
                              "location" : txtLocation.text ?? "",
                              "photo_date" : txtDate.date?.strDateInUTC ?? ""]
            
            Alamofire.request(.POST, url_myTimeline, parameters: Parameters)
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
                            searchTimeline = result
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
    
    func resetValues()
    {
//        imgTaken = false
//        imgToPost = nil
//        self.txtImages.text = nil
//        
//        txtDate?.setDate(NSDate(), animated: true)
//        txtDate.maximumDate = NSDate()
        
        //currentLocation
        //selectedLocation
        //txtLocation.text = "Select Location"
    }
}
