//
//  Login.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-11.
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
                                User.shared.setToken(token: self.loginResult["token"] as? String)
                                User.shared.setSessionid(sessionid: self.loginResult["sessionID"] as? String)
                                User.shared.setUserid(userid: self.loginResult["userID"] as? String)
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
