//
//  HomeTabViewController.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2018-12-21.
//  Copyright © 2018 kelci huang. All rights reserved.
//

import UIKit

class HomeViewController: RootViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    fileprivate var home2Page : Home2Page? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func clickedEvent(_ sender: Any) {
        if sender as AnyObject === nextButton {
            let home2Page = Home2Page()
            self.navigationController?.pushViewController(home2Page, animated: true)
        } else if sender as AnyObject === logoutButton {
            Global.shared.scheduler?.logoutDidSucceed()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
