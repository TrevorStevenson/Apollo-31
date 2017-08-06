//
//  AppDelegate.swift
//  Race
//
//  Created by Trevor Stevenson on 7/2/15.
//  Copyright (c) 2015 TStevensonApps. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Register for Push Notitications
        if application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:)))
        {
            let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
            let settings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        else
        {
            application.registerForRemoteNotifications()
        }
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.integer(forKey: "firstTime") == 0
        {
            userDefaults.set(0, forKey: "wins")
            userDefaults.set(0, forKey: "losses")
            userDefaults.set(0, forKey: "draws")
            userDefaults.set(50000, forKey: "coins")
            userDefaults.set(0, forKey: "moneySpent")
            userDefaults.set(0, forKey: "powerUpsUsed")
            
            userDefaults.set(0, forKey: "highScoreMinutes")
            userDefaults.set(0, forKey: "highScoreSeconds")
            userDefaults.set(0, forKey: "highScoreDecimal")
            
            userDefaults.set(false, forKey: "noPenalty")
            userDefaults.set(false, forKey: "unlimited")
            
            userDefaults.set(1, forKey: "firstTime")
            
            userDefaults.synchronize()
        }
        
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

