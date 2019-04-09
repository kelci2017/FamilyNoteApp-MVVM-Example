//
//  AppDelegate.swift
//  firstproject
//
//  Created by kelci huang on 2018-12-11.
//  Copyright © 2018 kelci huang. All rights reserved.
//

import UIKit
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var reachability = Reachability()!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initReachability()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {

    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
     
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        // for FamilyNote only
        if (Bundle.main.bundleIdentifier == "com.kelci.FamilyNote") && (UIDevice.current.userInterfaceIdiom == .phone) {
            return .portrait
        }
        
        return UIFascilities.lockedOrientation
    }
    
    // MARK: - Reachability
    
    func initReachability() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

}
