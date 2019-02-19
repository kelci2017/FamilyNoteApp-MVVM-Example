//
//  NoteSearchByReceiver.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-11.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class NoteSearchByReceiver: NSObject {
    var arrFamilyMembers = Array<String>()
    
    // MARK: - Current selected sender
    @objc dynamic var sCurrentReceiver: String {
        willSet {
            if newValue != sCurrentReceiver {
                //
            }
        }
        didSet {
            if sCurrentReceiver != oldValue {
                UserDefaults.standard.set(sCurrentReceiver, forKey: Constants.UserDefaultsKey.NoteReceiver_string.rawValue)
                //should call the webservice here
                //BibleDatabase.choose_translation(translation_abbreviation: sCurrentTranslation)
            }
        }
    }
    
    
    // MARK: - Singleton
    static let shared = NoteSearchByReceiver()
    
    private override init () {
        
        //here should be all the family members names
        arrFamilyMembers = UserDefaults.standard.array(forKey: Constants.UserDefaultsKey.FamilyMember_string.rawValue) as! Array<String>
        
        sCurrentReceiver = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.NoteReceiver_string.rawValue) ?? "ALL"
        
        super.init()
    }
}
