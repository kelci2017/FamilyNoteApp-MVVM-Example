//
//  Extensions.swift
//  TemplateApp
//
//  Created by kelci huang on 2018-11-20.
//  Copyright © 2018 kelci huang. All rights reserved.
//

import UIKit
import Foundation

class Extensions: NSObject {

}

extension String {
    
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

extension UIColor {
    
    var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
    
    // e.g. "#EEEEEE"
    class func color(withHexColorCode hexColorCode: NSString?) -> UIColor? {
        guard hexColorCode != nil else {
            return nil
        }
        
        var sHexColorCode = String("\(hexColorCode!)")
        sHexColorCode = sHexColorCode.trimmingCharacters(in: CharacterSet.whitespaces)
        guard sHexColorCode.hasPrefix("#") && (sHexColorCode.count == 7) else {
            return nil
        }
        let red = CGFloat(UInt(String(sHexColorCode.dropFirst(1).prefix(2)), radix: 16) ?? 0)
        let green = CGFloat(UInt(String(sHexColorCode.dropFirst(3).prefix(2)), radix: 16) ?? 0)
        let blue = CGFloat(UInt(String(sHexColorCode.suffix(2)), radix: 16) ?? 0)
        let color = UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
        
        return color
    }
    
    class func defaultButtonTitleColor() -> UIColor {
        return color(withHexColorCode: "#007AFF")! // 7A=122
    }

}


extension UIFont {
    var bold: UIFont {
        return with(traits: .traitBold)
    } // bold
    
    var italic: UIFont {
        return with(traits: .traitItalic)
    } // italic
    
    var boldItalic: UIFont {
        return with(traits: [.traitBold, .traitItalic])
    } // boldItalic
    
    
    func with(traits: UIFontDescriptorSymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        } // guard
        
        return UIFont(descriptor: descriptor, size: 0)
    }
}


extension UIImage {
    
    class func image(from view: UIView?) -> UIImage? {
        guard view != nil else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(view!.bounds.size, false, 0)
        view!.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func navigationBackImage() -> UIImage? {
        let buttonHeight: CGFloat = 30
        let imageWidth: CGFloat = 15
        let imageHeight: CGFloat = 24
        let space: CGFloat = 4
        let horizontalMargin: CGFloat = 4
        
        let imageViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        imageViewContainer.backgroundColor = UIColor.clear
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageViewContainer.frame.width, height: imageViewContainer.frame.height))
        imageView.backgroundColor = UIColor.clear
        imageViewContainer.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "backArrow_buttontitlecolor_160x256.png")
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.defaultButtonTitleColor()
        label.textAlignment = .center
        label.text = "Back"
        label.sizeToFit()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 2 * horizontalMargin + imageViewContainer.frame.width + space + label.frame.width, height: buttonHeight))
        view.backgroundColor = UIColor.clear
        view.addSubview(imageViewContainer)
        view.addSubview(label)
        
        var frame = imageViewContainer.frame
        frame.origin.x = 0
        frame.origin.y = (view.frame.height - imageViewContainer.frame.height) / 2
        imageViewContainer.frame = frame
        
        frame = label.frame
        frame.origin.x = imageViewContainer.frame.origin.x + imageViewContainer.frame.width + space
        frame.origin.y = (view.frame.height - label.frame.height) / 2
        label.frame = frame
        
        return image(from: view)
    }
    
}


extension UIView {
    
    func absolutePosition(to outerView: UIView?) -> CGPoint {
        var absolutePosition = CGPoint(x: 0, y: 0)
        
        if self.superview == nil {
            return absolutePosition
        }
        
        absolutePosition = self.superview!.convert(self.frame.origin, to: outerView ?? UIApplication.shared.keyWindow?.rootViewController?.view)
        
        return absolutePosition
    }

    
    func setBorder(borderWidth: CGFloat, borderColor: UIColor?, cornerRadius: CGFloat) {
        self.layer.borderWidth = borderWidth
        if borderColor != nil {
            self.layer.borderColor = borderColor?.cgColor
        }
        self.makeRoundCorner(cornerRadius: cornerRadius)
    }
    
    func makeRoundCorner(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func makeRound() {
        let radius = min(self.frame.size.width, self.frame.size.height) / 2
        self.makeRoundCorner(cornerRadius: radius)
    }
    
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

extension UIDevice
{
    func uuid() -> String {
        if let uuidString = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.DeviceUUID_string.rawValue) {
            return uuidString
        }
        
        let uuidString = UUID().uuidString
        UserDefaults.standard.set(uuidString, forKey: Constants.UserDefaultsKey.DeviceUUID_string.rawValue)
        return uuidString
    }
}

extension Bundle {
    
    var releaseVersionNumber: String? {
        
        return infoDictionary?["CFBundleShortVersionString"] as? String
        
    }
    
    var buildVersionNumber: String? {
        
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
}
