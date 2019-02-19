//
//  NoteSearchByDate.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-11.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class NoteSearchByDate: NSObject {
    var arrFamilyMembers = Array<String>()
    
    // MARK: - Current selected sender
    @objc dynamic var sCurrentDate: String {
        willSet {
            if newValue != sCurrentDate {
                //
            }
        }
        didSet {
            if sCurrentDate != oldValue {
                UserDefaults.standard.set(sCurrentDate, forKey: Constants.UserDefaultsKey.NoteDate_string.rawValue)
                //should call the webservice here
                //BibleDatabase.choose_translation(translation_abbreviation: sCurrentTranslation)
            }
        }
    }
    
    
    // MARK: - Singleton
    static let shared = NoteSearchByDate()
    
    private override init () {
        
        //here should be all the family members names
       arrFamilyMembers = UserDefaults.standard.array(forKey: Constants.UserDefaultsKey.FamilyMember_string.rawValue) as! Array<String>
        
        sCurrentDate = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.NoteDate_string.rawValue) ?? "Today"
       
        super.init()
    }
}
