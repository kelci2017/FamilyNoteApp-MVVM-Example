//
//  Register.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-11.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class Register: NSObject {
    var networkFascilities: NetworkUtil?
    
    var registerBody : NSMutableDictionary? {
        willSet {
            if newValue != registerBody {
                //
            }
        }
        didSet {
            if registerBody != nil {
                let url = "http://192.168.2.126:4000/auth/register"
                
                print("registerBody: \(String(describing: registerBody))")
                
                networkFascilities?.dataTask(method: .POST, sURL: url, headers: nil, body: registerBody as? Dictionary<String, String>, completion: { (dictResponse, urlResponse, error) in
                    
                    if let response = dictResponse?["__RESPONSE__"] {
                        self.registerResult = response as! Dictionary<String, Any>
                        if let resultCode = self.registerResult["resultCode"] as? Int {
                            if resultCode == 0 {
                                UserDefaults.standard.set(self.registerResult["token"] as? String, forKey: Constants.UserDefaultsKey.Token_string.rawValue)
                                UserDefaults.standard.set(self.registerResult["sessionID"] as? String, forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue)
                                UserDefaults.standard.set(self.registerResult["userID"] as? String, forKey: Constants.UserDefaultsKey.Userid_string.rawValue)
                            }
                        }
                    }
                })
            }
        }
    }
    
    @objc dynamic var registerResult  : Dictionary<String, Any> = [:]
    
    convenience init(networkFascilities: NetworkUtil) {
        self.init()
        
        self.networkFascilities = networkFascilities
    }
}
