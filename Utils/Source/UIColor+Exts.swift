//
//  UIColor+Exts.swift
//  Utils
//
//  Created by Dao Van Nha on 09/10/2023.
//

import Foundation
import UIKit

public extension UIColor {
    static func rgb(_ r: Int, _ g: Int, _ b: Int) -> UIColor {
        rgba(r, g, b, 1.0)
    }
    
    static func rgba(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat) -> UIColor {
        UIColor(red: CGFloat(r) / 255.0,
                green: CGFloat(g) / 255.0,
                blue: CGFloat(b) / 255.0,
                alpha: a)
    }
    
    static func hex(_ hex: Int) -> UIColor {
        rgb((hex >> 16) & 0xFF,
            (hex >> 8) & 0xFF,
            hex & 0xFF)
    }
    
    var hexString: String? {
        guard let components = self.cgColor.components else { return nil }
        
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
    }
}

public extension UIColor {
    
    typealias HSBAValues = (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat)
    
    func hsbaValues() -> HSBAValues {
        var h: CGFloat = 0,
            s: CGFloat = 0,
            b: CGFloat = 0,
            a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h, s, b, a)
    }
    
    func modifyBrightnessByPercentage(_ percentage: CGFloat) -> UIColor {
        var (h, s, b, a) = hsbaValues()
        b *= percentage
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    func modifySaturationByPercentage(_ percentage: CGFloat) -> UIColor {
        var (h, s, b, a) = hsbaValues()
        s *= percentage
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    func darken(_ percentage: CGFloat = 0.125) -> UIColor {
        modifyBrightnessByPercentage(1 - percentage)
    }
    
    func lighten(_ percentage: CGFloat = 0.125) -> UIColor {
        modifyBrightnessByPercentage(1 + percentage)
    }
    
    func increaseSaturation(by percentage: CGFloat = 0.125) -> UIColor {
        modifySaturationByPercentage(1 + percentage)
    }
    
    // Check if the color is light or dark, as defined by the injected lightness threshold.
    // Some people report that 0.7 is best. I suggest to find out for yourself.
    // A nil value is returned if the lightness couldn't be determined.
    func isLight(threshold: Float = 0.7) -> Bool? {
        let originalCGColor = self.cgColor
        
        // Now we need to convert it to the RGB colorspace. UIColor.white / UIColor.black are greyscale and not RGB.
        // If you don't do this then you will crash when accessing components index 2 below when evaluating greyscale colors.
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return nil
        }
        guard components.count >= 3 else {
            return nil
        }
        
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
    }
}

public struct ColorConstant {
    public static var primary: UIColor = .hex(0x2388E6)
    public static var primary5: UIColor = .hex(0xE9F3FC)
    public static var lineView: UIColor = .hex(0xD3E7FA)
    public static var text: UIColor = .hex(0x2A323C)
    public static var text50: UIColor = .hex(0xA2A7AD)
    public static var grayText: UIColor = .hex(0xA2A7AD)
    public static var ink05: UIColor = .hex(0xF0F2F5)
    public static var BGNhat: UIColor = .hex(0xF7F8F8)
    
    public static var green: UIColor = .hex(0x0FD186 )
    public static var green5: UIColor = .hex(0xE7FAF3 )
    
    public static var yellow: UIColor = .hex(0xFFCB44)
    public static var yellow5: UIColor = .hex(0xFFFAEC )
    
    public static var red: UIColor = .hex(0xE54545)
    public static var red5: UIColor = .hex(0xFCECEC)
}


public extension UIColor {
    static var text = ColorConstant.text
    static var primary: UIColor = ColorConstant.primary
    static var primary5: UIColor = ColorConstant.primary5
    static var lineView: UIColor = ColorConstant.lineView
    static var text50: UIColor = ColorConstant.text50
    static var grayText: UIColor = ColorConstant.grayText
    static var ink05: UIColor = ColorConstant.ink05
    static var BGNhat: UIColor = ColorConstant.BGNhat
    static var green90: UIColor = ColorConstant.green
    static var green5: UIColor = ColorConstant.green5
    static var yellow90: UIColor = ColorConstant.yellow
    static var yellow5: UIColor = ColorConstant.yellow5
    static var red90: UIColor = ColorConstant.red
    static var red5: UIColor = ColorConstant.red5
}

