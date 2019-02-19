//
//  FirstPage.swift
//  firstproject
//
//  Created by kelci huang on 2018-12-14.
//  Copyright © 2018 kelci huang. All rights reserved.
//

import UIKit

class HomePage: TabViewController {

    fileprivate var tab0ViewController: HomeViewController? = nil
    fileprivate var tab1ViewController: SettingViewController? = nil
    fileprivate var tab2ViewController: MeViewController? = nil
    
    fileprivate var tab0NavigationViewController: NavigationViewController?  = nil
    fileprivate var tab1NavigationViewController: NavigationViewController?  = nil
    fileprivate var tab2NavigationViewController: NavigationViewController?  = nil
    
    fileprivate var imageHome: UIImage? = nil
    fileprivate var imageSetting: UIImage? = nil
    fileprivate var imageMe: UIImage? = nil
    
    override func createTabs() {
        tab0ViewController = HomeViewController()
        imageHome = CommonUtil.scale(image: UIImage(named: "home.png"), to: CGSize(width: 20, height: 20))
        tab0ViewController!.tabBarItem = UITabBarItem(title: "Home", image: imageHome, tag: 0)
        tab0NavigationViewController = NavigationViewController(rootViewController: tab0ViewController!)
        
        tab1ViewController = SettingViewController()
        imageSetting = CommonUtil.scale(image: UIImage(named: "setting.png"), to: CGSize(width: 20, height: 20))
        tab1ViewController!.tabBarItem = UITabBarItem(title: "Setting", image: imageSetting, tag: 1)
        tab1NavigationViewController = NavigationViewController(rootViewController: tab1ViewController!)
        
        tab2ViewController = MeViewController()
        imageMe = CommonUtil.scale(image: UIImage(named: "user.png"), to: CGSize(width: 20, height: 20))
        tab2ViewController!.tabBarItem = UITabBarItem(title: "Me", image: imageMe, tag: 1)
        tab2NavigationViewController = NavigationViewController(rootViewController: tab2ViewController!)
        
        self.viewControllers = [tab0NavigationViewController!, tab1NavigationViewController!, tab2NavigationViewController!]
    }
}
