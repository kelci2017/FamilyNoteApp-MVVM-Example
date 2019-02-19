//
//  NoteSearchBySender.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-11.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import Foundation

class NoteSearchBySender: NSObject {
    var arrFamilyMembers = Array<String>()
    
    // MARK: - Current selected sender
    @objc dynamic var sCurrentSender: String {
        willSet {
            if newValue != sCurrentSender {
                //
            }
        }
        didSet {
            if sCurrentSender != oldValue {
                UserDefaults.standard.set(sCurrentSender, forKey: Constants.UserDefaultsKey.NoteSender_string.rawValue)
                //should call the webservice here
                //BibleDatabase.choose_translation(translation_abbreviation: sCurrentTranslation)
            }
        }
    }
    
    
    // MARK: - Singleton
    static let shared = NoteSearchBySender()
    
    private override init () {
        
        //here should be all the family members names
       
        arrFamilyMembers = UserDefaults.standard.array(forKey: Constants.UserDefaultsKey.FamilyMember_string.rawValue) as! Array<String>
        
        sCurrentSender = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.NoteSender_string.rawValue) ?? "ALL"
        
        super.init()
    }
}
