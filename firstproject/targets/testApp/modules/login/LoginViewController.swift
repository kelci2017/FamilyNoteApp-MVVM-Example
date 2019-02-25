//
//  LoginViewController.swift
//  firstproject
//
//  Created by kelci huang on 2018-12-13.
//  Copyright © 2018 kelci huang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    fileprivate var isLoginSuccess : Bool? = false

    
    @IBOutlet weak var buttonLogin: UIButton!
    
    @IBOutlet weak var buttonCancel: UIButton!
    
    var delegate: SchedulerDelegate? = nil
    
    override func viewDidLoad() {
        print("the login page was loaded")
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        
        if sender as AnyObject === buttonLogin {
            print("the login in button was clicked")
            isLoginSuccess = true;
            delegate?.loginDidSucceed()
            dismiss(animated: false) {
                //
            }
        } else if sender as AnyObject === buttonCancel {
            print("cancel button was clicked")
            isLoginSuccess = false
            delegate?.loginDidCancel()
        }
    }

}

