//
//  RegisterViewController.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-07.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class RegisterViewController: RootViewController {

    @IBOutlet weak var reEnterPasswordView: UIView!
    @IBOutlet weak var enterPasswordView: UIView!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var enterEmailView: UIView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var enterPasswordTextfield: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    
    var registerVM = Register()
    
    var registerObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerVM = Register(networkFascilities: networkFascilities!)
        
        registerObservation = registerVM.observe(\Register.registerResult, options: [.old, .new]) { [weak self] object, change in
   
                DispatchQueue.main.async { [weak self] in
                    let resultCode = self?.registerVM.registerResult["resultCode"] as! Int
                    if resultCode == 0 {
                        self?.dismiss(animated: true, completion: {
                            //
                        })
                    }
                    else {
                       self?.showResultErrorAlert(resultCode: resultCode)
                    }
                }
            
        }
    }
    
   @IBAction func register() {
    
    if enterPasswordTextfield.text != reEnterPasswordTextField.text {
        CommonUtil.showDialog(title: "Password is not the same!", message: "Please re-enter your password.", viewController: self)
        return
    }
    
    let jsonRegister: NSMutableDictionary? = NSMutableDictionary()
    
    jsonRegister?.setValue(emailTextfield.text, forKey: Constants.UserLoginCrendentialsKey.userName.rawValue)
    jsonRegister?.setValue(enterPasswordTextfield.text, forKey: Constants.UserLoginCrendentialsKey.password.rawValue)
    
    registerVM.registerBody = jsonRegister
    
    }

   @IBAction func back() {
        self.dismiss(animated: true, completion: {
            //
        })
    }
    
    
    
    
}
