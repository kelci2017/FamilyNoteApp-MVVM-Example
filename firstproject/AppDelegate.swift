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
    var appDelegatesArray: Array<RootViewController> = []
    var arrAppL2ViewControllerDelegates: Array<RootViewController> = []
    var mainTabBarViewController: TabViewController? = nil
    var reachability = Reachability()!
    var networkFacilities : NetworkUtil?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        loadFamilyMembers()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        for delegate in arrAppL2ViewControllerDelegates {
            delegate.applicationWillResignActive(self)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        for delegate in arrAppL2ViewControllerDelegates {
            delegate.applicationDidEnterBackground(self)
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        for delegate in arrAppL2ViewControllerDelegates {
            delegate.applicationWillEnterForeground(self)
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        for delegate in arrAppL2ViewControllerDelegates {
            delegate.applicationDidBecomeActive(self)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        for delegate in arrAppL2ViewControllerDelegates {
            delegate.applicationWillTerminate(self)
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIFascilities.lockedOrientation
    }
    
    func loadFamilyMembers() {
        let sessionid = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue)
        
        let url = "http://192.168.2.126:4000/auth/familyMembers?sessionid=\(sessionid ?? "")"
        networkFacilities = NetworkUtil()
        networkFacilities?.dataTask(method: .GET, sURL: url, headers: networkFacilities?.setHeaders(), body: nil, completion: { (dictResponse, urlResponse, error) in
            if let response = dictResponse?["__RESPONSE__"] {
                var responseCopy = response as! Dictionary<String, Any>
                if let resultCode = responseCopy["resultCode"] as? Int {
                    if resultCode != 0 {
                        if resultCode == 16 {
                            UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.Token_string.rawValue)
                            UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue)
                        } else if resultCode == 21 {
                            UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.Token_string.rawValue)
                        }
                    } else {
                        let arrFamilyMembers = responseCopy["resultDesc"]
                        if arrFamilyMembers is Array<String> {
                            UserDefaults.standard.set(arrFamilyMembers, forKey: Constants.UserDefaultsKey.FamilyMember_string.rawValue)
                        }
                    }
                }
            }
        })
    }
    // MARK: - Reachability
    
    func initReachability() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            
            for delegate in self.arrAppL2ViewControllerDelegates {
                delegate.applicationReachabilityUpdate(reachability.connection)
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            
            for delegate in self.arrAppL2ViewControllerDelegates {
                delegate.applicationReachabilityUpdate(Reachability.Connection.none)
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
    // MARK: - App Protocol Related
    
    func registerAppL2ViewControllerDelegate(delegate: RootViewController) {
        for registeredDelegate in arrAppL2ViewControllerDelegates {
            if registeredDelegate === delegate {
                return
            }
        }
        arrAppL2ViewControllerDelegates.append(delegate)
    }
    
    func deregisterAppL2ViewControllerDelegate(delegate: RootViewController) {
        let count = arrAppL2ViewControllerDelegates.count
        for i in 0..<count {
            if arrAppL2ViewControllerDelegates[i] === delegate {
                arrAppL2ViewControllerDelegates.remove(at: i)
                return
            }
        }
    }
}



protocol AppL2DelegateProtocol {
    func applicationWillResignActive(_ application: AppDelegate)
    func applicationDidEnterBackground(_ application: AppDelegate)
    func applicationWillEnterForeground(_ application: AppDelegate)
    func applicationDidBecomeActive(_ application: AppDelegate)
    func applicationWillTerminate(_ application: AppDelegate)
    
    func applicationReachabilityUpdate(_ reachability: Reachability.Connection)
}

extension AppL2DelegateProtocol {
    
    func applicationWillResignActive(_ application: AppDelegate) {
        
    }
    
    func applicationDidEnterBackground(_ application: AppDelegate) {
        
    }
    
    func applicationWillEnterForeground(_ application: AppDelegate) {
        
    }
    
    func applicationDidBecomeActive(_ application: AppDelegate) {
        
    }
    
    func applicationWillTerminate(_ application: AppDelegate) {
        
    }
    
    func applicationReachabilityUpdate(_ reachability: Reachability.Connection) {
        
    }
    
}
