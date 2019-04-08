//
//  RegisterViewController.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-07.
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
    @IBOutlet weak var baseView: UIView!
    
    var registerVM : Register?
    
    var registerObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerVM = Register()
        registerButton.setBorder(borderWidth: 0, borderColor: .orange, cornerRadius: 5)
        
        registerObservation = registerVM?.observe(\Register.registerResult, options: [.old, .new]) { [weak self] object, change in
   
                DispatchQueue.main.async { [weak self] in
                    self?.baseView.isUserInteractionEnabled = true
                    let resultCode = self?.registerVM?.registerResult["resultCode"] as! Int
                    if resultCode == Constants.ErrorCode.success.rawValue {
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
    
    if enterPasswordTextfield.text?.trimmingCharacters(in: .whitespaces) != reEnterPasswordTextField.text?.trimmingCharacters(in: .whitespaces) {
        CommonUtil.showDialog(title: "Password is not the same!", message: "Please re-enter your password.", viewController: self)
        return
    }
    if !((emailTextfield.text?.trimmingCharacters(in: .whitespaces).isValidEmail())!) {
        CommonUtil.showDialog(title: "Wrong email format!", message: "Please enter a valid email address.", viewController: self)
        return
    }
    if enterPasswordTextfield.text?.trimmingCharacters(in: .whitespaces).count ?? 0 < 8 {
        CommonUtil.showDialog(title: "Password too short!", message: "Please enter a password at least 8 characters.", viewController: self)
        return
    }
    if CommonUtil.hasSpecialCharacters(string: self.enterPasswordTextfield.text?.trimmingCharacters(in: .whitespaces) ?? "") {
        CommonUtil.showDialog(title: "No special characters!", message: "Please do not include special characters in the password.", viewController: self)
        return
    }
    
    let jsonRegister: NSMutableDictionary? = NSMutableDictionary()
    
    jsonRegister?.setValue(emailTextfield.text?.trimmingCharacters(in: .whitespaces), forKey: Constants.UserLoginCrendentialsKey.userName.rawValue)
    jsonRegister?.setValue(enterPasswordTextfield.text?.trimmingCharacters(in: .whitespaces), forKey: Constants.UserLoginCrendentialsKey.password.rawValue)
    
    registerVM?.registerBody = jsonRegister
    self.baseView.isUserInteractionEnabled = false
    
    }

   @IBAction func back() {
        self.dismiss(animated: true, completion: {
            //
        })
    }
    

}
