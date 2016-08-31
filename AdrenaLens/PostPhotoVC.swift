//
//  PostPhotoVC.swift
//  AdrenaLens
//
//  Created by iParth on 8/29/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import IQKeyboardManagerSwift
import IQDropDownTextField
import CoreLocation

class PostPhotoVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate, SelectLocationDelegate, IQDropDownTextFieldDelegate {
    
    //@IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var txtImages: UITextField!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var txtSport: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var btnSelectLocation: UIButton!
    @IBOutlet weak var txtDate: IQDropDownTextField!
    @IBOutlet weak var btnPost: UIButton!
    
    var imgTaken = false
    var imgToPost:UIImage?
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var selectedLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        txtImages.setBorder()
        txtSport.setBorder()
        txtLocation.setBorder()
        txtDate.setBorder()
        //btnPost.setBorder()
        
        txtImages.setLeftMargin(8)
        txtSport.setLeftMargin(8)
        txtLocation.setLeftMargin(8)
        txtDate.setLeftMargin(8)
        
        txtDate?.isOptionalDropDown = false
        txtDate?.dropDownMode = IQDropDownMode.DatePicker
        txtDate?.setDate(NSDate(), animated: true)
        txtDate.maximumDate = NSDate()
        
        txtLocation.text = "Select Location"
    }
    
    override func viewWillAppear(animated: Bool) {
        if selectedLocation == nil {
            self.initLocationManager()
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
    
    // MARK: - IQDropDownTextFieldDelegate Methods
    func textField(textField: IQDropDownTextField, didSelectDate date: NSDate?) {
        print(date)
    }
    
    // MARK: - Location
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        locationManager.stopUpdatingLocation()
        print("\(error)")
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if self.selectedLocation == nil
            && self.currentLocation == nil
        {
            let location = locations.last! as CLLocation
            currentLocation = location
            CLocation = location
            CLGeocoder().reverseGeocodeLocation(currentLocation!, completionHandler: {(placemarks, error)->Void in
                let pm = placemarks![0]
                self.OnSelectUserLocation(self.currentLocation, LocationDetail: pm.LocationString())
                if let place = pm.LocationString()
                {
                    CLocationPlace = place
                    self.txtLocation.text = place
                }
            })
        }
        locationManager.stopUpdatingLocation()
    }
    
    func didTapSelectLocation()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewControllerWithIdentifier("SelectLocationViewController") as! SelectLocationViewController
        secondVC.delegate = self
        secondVC.selectedLocation = (self.selectedLocation != nil) ? self.selectedLocation : currentLocation
        secondVC.locationString = self.txtLocation.text
        
        presentViewController(secondVC, animated: true, completion: nil)
    }
    
    // MARK: - Location Selction Delegate Methods
    func OnSelectUserLocation(Location: CLLocation?, LocationDetail: String?)
    {
        if (Location != nil
            && LocationDetail != "Select Location"
            && LocationDetail?.characters.count > 3)
        {
            self.selectedLocation = Location
            txtLocation.text = LocationDetail
        }
    }
    
    @IBAction func actionSelectPhoto(sender: UIButton) {
        self.selectPhoto()
    }
    
    @IBAction func actionSelectLocation(sender: UIButton) {
        didTapSelectLocation()
    }
    
    @IBAction func actionPostPhoto(sender: UIButton) {
        self.postPicture()
    }
    
    // Image Picker methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //self.imgPost.image = pickedImage
            imgToPost = pickedImage
            self.imgTaken = true
            self.txtImages.text = "Image Selected"
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Custom methods
    func selectPhoto()
    {
        // 1
        view.endEditing(true)
        
        // 2
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo",
                                                       message: nil, preferredStyle: .ActionSheet)
        // 3
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                                             style: .Default) { (alert) -> Void in
                                                let imagePicker = UIImagePickerController()
                                                imagePicker.delegate = self
                                                imagePicker.sourceType = .Camera
                                                self.presentViewController(imagePicker,
                                                                           animated: true,
                                                                           completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        // 4
        let libraryButton = UIAlertAction(title: "Choose Existing",
                                          style: .Default) { (alert) -> Void in
                                            let imagePicker = UIImagePickerController()
                                            imagePicker.delegate = self
                                            imagePicker.sourceType = .PhotoLibrary
                                            self.presentViewController(imagePicker,
                                                                       animated: true,
                                                                       completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)
        // 5
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .Cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        // 6
        presentViewController(imagePickerActionSheet, animated: true,
                              completion: nil)
    }
    
    
    func postPicture() {
        if imgToPost == nil {
            CommonUtils.sharedUtils.showAlert(self, title: "Alert!", message: "Please select the photo")
            return
        }
        else if txtLocation.text == "Select Location" || selectedLocation == nil {
            CommonUtils.sharedUtils.showAlert(self, title: "Message", message: "Please select location for game!")
            return
        }
//        else if NSDate().isLessThanDate(txtDate.date!) {
//            CommonUtils.sharedUtils.showAlert(self, title: "Message", message: "invalid date!")
//            return
//        }
        
        let Parameters = ["submitted": "1",
                          "unique_id" : userDetail["unique_id"] as? String ?? "",
                          "user_id" : userDetail["user_id"] as? String ?? "",
                          "sport" : txtSport.text ?? "",
                          "location" : txtLocation.text ?? "",
                          "lat" : "73.01231",
                          "long" : "68.32323",
                          "user_upload_time" : txtDate.date?.strDateInUTC ?? "",
                          "CreatedAt" : NSDate().strDateInUTC]
        print(Parameters)
        
        CommonUtils.sharedUtils.showProgress(self.view, label: "Publishing photo...")
        Alamofire.upload(.POST, url_postPhoto, multipartFormData: { (multipartFormData) -> Void in
            if let imageData = UIImageJPEGRepresentation(self.imgToPost!, 0.8) {
                multipartFormData.appendBodyPart(data: imageData, name: "photo", fileName: "file.png", mimeType: "image/png")
            }
            for (key, value) in Parameters {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            })
        { (encodingResult) -> Void in
            switch encodingResult {
                
            case .Success (let upload, _, _):
                upload.responseJSON { response in
                    CommonUtils.sharedUtils.hideProgress()
                    switch response.result
                    {
                    case .Success(let data):
                        
                        let json = JSON(data)
                        print(json.dictionary)
                        print(json.dictionaryObject)
                        
                        if let status = json["status"].string,
                            msg = json["msg"].string where status == "1"
                        {
                            print(msg)
                            SVProgressHUD.showSuccessWithStatus(msg)
                            self.resetValues()
                            //Go To First tab
                            self.tabBarController?.selectedIndex = 0
                            
                        } else {
                            SVProgressHUD.showErrorWithStatus("Unable to post photo!")
                            //CommonUtils.sharedUtils.showAlert(self, title: "Error", message: (error?.localizedDescription)!)
                        }
                        
                        //"status": 1, "result": , "msg": Registraion success! Please check your email for activation key.
                        
                    case .Failure(let error):
                        CommonUtils.sharedUtils.hideProgress()
                        print("Request failed with error: \(error)")
                    }
                }
            //break
            case .Failure(let errorType):
                print("\(errorType)")
                CommonUtils.sharedUtils.hideProgress()
                SVProgressHUD.showErrorWithStatus("Failed to save!")
                print("Unable to save user profile information : \(errorType)")
            }
        }
    }
    
    func resetValues()
    {
        imgTaken = false
        imgToPost = nil
        self.txtImages.text = nil
        
        txtDate?.setDate(NSDate(), animated: true)
        txtDate.maximumDate = NSDate()
        
        //currentLocation
        //selectedLocation
        //txtLocation.text = "Select Location"
    }
}
