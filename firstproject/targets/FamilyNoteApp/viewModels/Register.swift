//
//  Register.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-11.
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
                
                networkFascilities?.dataTask(method: .POST, sURL: url, headers: nil, body: registerBody as! Dictionary<String, String>, completion: { (dictResponse, urlResponse, error) in
                    
                    self.registerResult = dictResponse ?? [:]
                    if self.registerResult["resultCode"] as! Int == 0 {
                        User.shared.setToken(token: self.registerResult["token"] as! String)
                        User.shared.setSessionid(sessionid: self.registerResult["sessionID"] as! String)
                        User.shared.setUserid(userid: self.registerResult["userID"] as! String)
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
