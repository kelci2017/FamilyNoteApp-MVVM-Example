//
//  TargetManager.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-04.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import Foundation

class TargetManager: NSObject {
    enum Target {
        case Undefined, testApp, FamilyNoteApp
    }
    
    static let shared = TargetManager()
    
    var target: Target = .Undefined
    
    private override init() {
        let sTargetName = CommonUtil.getTargetName() ?? "Unknown"
        switch sTargetName {
        case "testApp":
            target = .testApp
        case "FamilyNoteApp":
            target = .FamilyNoteApp
        default:
            target = .Undefined
        }
    }
}
