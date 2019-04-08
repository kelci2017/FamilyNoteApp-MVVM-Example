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
                let url = CommonUtil.getConfigServerUrl()! + "/auth/sign_in"
                
                networkFascilities?.dataTask(method: .POST, sURL: url, headers: nil, body: loginBody as? Dictionary<String, String>, completion: { (dictResponse, urlResponse, error) in
                    print("login web service was called")
                    if let response = dictResponse?["__RESPONSE__"] {
                        self.loginResult = response as! Dictionary<String, Any>
                        if let resultCode = self.loginResult["resultCode"] as? Int {
                            if resultCode == Constants.ErrorCode.success.rawValue{
                                print("login success")
                                 UserDefaults.standard.set(self.loginResult["token"] as? String, forKey: Constants.UserDefaultsKey.Token_string.rawValue)
                                UserDefaults.standard.set(self.loginResult["sessionID"] as? String, forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue)
                                UserDefaults.standard.set(self.loginResult["userID"] as? String, forKey: Constants.UserDefaultsKey.Userid_string.rawValue)
                                print("loginin userid is: \(String(describing: self.loginResult["userID"]))")
                            }
                        }
                    }
                })
            }
        }
    }
    
    @objc dynamic var loginResult  : Dictionary<String, Any> = [:]
    
    override init() {
        
        self.networkFascilities = NetworkUtil()
        
    }
}
