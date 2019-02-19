//
//  SchedulerViewController.swift
//  firstproject
//
//  Created by kelci huang on 2018-12-14.
//  Copyright © 2018 kelci huang. All rights reserved.
//

import UIKit

class SchedulerViewController: SchedulerBaseViewController {
    
    fileprivate var viewControllerToShow : UIViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        Global.shared.scheduler = SchedulerClass()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewControllerToShow = Global.shared.scheduler!.upcomingViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.present(viewControllerToShow!, animated: false, completion: {
            //
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
