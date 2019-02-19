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
        
        if User.shared.getSessionid() != nil {
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
