//
//  SchedulerClass.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2018-12-20.
//  Copyright © 2018 kelci huang. All rights reserved.
//

import UIKit

class SchedulerClass: NSObject, SchedulerDelegate {
    
    
    var schedulerViewController: SchedulerViewController? = nil
    var homePage: HomePage? = nil
    var loginPage: LoginViewController? = nil
    fileprivate var isLoggedIn : Bool = false
    fileprivate var isLogout : Bool = false
    fileprivate var nextViewController : UIViewController? = nil
    
    func upcomingViewController() -> UIViewController? {

        if isLoggedIn {
            homePage = HomePage()
            nextViewController = homePage
        } else {
            loginPage = LoginViewController()
            loginPage?.delegate = self
            nextViewController = loginPage
        }
        if isLogout {
            loginPage = LoginViewController()
            loginPage?.delegate = self
            nextViewController = loginPage
        }
        return nextViewController
    }
    
    
    // MARK: - SchedulerDelegate
    
    func loginDidSucceed() {
        isLoggedIn = true
    }
    
    func logoutDidSucceed() {
        isLoggedIn = false
        isLogout = false
        homePage?.dismiss(animated: false, completion: {
            //
        })
    }

}

protocol SchedulerDelegate {
    func loginDidSucceed()
    func loginDidFail()
    func loginDidCancel()
    func logoutDidSucceed()
    func logoutDidFail()
}

extension SchedulerDelegate {
    
    func loginDidFail() {
        
    }
    
    func loginDidCancel() {
        
    }
    
    func logoutDidFail() {
        
    }
    
}
