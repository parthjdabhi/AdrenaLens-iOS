//
//  Extensions.swift
//  Connect App
//
//  Created by Dustin Allen on 7/10/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import UIKit


extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.sharedApplication()
        for url in urls {
            if application.canOpenURL(NSURL(string: url)!) {
                application.openURL(NSURL(string: url)!)
                return
            }
        }
    }
}

extension UIView {
    public func setBorder(width: CGFloat?, color: UIColor?)
    {
        self.layer.borderColor = color?.CGColor ?? UIColor.darkGrayColor().CGColor
        self.layer.borderWidth = width ?? 1.0
        self.layer.masksToBounds = true
    }
    public func setCornerRadious(radious: CGFloat?)
    {
        self.layer.cornerRadius = radious ?? 4
        self.layer.masksToBounds = true
    }
}

extension UITextField {
    public func setLeftMargin(marginWidth: CGFloat?)
    {
        let paddingLeft = UIView(frame: CGRectMake(0, 0, marginWidth ?? 8, self.frame.size.height))
        self.leftView = paddingLeft
        self.leftViewMode = UITextFieldViewMode .Always
    }
    public func setRightMargin(marginWidth: CGFloat?)
    {
        let paddingRight = UIView(frame: CGRectMake(0, 0, marginWidth ?? 8, self.frame.size.height))
        self.rightView = paddingRight
        self.rightViewMode = UITextFieldViewMode .Always
    }
}

extension NSDateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat =  dateFormat
    }
}

extension NSDate {
    struct Formatter {
        static let custom = NSDateFormatter(dateFormat: "dd/M/yyyy, H:mm:ss")
    }
    var customFormatted: String {
        return Formatter.custom.stringFromDate(self)
    }
}

extension String {
    var asDate: NSDate? {
        return NSDate.Formatter.custom.dateFromString(self)
    }
    func asDateFormatted(with dateFormat: String) -> NSDate? {
        return NSDateFormatter(dateFormat: dateFormat).dateFromString(self)
    }
}

extension NSDate {
    
    func getElapsedInterval() -> String {
        
        var interval = NSCalendar.currentCalendar().components(.Year, fromDate: self, toDate: NSDate(), options: []).year
        
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "year ago" :
                "\(interval)" + " " + "years ago"
        }
        
        interval = NSCalendar.currentCalendar().components(.Month, fromDate: self, toDate: NSDate(), options: []).month
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "month ago" :
                "\(interval)" + " " + "months ago"
        }
        
        interval = NSCalendar.currentCalendar().components(.Day, fromDate: self, toDate: NSDate(), options: []).day
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "day ago" :
                "\(interval)" + " " + "days ago"
        }
        
        interval = NSCalendar.currentCalendar().components(.Hour, fromDate: self, toDate: NSDate(), options: []).hour
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "hour ago" :
                "\(interval)" + " " + "hours ago"
        }
        
        interval = NSCalendar.currentCalendar().components(.Minute, fromDate: self, toDate: NSDate(), options: []).minute
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "minute ago" :
                "\(interval)" + " " + "minutes ago"
        }
        
        return "a moment ago"
    }
}