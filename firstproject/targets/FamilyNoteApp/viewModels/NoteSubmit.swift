//
//  NoteSubmit.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-11.
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
                
                let sessionid = User.shared.getSessionid()
                
                let url = "http://192.168.2.126:4000/notes/create?sessionid=\(sessionid)"
                
                networkFascilities?.dataTask(method: .POST, sURL: url, headers: nil, body: submittedNote as! Dictionary<String, String>, completion: { (dictResponse, urlResponse, error) in
                    
                    self.submitResult = dictResponse ?? [:]
                })
            }
        }
    }
    
    @objc dynamic var submitResult : Dictionary<String, Any> = [:]
    
    convenience init(networkFascilities: NetworkUtil) {
        self.init()
        
        self.networkFascilities = networkFascilities
    }
}
