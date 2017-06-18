//
//  AppDelegate.swift
//  Race
//
//  Created by Trevor Stevenson on 7/2/15.
//  Copyright (c) 2015 TStevensonApps. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AdColonyDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        AdColony.configure(withAppID: "app9f99ceaad38e41cdb4", zoneIDs: ["vzfb7f4d4a22a74bd8ab"], delegate: nil, logging: true)
        
        Parse.setApplicationId("Bvbgjy06i5PW3dUtwVPhAj3TKnpQokFfwxDccKA7",
            clientKey: "k7MMuCQ6pXvBfKqlAZCNxEPza2B747HgUJi6nbTJ")
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.responds(to: #selector(getter: UIApplication.backgroundRefreshStatus))
            let oldPushHandlerOnly = !self.responds(to: #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsKey.remoteNotification] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(inBackground: launchOptions, block: nil)
            }
        }
        if application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
            let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
            let settings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
         
            application.registerForRemoteNotifications()
        }
        
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.integer(forKey: "firstTime") == 0
        {
            userDefaults.set(true, forKey: "showAds")
            
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
        
        PFPurchase.addObserver(forProduct: "htCoins") {
            (transaction: SKPaymentTransaction?) -> Void in
            
            var coins = userDefaults.integer(forKey: "coins")
            
            coins += 100000
            
            userDefaults.set(coins, forKey: "coins")
            
            var money = userDefaults.integer(forKey: "moneySpent")
            
            money += 1
            
            userDefaults.set(money, forKey: "moneySpent")
            
            userDefaults.synchronize()
            
        }
        
        PFPurchase.addObserver(forProduct: "mCoins") {
            (transaction: SKPaymentTransaction?) -> Void in
            
            var coins = userDefaults.integer(forKey: "coins")
            
            coins += 1000000
            
            userDefaults.set(coins, forKey: "coins")
            
            var money = userDefaults.integer(forKey: "moneySpent")
            
            money += 2
            
            userDefaults.set(money, forKey: "moneySpent")
            
            userDefaults.synchronize()
            
        }
        
        PFPurchase.addObserver(forProduct: "tmCoins") {
            (transaction: SKPaymentTransaction?) -> Void in
            
            var coins = userDefaults.integer(forKey: "coins")
            
            coins += 10000000
            
            userDefaults.set(coins, forKey: "coins")
            
            var money = userDefaults.integer(forKey: "moneySpent")
            
            money += 5
            
            userDefaults.set(money, forKey: "moneySpent")
            
            userDefaults.synchronize()
            
        }
        
        PFPurchase.addObserver(forProduct: "hmCoins") {
            (transaction: SKPaymentTransaction?) -> Void in
            
            var coins = userDefaults.integer(forKey: "coins")
            
            coins += 100000000
            
            userDefaults.set(coins, forKey: "coins")
            
            var money = userDefaults.integer(forKey: "moneySpent")
            
            money += 10
            
            userDefaults.set(money, forKey: "moneySpent")
            
            userDefaults.synchronize()
            
        }
        
        
        PFPurchase.addObserver(forProduct: "removeAds3") {
            (transaction: SKPaymentTransaction?) -> Void in
            
            userDefaults.set(false, forKey: "showAds")
            
            var money = userDefaults.integer(forKey: "moneySpent")
            
            money += 1
            
            userDefaults.set(money, forKey: "moneySpent")
            
            userDefaults.synchronize()
            
        }
        
        PFPurchase.addObserver(forProduct: "penalty") {
            (transaction: SKPaymentTransaction?) -> Void in
            
            userDefaults.set(true, forKey: "noPenalty")
            
            var money = userDefaults.integer(forKey: "moneySpent")
            
            money += 10
            
            userDefaults.set(money, forKey: "moneySpent")
            
            userDefaults.synchronize()

        }
        
        PFPurchase.addObserver(forProduct: "resetLD") {
            (transaction: SKPaymentTransaction?) -> Void in
            
            userDefaults.set(0, forKey: "losses")
            userDefaults.set(0, forKey: "draws")
            
            var money = userDefaults.integer(forKey: "moneySpent")
            
            money += 2
            
            userDefaults.set(money, forKey: "moneySpent")
            
            userDefaults.synchronize()

        }
        
        PFPurchase.addObserver(forProduct: "reset") {
            (transaction: SKPaymentTransaction?) -> Void in
            
            userDefaults.set(0, forKey: "losses")
            userDefaults.set(0, forKey: "draws")
            userDefaults.set(0, forKey: "wins")
            
            var money = userDefaults.integer(forKey: "moneySpent")
            
            money += 1
            
            userDefaults.set(money, forKey: "moneySpent")
            
            userDefaults.synchronize()
            
        }
        
        PFPurchase.addObserver(forProduct: "uPowerUps") {
            (transaction: SKPaymentTransaction?) -> Void in
            
            userDefaults.set(true, forKey: "unlimited")
            
            var money = userDefaults.integer(forKey: "moneySpent")
            
            money += 20
            
            userDefaults.set(money, forKey: "moneySpent")
            
            userDefaults.synchronize()
            
        }
        
        
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let installation = PFInstallation.current()
        installation.setDeviceTokenFrom(deviceToken)
        installation.saveInBackground(block: nil)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        PFPush.handle(userInfo)
        if application.applicationState == UIApplicationState.inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(inBackground: userInfo, block: nil)
        }
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

