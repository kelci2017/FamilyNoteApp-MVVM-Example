//
//  AddFamilyMember.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-12.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import Foundation

class AddFamilyMember: NSObject {
    
    
    // MARK: - ArrayFamilyMembers
    @objc dynamic var arrFamilyMembers : Array<String>! {
        willSet {
            if newValue != arrFamilyMembers {
                //
            }
        }
        didSet {
            if arrFamilyMembers != nil {
                arrFamilyMembers += UserDefaults.standard.array(forKey: Constants.UserDefaultsKey.FamilyMember_string.rawValue) as? Array<String> ?? []
                UserDefaults.standard.set(arrFamilyMembers, forKey: Constants.UserDefaultsKey.FamilyMember_string.rawValue)
            }
        }
    }
    
    
    // MARK: - Singleton
    static let shared = AddFamilyMember()
    
    private override init () {
        
        arrFamilyMembers = UserDefaults.standard.array(forKey: Constants.UserDefaultsKey.FamilyMember_string.rawValue) as? Array<String> ?? []
        
        super.init()
    }
}
