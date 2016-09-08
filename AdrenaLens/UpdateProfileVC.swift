//
//  UploadPhotoVC.swift
//  AdrenaLens
//
//  Created by iParth on 8/23/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class UpdateProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var tvCaption: UITextView!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var lblSelectImage: UILabel!
    
    var imgTaken = false
    var imgToPost:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblSelectImage.setCornerRadious()
        imgPost.setCornerRadious()
        imgPost.setBorder()
        tvCaption.setBorder()
        tvCaption.setCornerRadious()
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
    
    @IBAction func actionSelectPhoto(sender: UIButton) {
        self.selectPhoto()
    }
    
    @IBAction func actionUpdateProfilePicture(sender: UIButton) {
        self.UpdateProfilePicture()
    }
    
    // Image Picker methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imgPost.image = pickedImage
            imgToPost = pickedImage
        }
        self.imgTaken = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Custom methods
    func selectPhoto() {
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
    
    
    func UpdateProfilePicture()
    {
        if imgToPost == nil {
            CommonUtils.sharedUtils.showAlert(self, title: "Alert!", message: "Please select the photo")
            return
        }
        
        let Parameters = ["submitted": "1",
                          "user_id" : "\(userDetail["user_id"] as? String ?? "0")",
                          "bio_graphy" : tvCaption.text ?? "",
                          "upload_time" : NSDate().strDateInUTC]
        
        print(Parameters)
        
        CommonUtils.sharedUtils.showProgress(self.view, label: "Updating..")
        Alamofire.upload(.POST, url_setProfilePic, multipartFormData: { (multipartFormData) -> Void in
            if let imageData = UIImageJPEGRepresentation(self.imgToPost!, 0.8) {
                multipartFormData.appendBodyPart(data: imageData, name: "profile_photo", fileName: "file.png", mimeType: "image/png")
            }
            for (key, value) in Parameters {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            })
        { (encodingResult) -> Void in
            
            //CommonUtils.sharedUtils.hideProgress()
            
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
                        
                        
                        if let Detail = json["result"].dictionaryObject {
                            userDetail = Detail
                            NSUserDefaults.standardUserDefaults().setObject(userDetail, forKey: "userDetail")
                        }
                        
                        if let status = json["status"].int, msg = json["msg"].string where status == 1 {
                            print(msg)
                            SVProgressHUD.showSuccessWithStatus(msg)
                            self.navigationController?.popViewControllerAnimated(true)
                        } else {
                            SVProgressHUD.showErrorWithStatus("Unable to update details!")
                            //CommonUtils.sharedUtils.showAlert(self, title: "Error", message: (error?.localizedDescription)!)
                        }
                        
                        //"status": 1, "result": , "msg": Registraion success! Please check your email for activation key.
                        
                    case .Failure(let error):
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
}
