//
//  UIFascilities.swift
//  TemplateApp
//
//  Created by kelci huang on 2018-10-27.
//  Copyright © 2018 kelci huang. All rights reserved.
//

import UIKit

class UIFascilities: NSObject {
    
    static let activityIndicatorTag = 0x5A2D79D1
    static let popUpActionViewsTag = 0x37E3C8EE
    
    
    
    // MARK: - Orientation
    
    static var lockedOrientation: UIInterfaceOrientationMask = .all
    
    class func lockUpOrientation(orientation: UIInterfaceOrientationMask? = nil) {
        if orientation != nil {
            lockedOrientation = orientation!
        }
        else {
            switch UIApplication.shared.statusBarOrientation {
            case .portrait:
                lockedOrientation = .portrait
                
            case .portraitUpsideDown:
                lockedOrientation = .portraitUpsideDown
                
            case .landscapeLeft:
                lockedOrientation = .landscapeLeft
                
            case .landscapeRight:
                lockedOrientation = .landscapeRight
                
            default:
                lockedOrientation = .all
                break
            }
        }
    }

    class func unlockOrientation() {
        lockedOrientation = .all
    }
    
    class func forceOrientation(orientation: UIInterfaceOrientation) {
        let value = orientation.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}
