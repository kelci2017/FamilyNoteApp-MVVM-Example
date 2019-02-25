//
//  Constants.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-12.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import Foundation

class Constants: NSObject {
    enum UserDefaultsKey: String {
        case NoteSender_string = "NoteSender_string"
        case NoteReceiver_string = "NoteReceiver_string"
        case NoteDate_string = "NoteDate_string"
        case NoteSearch_string = "NoteSearch_string"
        case FamilyMember_string = "FamilyMember_string"
        case UserName_string = "UserName_string"
        case Sessionid_string = "Sessionid_string"
        case Token_string = "Token_string"
        case Userid_string = "Userid_string"
    }
    
    enum UserLoginCrendentialsKey : String {
        case userName = "email"
        case password = "password"
    }
    
    enum NoteKey : String {
        case sender = "fromWhom"
        case receiver = "toWhom"
        case notebody = "noteBody"
        case createDate = "created"
        case userID = "userID"
    }
    
    enum ResultCode : String {
        case unknownError = "Unknown error!"
        case networkError = "Network error!"
        case resultNull = "Result is null!"
        case wrongPassword = "Wrong password!"
        case userNotFound = "User was not found!"
        case userHasRegistered = "User has registered!"
        case accessDenied = "Access denied!"
        case sessionTimeout = "Session timeout!"
        case emailNotFound = "Email was not found!"
        case tokenExpired = "Token expired!"
        case signatureFailed = "Signature failed!"
        case tokenNotFound = "Token not found!"
        case keyInvalid = "Invalid key!"
        case wrongTokenScheme = "Wrong token scheme!"
    }
}
