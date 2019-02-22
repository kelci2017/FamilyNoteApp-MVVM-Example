//
//  NoteSearch.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-14.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class NoteSearch: NSObject {
    
    var networkFascilities: NetworkUtil?
    
    // MARK: - Current selected sender
    @objc dynamic var searchArray = ["", "", ""] {
        willSet {
            if newValue != searchArray {
                //
            }
        }
        didSet {
            //array compare??
            //if searchArray != nil {
                
                let from = searchArray[0]
                let to = searchArray[1]
                let date = searchArray[2]
                let sessionid = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue)
                print("from: \(String(from)) to: \(String(to)) date: \(String(date))")
                let url = "http://192.168.2.126:4000/notes/search?from=\(from)&to=\(to)&date=\(date)&sessionid=\(sessionid ?? "")"
                print(url)
                networkFascilities?.dataTask(method: .GET, sURL: url, headers: nil, body: nil, completion: { (dictResponse, urlResponse, error) in
                    if let response = dictResponse?["__RESPONSE__"] {
                        self.searchResult = response as! Dictionary<String, Any>
                    }
                })
            
        }
    }
    
    var sCurrentSearch: String {
        willSet {
            if newValue != sCurrentSearch {
                //
            }
        }
        didSet {
            if sCurrentSearch != "" {
                
                let sessionid = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue)
                
                let url = "http://192.168.2.126:4000/notes/globalSearch/\(sCurrentSearch)?sessionid=\(sessionid ?? "")"
                
                networkFascilities?.dataTask(method: .GET, sURL: url, headers: nil, body: nil, completion: { (dictResponse, urlResponse, error) in
                    
                    if let response = dictResponse?["__RESPONSE__"] {
                        self.searchResult = response as! Dictionary<String, Any>
                    }
                })
            }
        }
    }
    
    @objc dynamic var searchResult : Dictionary<String, Any> = [:]
    
    // MARK: - Singleton
    static let shared = NoteSearch()
    
    private override init () {
        
        self.sCurrentSearch = ""
        
        super.init()
        
        self.networkFascilities = NetworkUtil(sessionOwner: self)
        
        
        //test()
        
    }
    
//    func test() {
//        var arrResultDesc: [Dictionary<String, Any>] = []
//        arrResultDesc.append(["_id": "ff80", "fromWhom": "Kelci", "toWhom": "Alisa", "noteBody": "test", "created":"today morning", "userID": "456a", "__v": 0])
//        arrResultDesc.append(["_id": "733f", "fromWhom": "Kelci", "toWhom": "Alisa", "noteBody": "test", "created":"today noon", "userID": "456a", "__v": 0])
//        searchResult["resultCode"] = 0
//        searchResult["resultDesc"] = arrResultDesc
//    }
}
