//
//  FamilyNoteScheduler.swift
//  tempproject
//
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class FamilyNoteScheduler: NSObject, SchedulerViewControllerDataSource {
    
    fileprivate var mainTabBarViewController: MainTabBarViewController? = nil
    fileprivate var signInViewController: SigninViewController? = nil
    
    func upcomingViewController() -> UIViewController? {
        var upcomingViewController: UIViewController? = nil
        
        upcomingViewController = signInViewController
        
        if UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue) != nil &&  UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue) != ""{
            if mainTabBarViewController == nil {
                mainTabBarViewController = MainTabBarViewController()
            }
            upcomingViewController = mainTabBarViewController
        } else {
            if signInViewController == nil {
                signInViewController = SigninViewController()
            }
            upcomingViewController = signInViewController
        }
        
        
        return upcomingViewController
    }

}
