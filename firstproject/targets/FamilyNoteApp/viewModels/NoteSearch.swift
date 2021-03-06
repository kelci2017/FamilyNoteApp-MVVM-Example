//
//  NoteSearch.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-14.
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

            let url = CommonUtil.getConfigServerUrl()! + "/notes/search?from=\(from)&to=\(to)&date=\(date)&sessionid=\(sessionid ?? "")"
            print("url at search is: \(String(url))")
            
                networkFascilities?.dataTask(method: .GET, sURL: url, headers: networkFascilities?.setHeaders(), body: nil, completion: { (dictResponse, urlResponse, error) in
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
                
                let url = CommonUtil.getConfigServerUrl()! + "/notes/globalSearch/\(sCurrentSearch)?sessionid=\(sessionid ?? "")"
                
                networkFascilities?.dataTask(method: .GET, sURL: url, headers: networkFascilities?.setHeaders(), body: nil, completion: { (dictResponse, urlResponse, error) in
                    
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
        
        self.networkFascilities = NetworkUtil()
        
    }
}
