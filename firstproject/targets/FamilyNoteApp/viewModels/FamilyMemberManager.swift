//
//  AddFamilyMember.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-12.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import Foundation

class FamilyMemberManager: NSObject {
    
    var networkFascilities: NetworkUtil?
    var postFamilyMembers: Bool = true
    // MARK: - ArrayFamilyMembers
    @objc dynamic var arrFamilyMembers : Array<String> = [] {
        willSet {
            if newValue != arrFamilyMembers {
                //
            }
        }
        didSet {
            if arrFamilyMembers.count > 0 && postFamilyMembers{
                
                arrFamilyMembers += UserDefaults.standard.array(forKey: Constants.UserDefaultsKey.FamilyMember_string.rawValue) as? Array<String> ?? []
                
                let sessionid = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue)
                let userid = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Userid_string.rawValue)
                
                let url = "http://192.168.2.126:4000/auth/familyMembers?sessionid=\(sessionid ?? "")"
                
                var userFamilyMembers : Dictionary<String, Any> = [:]
                userFamilyMembers["userID"] = userid
                userFamilyMembers["familyMembers"] = arrFamilyMembers
                
                print("arrFamilyMembers")
                print(arrFamilyMembers)
                
                networkFascilities?.dataTask(method: .POST, sURL: url, headers: networkFascilities?.setHeaders(), body: userFamilyMembers, completion: { (dictResponse, urlResponse, error) in
                    if let response = dictResponse?["__RESPONSE__"] {
                        self.postFamilyMembersResult = response as! Dictionary<String, Any>
                    }
                })
            }
            UserDefaults.standard.set(arrFamilyMembers, forKey: Constants.UserDefaultsKey.FamilyMember_string.rawValue)
        }
    }
    
    @objc dynamic var postFamilyMembersResult : Dictionary<String, Any> = [:]
    
    // MARK: - Singleton
    static let shared = FamilyMemberManager()
    
    private override init () {
      
        super.init()
        self.networkFascilities = NetworkUtil()
        loadFamilyMembers()
    }
    
    func loadFamilyMembers() {
        let sessionid = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue)
        
        let url = "http://192.168.2.126:4000/auth/familyMembers?sessionid=\(sessionid ?? "")"

        networkFascilities?.dataTask(method: .GET, sURL: url, headers: networkFascilities?.setHeaders(), body: nil, completion: { (dictResponse, urlResponse, error) in
            if let response = dictResponse?["__RESPONSE__"] {
                var responseCopy = response as! Dictionary<String, Any>
                if let resultCode = responseCopy["resultCode"] as? Int {
                    if resultCode != 0 {
                        if resultCode == 16 {
                            UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.Token_string.rawValue)
                            UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue)
                        } else if resultCode == 21 {
                            UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.Token_string.rawValue)
                        }
                    } else {
                        let arrFamilyMembers = responseCopy["resultDesc"]
                        if arrFamilyMembers is Array<String> {
                            self.postFamilyMembers = false
                            self.arrFamilyMembers = arrFamilyMembers as! Array<String>
                        }
                    }
                }
            }
        })
    }
}
