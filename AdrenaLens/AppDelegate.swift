//
//  AppDelegate.swift
//  AdrenaLens
//
//  Created by Dustin Allen on 7/10/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel
import FBSDKCoreKit
import FBSDKLoginKit
//import Fabric
//import TwitterKit
import IQKeyboardManagerSwift
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Fabric.with([Twitter.self])
        
        let mixpanel = Mixpanel.sharedInstanceWithToken("6628944bd071ab90431d14a4cded3cf0")
        mixpanel.track("App launched")
        
        //FIRApp.configure()
        
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        IQKeyboardManager.sharedManager().enable = true
        
        SVProgressHUD.setDefaultMaskType(.Black)
        SVProgressHUD.setRingThickness(2)
        SVProgressHUD.setAnimationCurve(UIViewAnimationCurve.Linear)
        SVProgressHUD.setForegroundColor(UIColor.orangeColor())

        if let user = NSUserDefaults.standardUserDefaults().objectForKey("userDetail") as? Dictionary<String,AnyObject>
        {
            print(user)
            userDetail = user
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = mainStoryboard.instantiateViewControllerWithIdentifier("navHome") as? UINavigationController
            navigationController?.navigationBarHidden = true // or not, your choice.
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window!.rootViewController = navigationController
            self.window!.makeKeyAndVisible()
        }
        
//        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
//        UINavigationBar.appearance().barTintColor = UIColor.orangeColor()
//        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
//        let view = UIView(frame:CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
//        view.backgroundColor = UIColor.orangeColor()
//        self.window?.rootViewController?.view.addSubview(view)

//        if  let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView {
//            statusBar.backgroundColor = UIColor.orangeColor()
//        }
        
        UITabBar.appearance().itemPositioning = .Centered
        UITabBar.appearance().barTintColor = UIColor.blackColor()
        UITabBar.appearance().tintColor = UIColor(red: 252/255.0, green: 162/255.0, blue: 0.01/255.0, alpha: 1.0)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orangeColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Selected)
        
        return true
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print(deviceToken)
//        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Sandbox)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        
    }
    
    
    func applicationHandleOpenURL(url: NSURL) {
//        if (url.host == "oauth-callback") {
//            OAuthSwift.handleOpenURL(url)
//        } else {
//            // Google provider is the only one wuth your.bundle.id url schema.
//            OAuthSwift.handleOpenURL(url)
//        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        applicationHandleOpenURL(url)
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        applicationHandleOpenURL(url)
        return FBSDKApplicationDelegate.sharedInstance().application(
            app,
            openURL: url,
            sourceApplication: options["UIApplicationOpenURLOptionsSourceApplicationKey"] as! String,
            annotation: nil)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        print("Disconnected from FCM.")
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        //FBSDKAccessToken.currentAccessToken().tokenStringFBSDKAccessToken.currentAccessToken().tokenString
        
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.harloch.Connect_App" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("What2Watch", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    //MARK: Helper method to convert the NSDate to NSDateComponents
    func dateComponentFromNSDate(date: NSDate)-> NSDateComponents{
        
        let calendarUnit: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
        let dateComponents = NSCalendar.currentCalendar().components(calendarUnit, fromDate: date)
        return dateComponents
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        // ...
    }
}