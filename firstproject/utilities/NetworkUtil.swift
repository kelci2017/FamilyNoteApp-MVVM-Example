//
//  NetworkUtil.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-11.
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
    static var dictSessions: [String: AnyObject] = [:] // [sSessionId:sessionOwner]
    
    convenience init(sessionOwner owner: AnyObject?) {
        self.init()
        sessionOwner = owner
        sessionOwnerState = .active
    }
    
    class func newSessionId() -> String {
        let uuidString = NSUUID().uuidString
        return uuidString
    }
    
    func dataTask(method: NetworkSessionMethod, sURL: String, headers dictHeaders: Dictionary<String, String>?, body dictBody: Dictionary<String, String>?, completion: @escaping (Dictionary<String, Any>?, URLResponse?, Error?) -> ()) {
        let url = URL(string: sURL)
        if url != nil {
            // URLSession.shared.dataTask(with: url!, completionHandler: completion).resume()
            
            var request = URLRequest(url: url!)
            request.httpMethod = method.rawValue
            var dictHeaders: [String:String] = dictHeaders ?? [:]
            let contentType = dictHeaders["content-type"]
            if contentType == nil {
                dictHeaders["content-type"] = "application/json"
            }
            for (httpHeaderField, value) in dictHeaders {
                request.addValue(value, forHTTPHeaderField: httpHeaderField)
            }
            if (dictBody != nil) && (dictBody!.count > 0) {
                request.httpBody = try! JSONSerialization.data(withJSONObject: dictBody!, options: [])
            }
            
            let sSessionId = NetworkUtil.newSessionId()
            
            DispatchQueue.main.async {
                NetworkUtil.mainThread_sessionWillStart(byOwner: self.sessionOwner, withSessionId: sSessionId)
                _ = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
                    DispatchQueue.main.asyncAfter(deadline: (.now() + .seconds(NetworkUtil.debug_resonse_delay)), execute: {
                        let sessionOwner = NetworkUtil.dictSessions[sSessionId]
                        NetworkUtil.mainThread_sessionDidEnd(withSessionId: sSessionId)
                        if (sessionOwner != nil) && (self.sessionOwnerState == .active) {
                            if let urlResponse = urlResponse,
                                let data = data,
                                let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                                let dictResponse = ["__RESPONSE__":jsonData]
                                completion(dictResponse, urlResponse, error)
                            } else {
                                let dictResponse = ["__FAILURE__":"Response abnormal. Discarded."]
                                completion(dictResponse, urlResponse, error)
                            }
                        }
                        else {
                            let dictResponse = ["__CANCELLED__":"Network session's owner is not active. Response discarded."]
                            completion(dictResponse, urlResponse, error)
                        }
                    })}.resume()
            }
        }
    }
    
    /**
     *  MUST be called within MAINTHREAD
     *  owner: if nil, will use appDelegate
     *  tag: use 0 or negative value for automatic increment
     */
    static func mainThread_sessionWillStart(byOwner owner: AnyObject?, withSessionId sSessionId: String) {
        var sessionOwner = owner
        if sessionOwner ==  nil {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            sessionOwner = appDelegate
        }
        dictSessions[sSessionId] = sessionOwner
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


}
