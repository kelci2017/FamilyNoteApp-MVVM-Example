//
//  Login.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-11.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class Login: NSObject {
   
    var networkFascilities: NetworkUtil?
    
    var loginBody : NSMutableDictionary? {
        willSet {
            if newValue != loginBody {
                //
            }
        }
        didSet {
            if loginBody != nil {
                print("loginBody: \(String(describing: loginBody))")
                let url = "http://192.168.2.126:4000/auth/sign_in"
                
                networkFascilities?.dataTask(method: .POST, sURL: url, headers: nil, body: loginBody as? Dictionary<String, String>, completion: { (dictResponse, urlResponse, error) in
                    print("login web service was called")
                    if let response = dictResponse?["__RESPONSE__"] {
                        self.loginResult = response as! Dictionary<String, Any>
                        if let resultCode = self.loginResult["resultCode"] as? Int {
                            if resultCode == 0 {
                                 UserDefaults.standard.set(self.loginResult["token"] as? String, forKey: Constants.UserDefaultsKey.Token_string.rawValue)
                                UserDefaults.standard.set(self.loginResult["sessionID"] as? String, forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue)
                                UserDefaults.standard.set(self.loginResult["userID"] as? String, forKey: Constants.UserDefaultsKey.Userid_string.rawValue)
                            }
                        }
                    }
                })
            }
        }
    }
    
    @objc dynamic var loginResult  : Dictionary<String, Any> = [:]
    
    convenience init(networkFascilities: NetworkUtil) {
        self.init()
        
        self.networkFascilities = networkFascilities
    }
}
