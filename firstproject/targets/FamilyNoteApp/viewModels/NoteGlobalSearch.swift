//
//  NoteGlobalSearch.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-11.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class NoteGlobalSearch: NSObject {
    var arrFamilyMembers = Array<String>()
    var networkFascilities: NetworkUtil?
    
    // MARK: - Current selected sender
    var sCurrentSearch: String {
        willSet {
            if newValue != sCurrentSearch {
                //
            }
        }
        didSet {
            if sCurrentSearch != "" {
                UserDefaults.standard.set(sCurrentSearch, forKey: Constants.UserDefaultsKey.NoteSearch_string.rawValue)
                
                let sessionid = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue)
                
                let url = "http://192.168.2.126:4000/notes/globalSearch/\(sCurrentSearch)?sessionid=\(sessionid ?? "")"
                let token = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Token_string.rawValue) ?? ""
                var dictHeaders: [String:String] = [:]
                
                dictHeaders["authorization"] = "Bearer \(token)"
                dictHeaders["content-type"] = "application/json"
                
                networkFascilities?.dataTask(method: .GET, sURL: url, headers: dictHeaders, body: nil, completion: { (dictResponse, urlResponse, error) in
                    
                    if let response = dictResponse?["__RESPONSE__"] {
                        self.globalSearchResult = response as! Dictionary<String, Any>
                    }
                })
            }
        }
    }
    
    @objc dynamic var globalSearchResult : Dictionary<String, Any> = [:]
    
    
    override init () {
        //here should be all the family members names
        arrFamilyMembers = UserDefaults.standard.array(forKey: Constants.UserDefaultsKey.FamilyMember_string.rawValue) as? Array<String> ?? []
        
        sCurrentSearch = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.NoteSearch_string.rawValue) ?? "ALL"
        
        super.init()
        
        
    }
    
    convenience init(networkFascilities: NetworkUtil) {
        self.init()
        
        self.networkFascilities = networkFascilities
    }
}
