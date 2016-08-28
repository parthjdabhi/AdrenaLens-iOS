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
let url_SetProfilePic  = BaseURL + "profile.php"
let url_SetProfile  = BaseURL + ""

//Image API
let url_PostPhoto  = BaseURL + "upload_photo.php"
let url_timeline  = BaseURL + "timeline.php"
let url_myTimeline  = BaseURL + "my_timeline.php"


/*
 http:// adrenalensapp.com/API/register.php
 submitted = 1
 name
 email
 username
 password
 
 
 http:// adrenalensapp.com/API/login.php
 submitted = 1
 username
 password
 
 
 http:// adrenalensapp.com/API/profile.php
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
 
 http:// adrenalensapp.com/API/upload_photo.php
 submitted = 1
 user_id
 unique_id
 caption
 user_upload_time
 photo
 
 http:// adrenalensapp.com/API/timeline.php
 submitted = 1
 
 {
 "user_upload_time" : "28\/8\/2016, 18:21:42",
 "caption" : "Write your caption",
 "user_photo" : {
 "user_email" : "parthjdabhi@gmail.com",
 "user_id" : "2",
 "unique_id" : "parthjdabhi12",
 "profile_photo" : "",
 "user_name" : "Parth"
 },
 "photo" : "http:\/\/adrenalensapp.com\/API\/app-users-upload\/parthjdabhi12\/file.1472388820.png"
 }
 
 http:// adrenalensapp.com/API/my_timeline.php
 submitted = 1
 user_id
 
 */

/*
 *
 */