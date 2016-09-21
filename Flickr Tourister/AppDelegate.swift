//
//  AppDelegate.swift
//  Flickr Tourister
//
//  Created by Pushkar Sharma on 16/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        sharedContext.performAndWait {
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        sharedContext.performAndWait {
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        sharedContext.performAndWait {
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }


}

