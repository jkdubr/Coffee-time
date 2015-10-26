//
//  AppDelegate.swift
//  Coffee time
//
//  Created by Jakub Dubrovsky on 07/10/15.
//  Copyright © 2015 Jakub Dubrovsky. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        let userNotificationTypes = UIUserNotificationSettings(forTypes:[.Alert, .Badge, .Sound], categories: nil) //|  UIUserNotificationType.Badge |  UIUserNotificationType.Sound)
        
        //   let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(userNotificationTypes)
        application.registerForRemoteNotifications()
        
        self.registerForNotification()
        
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        
        Parse.setApplicationId("00mMbLmX4sA7INHVvJSRveNj1deb2lU7B1nbzudD",
            clientKey: "aMBiiUJkk3fzJJcPsCf714ng3O0z03hnfKvLf6tD")
        
        
        print("device token: \(PFInstallation.currentInstallation().deviceToken)")
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackgroundWithBlock {
            (_) -> Void in
            print("ok")
        }
        
        
    }
    
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: \(error)");
        }
    }
    
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        
        /*
        // Check if in background
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        
        // User opened the push notification
        
        } else {
        
        // User hasn't opened it, this was a silent update
        
        }
        */
        
        
        
        
        print("did recieve")
        print(userInfo)
        
        
        if let a = userInfo["del"] as? String {
            
            print("alert: \(a)")
            if a == "del" {
                print("calcel no")
                UIApplication.sharedApplication().applicationIconBadgeNumber = 1
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                
            }
        } else {
            /*
            let notification = UILocalNotification() // create a new reminder notification
            notification.alertBody = "Reminder: Todo Item  Is Overdue" // text that will be displayed in the notification
            notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
            //        notification.fireDate = NSDate().dateByAddingTimeInterval(30 * 60) // 30 minutes from current time
            notification.soundName = UILocalNotificationDefaultSoundName // play default sound
            notification.userInfo = ["title": "xt1", "UUID": "xuuid1"] // assign a unique identifier to the notification that we can use to retrieve it later
            
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            */
            
            PFPush.handlePush(userInfo)
        }
        
        
        
        completionHandler(UIBackgroundFetchResult.NoData)
        
    }
    
    
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        print("userinfo:")
        print(userInfo)
        
        if var value = identifier {
            if let beaconMin = userInfo["min"], let beaconMax = userInfo["max"], let deviceToken = PFInstallation.currentInstallation().deviceToken {
                
                if let response = responseInfo[UIUserNotificationActionResponseTypedTextKey], responseText = response as? String {
                    value = "\(value): \(responseText)"
                }
                
                let obj = [
                    "value" :   value,
                    "min"   :   beaconMin,
                    "max"   :   beaconMax,
                    "deviceToken":deviceToken
                    ] as NSDictionary
                
                RestClient.sharedInstance.post("functions/regionResponse", object: obj) {
                    json in
                    print(json)
                    completionHandler()
                }
            }
        }
        
        
        
        
    }
    
    func registerForNotification(){
        let action1 = UIMutableUserNotificationAction()
        action1.activationMode = UIUserNotificationActivationMode.Background
        action1.title = "👍"
        action1.identifier = "+"
        //👍🏻👎👍🏻👍
        action1.destructive = false
        action1.authenticationRequired = false
        action1.behavior = .Default
        
        let action2 = UIMutableUserNotificationAction()
        action2.activationMode = UIUserNotificationActivationMode.Background
        action2.title = "✍"
        action2.identifier = "-"
        action2.destructive = false
        action2.authenticationRequired = false
        action2.behavior = .TextInput
        
        let actionCategory = UIMutableUserNotificationCategory()
        actionCategory.identifier = "c1"
        actionCategory.setActions([action1, action2], forContext: UIUserNotificationActionContext.Default)
        
        let settings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound], categories: [actionCategory])
        
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        
        
    }
}

