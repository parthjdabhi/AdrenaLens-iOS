//
//  CommonUtils.swift
//  Connect App
//
//  Created by super on 27/06/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import CoreLocation

class CommonUtils: NSObject {
    static let sharedUtils = CommonUtils()
    var progressView : MBProgressHUD = MBProgressHUD.init()
    
    // show alert view
    func showAlert(controller: UIViewController, title: String, message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        controller.presentViewController(ac, animated: true){}
    }
    
    // show progress view
    func showProgress(view : UIView, label : String) {
        progressView = MBProgressHUD.showHUDAddedTo(view, animated: true)
        progressView.labelText = label
    }
    
    // hide progress view
    func hideProgress(){
        progressView.removeFromSuperview()
        progressView.hide(true)
    }
    
    func decodeImage(base64String : String) -> UIImage {
        let decodedData = NSData(base64EncodedString: base64String, options:  NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let image = UIImage(data: decodedData!)
        return image!
    }
}


extension CLPlacemark {
    func LocationString() -> String? {
        
        // Address dictionary
        print(self.addressDictionary)
        
        // Location name
        let locationName = self.addressDictionary?["Name"] as! String!
        print(locationName)
        
        // Street address
        let street = self.addressDictionary?["Thoroughfare"] as! String!
        
        // City
        let city = self.addressDictionary?["City"] as! String!
        
        // Zip code
        let zip = self.addressDictionary?["ZIP"] as! String!
        
        // Country
        let country = self.addressDictionary?["Country"] as! String!
        print(country)
        
        return "\(street), \(city) \(zip)"
    }
    
}


@IBDesignable
class MyCustomButton: UIButton {
    
    @IBInspectable var Padding: CGFloat {
        get {
            return layer.cornerRadius
        }
        set
        {
            let imageSize = self.imageView!.frame.size
            let titleSize = self.titleLabel!.frame.size
            let totalHeight = imageSize.height + titleSize.height + Padding
            
            self.imageEdgeInsets = UIEdgeInsets(
                top: -(totalHeight - imageSize.height),
                left: 0,
                bottom: 0,
                right: -titleSize.width
            )
            
            self.titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -imageSize.width,
                bottom: -(totalHeight - titleSize.height),
                right: 0
            )
        }
    }
}

@IBDesignable
class MyCustomLabel: UILabel {
    
    @IBInspectable var textShadow: CGFloat {
        get {
            return layer.cornerRadius
        }
        set
        {
            self.shadowColor = UIColor.blackColor()
            self.shadowOffset = CGSizeMake(0.0, 0.0)
            self.layer.shadowRadius = 1.0
            self.layer.shadowOpacity = 0.2
            self.layer.masksToBounds = false
            self.layer.shouldRasterize = true
        }
    }
}