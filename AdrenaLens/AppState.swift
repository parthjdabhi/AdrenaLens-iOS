//
//  AppState.swift
//  Connect App
//
//  Created by Dustin Allen on 6/27/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import Firebase

import Alamofire
import SwiftyJSON

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoUrl: NSURL?    
    var currentUser: FIRDataSnapshot!
}

var userDetail:Dictionary<String,AnyObject> = [:]
var timeline:Array<JSON> = []