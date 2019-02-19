//
//  SchedulerBaseViewController.swift
//  firstproject
//
//  Created by kelci huang on 2018-12-18.
//  Copyright © 2018 kelci huang. All rights reserved.
//

import UIKit

class SchedulerBaseViewController: UIViewController {

    // MARK: Properties
    fileprivate var familyNoteScheduler: FamilyNoteScheduler!
    fileprivate var testAppScheduler: TestAppScheduler!
    fileprivate var upcomingViewController: UIViewController? = nil
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        familyNoteScheduler = FamilyNoteScheduler.init()
        testAppScheduler = TestAppScheduler.init()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch TargetManager.shared.target {
        case .FamilyNoteApp:
            upcomingViewController = familyNoteScheduler.upcomingViewController()
            break
            
        case .testApp:
            upcomingViewController = testAppScheduler.upcomingViewController()
            break
            
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if upcomingViewController != nil {
            self.present(upcomingViewController!, animated: false) {
                //
            }
        }
    }
    
}


protocol SchedulerViewControllerDataSource {
    func upcomingViewController() -> UIViewController?
}


protocol SchedulerViewControllerDelegate {
    
}
