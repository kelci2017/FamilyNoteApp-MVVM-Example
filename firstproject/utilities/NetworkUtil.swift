//
//  NetworkUtil.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-11.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class NetworkUtil: NSObject {
    enum NetworkSessionOwnerState {
        case undefined, active, inactive
    }
    
    enum NetworkSessionMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    
    static let debug_resonse_delay: Int = 0 // to add an extra delay onto response time
    
    weak var sessionOwner: AnyObject? = nil
    var sessionOwnerState: NetworkSessionOwnerState = .undefined
    static var dictSessions: [String: AnyObject] = [:]
    
    class func newSessionId() -> String {
        let uuidString = NSUUID().uuidString
        return uuidString
    }
    
    func dataTask(method: NetworkSessionMethod, sURL: String, headers dictHeaders: Dictionary<String, String>?, body dictBody: Dictionary<String, Any>?, completion: @escaping (Dictionary<String, Any>?, URLResponse?, Error?) -> ()) {
        let url = URL(string: sURL)
        if url != nil {

            var dictHeaders: [String:String] = dictHeaders ?? [:]
            let contentType = dictHeaders["content-type"]
            if contentType == nil {
                nextTask(method: method, url: url!, headers: dictHeaders, body: dictBody, completion: completion)
                return
            }
            
            if dictHeaders["authorization"] == nil {
                let sessionid = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue) ?? ""
                let getTokenUrl = CommonUtil.getConfigServerUrl()! + "/auth/getToken?sessionid=\(sessionid)"
                let tokenUrl = URL(string: getTokenUrl)
                var request = URLRequest(url: tokenUrl!)
                request.httpMethod = method.rawValue
                DispatchQueue.main.async {
                    _ = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
                        DispatchQueue.main.asyncAfter(deadline: (.now() + .seconds(NetworkUtil.debug_resonse_delay)), execute: {
                                if let data = data,
                                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                                    let dictResponse = ["__RESPONSE__":jsonData]
                                    let response = dictResponse["__RESPONSE__"] as! Dictionary<String, Any>
                                    UserDefaults.standard.set(response["token"] as? String, forKey: Constants.UserDefaultsKey.Token_string.rawValue)
                                    self.nextTask(method: method, url: url!, headers: dictHeaders, body: dictBody, completion: completion)
                                } else {
                                    let dictResponse = ["__FAILURE__":"Response abnormal. Discarded."]
                                    completion(dictResponse, urlResponse, error)
                                }
                        })}.resume()
                }
            } else {
                nextTask(method: method, url: url!, headers: dictHeaders, body: dictBody, completion: completion)
            }
        }
    }
  
    func nextTask(method: NetworkSessionMethod, url: URL, headers dictHeaders: Dictionary<String, String>?, body dictBody: Dictionary<String, Any>?, completion: @escaping (Dictionary<String, Any>?, URLResponse?, Error?) -> ()) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        var dictHeaders: [String:String] = dictHeaders ?? [:]
        if dictHeaders["content-type"] == nil {
            dictHeaders["content-type"] = "application/json"
        }
        for (httpHeaderField, value) in dictHeaders {
            request.addValue(value, forHTTPHeaderField: httpHeaderField)
        }
        if (dictBody != nil) && (dictBody!.count > 0) {
            request.httpBody = try! JSONSerialization.data(withJSONObject: dictBody!, options: [])
        }

        DispatchQueue.main.async {
            _ = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
                DispatchQueue.main.asyncAfter(deadline: (.now() + .seconds(NetworkUtil.debug_resonse_delay)), execute: {
                        if let urlResponse = urlResponse,
                            let data = data,
                            let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                            let dictResponse = ["__RESPONSE__":jsonData]
                            completion(dictResponse, urlResponse, error)
                        } else {
                            let dictResponse = ["__FAILURE__":"Response abnormal. Discarded."]
                            completion(dictResponse, urlResponse, error)
                        }
                })}.resume()
        }
    }
    
    /**
     *  MUST be called within MAINTHREAD
     */
    static func mainThread_sessionDidEnd(withSessionId sSessionId: String) {
        dictSessions.removeValue(forKey: sSessionId)
    }
    
    class func cancelSessions(forOwner owner: AnyObject) {
        if Thread.isMainThread {
            mainThread_cancelSessions(forOwner: owner)
        }
        else {
            DispatchQueue.main.async {
                mainThread_cancelSessions(forOwner: owner)
            }
        }
    }
    
    static func mainThread_cancelSessions(forOwner cancellingOwner: AnyObject) {
        var dictTemp: Dictionary<String, AnyObject> = [:]
        for (sSessionId, owner) in dictSessions {
            if !(owner === cancellingOwner) {
                dictTemp[sSessionId] = owner
            }
        }
        dictSessions = dictTemp
    }
    
    class func cancellAllSessions() {
        if Thread.isMainThread {
            dictSessions = [:]
        }
        else {
            DispatchQueue.main.async {
                dictSessions = [:]
            }
        }
    }

    func setHeaders() -> Dictionary<String, String> {
        let token = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Token_string.rawValue)
        var dictHeaders: [String:String] = [:]
        
        if token != nil {
            dictHeaders["authorization"] = "Bearer \(token!)"
        }
        dictHeaders["content-type"] = "application/json"
        return dictHeaders
    }
}
