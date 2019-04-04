//
//  Logout.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-11.
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
                
                let sessionid = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue) ?? ""
                
                let url = CommonUtil.getConfigServerUrl()! + "/auth/sign_out?sessionid=\(sessionid)"
                
                networkFascilities?.dataTask(method: .GET, sURL: url, headers: networkFascilities?.setHeaders(), body: nil, completion: { (dictResponse, urlResponse, error) in
                    
                    if let response = dictResponse?["__RESPONSE__"] {
                        self.logoutResult = response as! Dictionary<String, Any>
                        if let resultCode = self.logoutResult["resultCode"] as? Int {
                            if resultCode == 0 {
                                UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.Token_string.rawValue)
                                UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue)

                            }
                        }
                    }
                })
            }
            
        }
    }
    
    @objc dynamic var logoutResult : Dictionary<String, Any> = [:]
    
    override init() {
        
        self.networkFascilities = NetworkUtil()
        
    }
}
