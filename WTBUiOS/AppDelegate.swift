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
import SWXMLHash
import Parse
import Bolts
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
        
        // Parse.
        Parse.setApplicationId("1YQrSQX8ISBBkVdXA2tgSmv0j2cBOx878Es5d5lD",
            clientKey: "zplY28RZTzs5SqiUog33vcDlCIqP7FaJcVS28daA")
        

        
        //Parse FOR LATER 
        /*
        let configuration = ParseClientConfiguration {
            $0.applicationId = "YOUR_APP_ID"
            $0.server = "http://YOUR_PARSE_SERVER:1337/parse"
        }
        Parse.initializeWithConfiguration(configuration)
        */
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }


}

