//
//  Logout.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-11.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class Logout: NSObject {
    var networkFascilities: NetworkUtil?
    
    var loggedout = false {
        willSet {
            if newValue != loggedout {
                //
            }
        }
        didSet {
            if loggedout == true {
                
                let sessionid = User.shared.getSessionid()
                
                let url = "http://192.168.2.126:4000/auth/sign_out?sessionid=\(sessionid)"
                
                networkFascilities?.dataTask(method: .GET, sURL: url, headers: nil, body: nil, completion: { (dictResponse, urlResponse, error) in
                    
                    self.logoutResult = dictResponse ?? [:]
                    if self.logoutResult["resultCode"] as! Int == 0 {
                        User.shared.setToken(token: nil)
                        User.shared.setSessionid(sessionid: nil)
                    }
                })
            }
            
        }
    }
    
    @objc dynamic var logoutResult : Dictionary<String, Any> = [:]
    
    convenience init(networkFascilities: NetworkUtil) {
        self.init()
        
        self.networkFascilities = networkFascilities
    }
}
