//
//  AppDelegate.swift
//  tips
//
//  Created by Manuel Deschamps on 4/21/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        NSUserDefaults.standardUserDefaults().setDouble(NSProcessInfo.processInfo().systemUptime, forKey: "background_time")
        
        NSNotificationCenter.defaultCenter().postNotification(NSNotification.init(name: "tipsAppDidEnterBackground", object: nil))
    }

    func applicationWillEnterForeground(application: UIApplication) {
        let bgTime = NSUserDefaults.standardUserDefaults().doubleForKey("background_time")
        
        // restore state if less than 10min (600 seconds) have passed
        if (NSProcessInfo.processInfo().systemUptime - bgTime) < 600.0 {
            NSNotificationCenter.defaultCenter().postNotification(NSNotification.init(name: "tipsAppWillEnterForeground", object: nil))
        }
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("background_time")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

