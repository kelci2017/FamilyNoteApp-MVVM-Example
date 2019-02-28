//
//  NoteSubmit.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-11.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class NoteSubmit: NSObject {
    var networkFascilities: NetworkUtil?
    
    var submittedNote: NSMutableDictionary? {
        willSet {
            if newValue != submittedNote {
                //
            }
        }
        didSet {
            if submittedNote != nil {
                
                let sessionid = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue) ?? ""
                
                print("the sessionid is at the submite note: \(String(describing: sessionid))")
                
                let url = "http://192.168.2.126:4000/notes/create?sessionid=\(sessionid)"
                
                networkFascilities?.dataTask(method: .POST, sURL: url, headers: networkFascilities?.setHeaders(), body: submittedNote as? Dictionary<String, String>, completion: { (dictResponse, urlResponse, error) in
                    
                    print("note submite webesrvice call is done")
                  
                    if let response = dictResponse?["__RESPONSE__"] {
                        self.submitResult = response as! Dictionary<String, Any>
                    }
                })
            }
        }
    }
    
    @objc dynamic var submitResult : Dictionary<String, Any> = [:]
    
    override init() {
        
        self.networkFascilities = NetworkUtil()
        
    }
    
}
