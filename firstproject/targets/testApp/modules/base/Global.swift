//
//  Global.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2018-12-21.
//  Copyright © 2018 kelci huang. All rights reserved.
//

import UIKit

class Global: NSObject {

    static let shared = Global()
    
    private override init() {
        
    }
    
    var scheduler: SchedulerClass? = nil
    
}
