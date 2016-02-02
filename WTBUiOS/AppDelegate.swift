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
let log = XCGLogger.defaultInstance()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let middle = storyboard.instantiateViewControllerWithIdentifier("middle")
        let top = storyboard.instantiateViewControllerWithIdentifier("top")
        let viewContainer = LayoutViewController.containerViewWith(middle, topVC: top)
        self.window?.rootViewController = viewContainer
        self.window?.makeKeyAndVisible()
        
        // Set up XCGLogger
        log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

