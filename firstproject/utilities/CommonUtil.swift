//
//  CommonUtil.swift
//  firstproject
//
//  Created by kelci huang on 2018-12-18.
//  Copyright © 2018 kelci huang. All rights reserved.
//

import UIKit

class CommonUtil: NSObject {
    class func image(from view: UIView) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
        
    }
    
    
    
    class func scale(image: UIImage?, to size: CGSize, backgroundColor: UIColor = UIColor.clear) -> UIImage? {
        
        guard image != nil else {
            return nil
        }
        
        guard (size.width >= 1) && (size.height >= 1) else {
            
            return nil
            
        }
        
        let imageSize = image!.size
        
        guard (imageSize.width >= 1) && (imageSize.height >= 1) else {
            
            return nil
            
        }
        
        var scaleSize: CGSize = CGSize(width: size.width, height: size.height)
        
        if size.width / size.height > imageSize.width / imageSize.height {
            
            scaleSize.width = imageSize.width / imageSize.height * size.height
            
        }
            
        else {
            
            scaleSize.height = imageSize.height / imageSize.width * size.width
            
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: scaleSize.width, height: scaleSize.height))
        
        view.backgroundColor = backgroundColor
        
        let imageView = UIImageView(frame: view.frame)
        
        view.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFit
        
        imageView.image = image
        
        return self.image(from: view)
    }
    
    class func showToast(message : String, viewController : UIViewController) {
        print("now you come to the commonuti showtoast function")
        let toastLabel = UILabel(frame: CGRect(x: viewController.view.frame.size.width/2 - 75, y: viewController.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        print(toastLabel.text!)
        viewController.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    class func showDialog(title : String, message : String, viewController : RootViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            alert.dismiss(animated: true, completion: {
                //
            })
        }))
        
        // show the alert
        viewController.present(alert, animated: true, completion: nil)
        
    }
    // MARK: Path of Resource
    
    class func pathOfResource(name: String, ext: String) -> String? {
        let path = Bundle.main.path(forResource: name, ofType: ext)
        return path
    }
    
    // MARK: - Plist
    
    class func getPlist(name: String) -> NSDictionary? {
        let sPath = pathOfResource(name: name, ext: "plist")
        guard sPath != nil else {
            return nil
        }
        let dictPlist = NSDictionary(contentsOfFile: sPath!)
        return dictPlist
    }
    
    // MARK: - Config.plist
    
    fileprivate static var dictConfigPlist: NSDictionary? = nil
    @discardableResult
    class func getConfigPlist() -> NSDictionary? {
        if dictConfigPlist != nil {
            return dictConfigPlist
        }
        
        dictConfigPlist = getPlist(name: "Config")
        
        return dictConfigPlist
    }
    
    fileprivate static var dictConfigTarget: NSDictionary? = nil
    @discardableResult
    class func getConfigTarget() -> NSDictionary? {
        if dictConfigTarget != nil {
            return dictConfigTarget
        }
        
        if dictConfigPlist == nil {
            getConfigPlist()
        }
        guard dictConfigPlist != nil else {
            return nil
        }
        
        let dictTarget = dictConfigPlist!["Target"] as? NSDictionary
        guard dictTarget != nil else {
            return nil
        }
        
        let index = dictTarget!["Index"] as? Int ?? 0
        let arrOptions = dictTarget!["Options"] as? NSArray
        guard (arrOptions != nil) && (arrOptions!.count > 0) else {
            return nil
        }
        
        dictConfigTarget = arrOptions![index] as? NSDictionary
        
        return dictConfigTarget
    }
    
    fileprivate static var sTargetName: NSString? = nil
    class func getTargetName() -> NSString? {
        if sTargetName != nil {
            return sTargetName
        }
        
        if dictConfigTarget == nil {
            getConfigTarget()
        }
        guard dictConfigTarget != nil else {
            return nil
        }
        
        sTargetName = dictConfigTarget!["Name"] as? NSString
        
        return sTargetName
    }
    
    fileprivate static var sStartingView: NSString? = nil
    class func getStartingView() -> NSString? {
        if sStartingView != nil {
            return sStartingView
        }
        
        if dictConfigTarget == nil {
            getConfigTarget()
        }
        guard dictConfigTarget != nil else {
            return nil
        }
        
        let dictUI = dictConfigTarget!["UI"] as? NSDictionary
        guard dictUI != nil else {
            return nil
        }
        
        let dictStartingView = dictUI!["StartingView"] as? NSDictionary
        guard dictStartingView != nil else {
            return nil
        }
        
        let index = dictStartingView!["Index"] as? Int ?? 0
        let arrOptions = dictStartingView!["Options"] as? NSArray
        guard (arrOptions != nil) && (arrOptions!.count > 0) else {
            return nil
        }
        
        sStartingView = arrOptions![index] as? NSString
        
        return sStartingView
    }
    
    fileprivate static var sNavigationBarBackgroundColorCode: NSString? = nil
    class func getNavigationBarBackgroundColorCode() -> NSString? {
        if sNavigationBarBackgroundColorCode != nil {
            return sNavigationBarBackgroundColorCode
        }
        
        if dictConfigTarget == nil {
            getConfigTarget()
        }
        guard dictConfigTarget != nil else {
            return nil
        }
        
        let dictUI = dictConfigTarget!["UI"] as? NSDictionary
        guard dictUI != nil else {
            return nil
        }
        
        let dictColors = dictUI!["Colors"] as? NSDictionary
        guard dictColors != nil else {
            return nil
        }
        
        let dictNavigationBar = dictColors!["NavigationBar"] as? NSDictionary
        guard dictNavigationBar != nil else {
            return nil
        }
        
        sNavigationBarBackgroundColorCode = dictNavigationBar!["BackgroundColor"] as? NSString
        
        return sNavigationBarBackgroundColorCode
    }
    
    fileprivate static var sNavigationBarForegroundColorCode: NSString? = nil
    class func getNavigationBarForegroundColorCode() -> NSString? {
        if sNavigationBarForegroundColorCode != nil {
            return sNavigationBarForegroundColorCode
        }
        
        if dictConfigTarget == nil {
            getConfigTarget()
        }
        guard dictConfigTarget != nil else {
            return nil
        }
        
        let dictUI = dictConfigTarget!["UI"] as? NSDictionary
        guard dictUI != nil else {
            return nil
        }
        
        let dictColors = dictUI!["Colors"] as? NSDictionary
        guard dictColors != nil else {
            return nil
        }
        
        let dictNavigationBar = dictColors!["NavigationBar"] as? NSDictionary
        guard dictNavigationBar != nil else {
            return nil
        }
        
        sNavigationBarForegroundColorCode = dictNavigationBar!["ForegroundColor"] as? NSString
        
        return sNavigationBarForegroundColorCode
    }
    
}
