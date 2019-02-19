//
//  User.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-11.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import Foundation

class User: NSObject {
    static let shared = User()
    
    private var token : String?
    private var sessionid : String?
    private var userid : String?
    
    private override init() {
        
    }
    
    func setToken(token : String?) {
        self.token = token
    }
    func getToken() -> String? {
        return self.token
    }
    
    func setSessionid(sessionid : String?) {
        self.sessionid = sessionid
    }
    func getSessionid() -> String? {
        return self.sessionid
    }
    
    func setUserid(userid : String?) {
        self.userid = userid
    }
    
    func getUserid() -> String {
        return self.userid!
    }
}
