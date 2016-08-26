//
//  Constants.swift
//  Connect App
//
//  Created by Dustin Allen on 6/27/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

struct Constants {
    
    struct NotificationKeys {
        static let SignedIn = "onSignInCompleted"
    }
    
    struct Segues {
        static let AddSocial = "AddSocial"
        static let FpToSignIn = "FPToSignIn"
    }
    
    struct MessageFields {
        static let name = "name"
        static let text = "text"
        static let photoUrl = "photoUrl"
        static let imageUrl = "imageUrl"
    }
}

let BaseURL  = "http://adrenalensapp.com/API/"

//Login Registration API
let url_Login  = BaseURL + "login.php"
let url_Register  = BaseURL + "register.php"
let url_SetProfile  = BaseURL + ""
let url_SetProfilePic  = BaseURL + "profile.php"

//Image API
let url_AddPhoto  = BaseURL + ""
let url_ListPhoto  = BaseURL + ""

/*
 http://adrenalensapp.com/API/register.php
 
 Parameter :
 
 submitted = 1
 name
 email
 username
 password
 
 
 http://adrenalensapp.com/API/login.php
 
 Parameter :
 
 submitted = 1
 username
 password
 
 
 http://adrenalensapp.com/API/profile.php
 
 
 submitted = 1
 unique_id
 user_id
 profile_photo
 
 {
 "profile_photo" = "http://adrenalensapp.com/API/app-users-upload/ios265/profile_image.png";
 "unique_id" = ios265;
 "user_email" = "ios2@gmail.com";
 "user_id" = 20;
 "user_name" = ios2;
 }
 
 */

/*
 *
 */