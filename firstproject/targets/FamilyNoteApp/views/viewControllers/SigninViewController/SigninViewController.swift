//
//  SigninViewController.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-07.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class SigninViewController: RootViewController {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var logoContainerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var userContainerView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordImageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationContainerView: UIView!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var registrationButton: UIButton!
    
    var loginVM: Login?
    
    var loginObservation: NSKeyValueObservation?
    
    fileprivate var registerViewController : RegisterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginVM = Login()
        
        if UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.UserName_string.rawValue) != nil {
            userTextField.text = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.UserName_string.rawValue)
        }
        
        loginButton.setBorder(borderWidth: 0, borderColor: .orange, cornerRadius: 5)
        userTextField.delegate = self
        passwordTextField.delegate = self
        extraMarginBetweenFirstResponderAndKeyboard = 146
        
        loginObservation = loginVM?.observe(\Login.loginResult, options: [.old, .new]) { [weak self] object, change in
            //check the result is true or false
            self?.baseView.isUserInteractionEnabled = true
            if let resultCode = self?.loginVM?.loginResult["resultCode"] as? Int {
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
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue) != nil {
            self.dismiss(animated: false, completion: {
                //
            })
        }
    }
    
    @IBAction func login() {
        
        if userTextField.text == nil {
            CommonUtil.showDialog(title: "Empty email!", message: "Please enter your email.", viewController: self)
            return
        }
        if passwordTextField.text == nil {
            CommonUtil.showDialog(title: "Empty password!", message: "Please enter your password.", viewController: self)
            return
        }
        if !((userTextField.text?.isValidEmail())!) {
            CommonUtil.showDialog(title: "Wrong email format!", message: "Please enter a valid email address.", viewController: self)
            return
        }
        let jsonRegister: NSMutableDictionary? = NSMutableDictionary()
        
        jsonRegister?.setValue(userTextField.text?.trimmingCharacters(in: .whitespaces), forKey: Constants.UserLoginCrendentialsKey.userName.rawValue)
        jsonRegister?.setValue(passwordTextField.text?.trimmingCharacters(in: .whitespaces), forKey: Constants.UserLoginCrendentialsKey.password.rawValue)
        
        loginVM!.loginBody = jsonRegister
        self.baseView.isUserInteractionEnabled = false
        
    }
    
    @IBAction func register() {
        if registerViewController == nil {
            registerViewController = RegisterViewController()
        }
        self.present(registerViewController!, animated: true)
    }

}
