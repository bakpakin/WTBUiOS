//
//  AppDelegate.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 1/26/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import UIKit

// Enable default logging with XCGLogger
//
// log.verbose("A verbose message, usually useful when working on a specific problem")
// log.debug("A debug message")
// log.info("An info message, probably useful to power users looking in console.app")
// log.warning("A warning message, may indicate a possible error")
// log.error("An error occurred, but it's recoverable, just info about what happened")
// log.severe("A severe error occurred, we are likely about to crash now")
//
import XCGLogger
import AVFoundation
import AudioToolbox
import Alamofire
let log = XCGLogger.defaultInstance()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Set up XCGLogger
        log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true)
        
        // Make the tab bar red, and fix up the navigation bar
        UITabBar.appearance().tintColor = UIColor.redColor()
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        
        // Select the middle tab as the first tab
        let tabBarController = self.window?.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 1
        
        // Notifcations
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        Schedule.defaultSchedule.saveToUserDefaults()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        Schedule.defaultSchedule.saveToUserDefaults()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
    }

    func applicationWillTerminate(application: UIApplication) {
        Schedule.defaultSchedule.saveToUserDefaults()
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        Schedule.defaultSchedule.load() {
            schedule in
            if let show = schedule.getCurrentShow() {
                if show.favorited {
                    let notification = UILocalNotification()
                    notification.fireDate = NSDate(timeIntervalSinceNow: 3)
                    notification.alertBody = "\"\(show.name)\" is on air!"
                    notification.soundName = UILocalNotificationDefaultSoundName
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                }
            }
        }
    }


}

