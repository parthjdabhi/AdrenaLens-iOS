//
//  PhotoViewController.swift
//  Dating App
//
//  Created by Dustin Allen on 7/10/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Alamofire
import SwiftyJSON
import SVProgressHUD

class PhotoViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var photo: UIImageView!
    
    var ref:FIRDatabaseReference!
    var user: FIRUser!
    var imgTaken = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser
        
        
        self.photo.layer.cornerRadius = self.photo.frame.width/2
        self.photo.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.photo.layer.borderWidth = 1
        self.photo.layer.masksToBounds = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
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
    
    @IBAction func nextButton(sender: AnyObject) {
        
        if imgTaken == false {
            CommonUtils.sharedUtils.showAlert(self, title: "Alert!", message: "Please select the photo")
            return
        }
        
        let Parameters = ["submitted": "1",
                          "unique_id" : userDetail["unique_id"] as? String ?? "",
                          "user_id" : userDetail["user_id"] as? String ?? ""]
        print(Parameters)
        
        CommonUtils.sharedUtils.showProgress(self.view, label: "Uploading image...")
        Alamofire.upload(.POST, url_SetProfilePic, multipartFormData: { (multipartFormData) -> Void in
            if let imageData = UIImageJPEGRepresentation(self.photo.image!, 0.8) {
                multipartFormData.appendBodyPart(data: imageData, name: "profile_photo", fileName: "file.png", mimeType: "image/png")
            }
            for (key, value) in Parameters {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
        })
        { (encodingResult) -> Void in
            
            CommonUtils.sharedUtils.hideProgress()
            
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
                        
                        if let status = json["status"].string, msg = json["msg"].string where status == "1" {
                            print(msg)
                            SVProgressHUD.showSuccessWithStatus(msg)
                            let signInViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignInViewController") as! FirebaseSignInViewController!
                            self.navigationController?.pushViewController(signInViewController, animated: true)
                        } else {
                            SVProgressHUD.showErrorWithStatus("Unable to register!")
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
                SVProgressHUD.showErrorWithStatus("Failed to save!")
                print("Unable to save user profile information : \(errorType)")
            }
        }
    }
    
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSizeMake(maxDimension, maxDimension)
        var scaleFactor:CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    // Activity Indicator methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //photo.contentMode = .ScaleAspectFit
            photo.image = self.scaleImage(pickedImage, maxDimension: 300)
        }
        
        self.imgTaken = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imgToBase64(image: UIImage) -> String {
        let imageData:NSData = UIImagePNGRepresentation(image)!
        let base64String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        print(base64String)
        
        return base64String
    }
    
}

