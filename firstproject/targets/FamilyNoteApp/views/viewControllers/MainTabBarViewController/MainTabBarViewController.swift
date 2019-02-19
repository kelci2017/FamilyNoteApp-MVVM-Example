//
//  MainTabBarViewController.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-07.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class MainTabBarViewController: TabViewController {

    fileprivate var noteboardViewController: NoteboardViewController? = nil
    fileprivate var notepadViewController: NotepadViewController? = nil
    fileprivate var settingsViewController: SettingsViewController? = nil
    
    fileprivate var noteboardNavigationViewController: NavigationViewController?  = nil
    fileprivate var notepadNavigationViewController: NavigationViewController?  = nil
    fileprivate var settingsNavigationViewController: NavigationViewController?  = nil
    
    fileprivate var imageNoteboard: UIImage? = nil
    fileprivate var imageSetting: UIImage? = nil
    fileprivate var imageNotepad: UIImage? = nil
   
    
    override func createTabs() {
        
        noteboardViewController = NoteboardViewController()
        imageNoteboard = CommonUtil.scale(image: UIImage(named: "noteboard.jpg"), to: CGSize(width: 20, height: 20))
        noteboardViewController!.tabBarItem = UITabBarItem(title: "Noteboard", image: imageNoteboard, tag: 0)
        noteboardNavigationViewController = NavigationViewController(rootViewController: noteboardViewController!)
        
        notepadViewController = NotepadViewController()
        imageNotepad = CommonUtil.scale(image: UIImage(named: "notepad.png"), to: CGSize(width: 20, height: 20))
        notepadViewController!.tabBarItem = UITabBarItem(title: "Notepad", image: imageNotepad, tag: 1)
        notepadNavigationViewController = NavigationViewController(rootViewController: notepadViewController!)
        
        settingsViewController = SettingsViewController()
        imageSetting = CommonUtil.scale(image: UIImage(named: "setting.png"), to: CGSize(width: 20, height: 20))
        settingsViewController!.tabBarItem = UITabBarItem(title: "Settings", image: imageSetting, tag: 1)
        settingsNavigationViewController = NavigationViewController(rootViewController: settingsViewController!)
        
        self.viewControllers = [noteboardNavigationViewController!, notepadNavigationViewController!, settingsNavigationViewController] as! [UIViewController]
    }
}
