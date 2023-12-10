//
//  UIFont+Exts.swift
//  Utils
//
//  Created by Dao Van Nha on 10/10/2023.
//

import Foundation
import UIKit

public enum Fonts {}

public extension Fonts {
    static func defaultFont(ofSize size: FontSize) -> UIFont {
        .systemFont(ofSize: size.value)
    }
    
    static func mediumFont(ofSize size: FontSize) -> UIFont {
        .systemFont(ofSize: size.value, weight: .medium)
    }
    
    static func italicFont(ofSize size: FontSize) -> UIFont {
        .italicSystemFont(ofSize: size.value)
    }
    
    static func semiboldFont(ofSize size: FontSize) -> UIFont {
        .systemFont(ofSize: size.value, weight: .semibold)
    }
    
    static func boldFont(ofSize size: FontSize) -> UIFont {
        .boldSystemFont(ofSize: size.value)
    }
}

extension UIFont {
    static func helveticaNeueLight(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(custom: .helveticaNeueLight, size: fontSize)
    }
    
    static func helveticaNeue(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(custom: .helveticaNeue, size: fontSize)
    }
    
    static func helveticaNeueMedium(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(custom: .helveticaNeueMedium, size: fontSize)
    }
    
    static func helveticaNeueBold(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(custom: .helveticaNeueBold, size: fontSize)
    }
    
    static func helveticaNeueBoldItalic(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(custom: .helveticaNeueBoldItalic, size: fontSize)
    }
    
    static func helveticaNeueItalic(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(custom: .helveticaNeueItalic, size: fontSize)
    }
    
    convenience init(custom: CustomFontName, size: CGFloat) {
        self.init(name: custom.rawValue, size: size)!
    }
}

enum CustomFontName: String {
    case helveticaNeue = "HelveticaNeue"
    case helveticaNeueMedium = "HelveticaNeue-Medium"
    case helveticaNeueBold = "HelveticaNeue-Bold"
    case helveticaNeueBoldItalic = "HelveticaNeue-BoldItalic"
    case helveticaNeueLight = "HelveticaNeue-Light"
    case helveticaNeueUltraLight = "HelveticaNeue-UltraLight"
    case helveticaNeueItalic = "HelveticaNeue-Italic"
}

public struct FontSize {
    let value: CGFloat
}

public extension FontSize {
    /// 16
    static let `default`: FontSize = .init(value: 16)
    
    /// 14
    static let subtitle: FontSize = .init(value: 14)
    
    /// 11
    static let tiny: FontSize = .init(value: 11)
    
    /// 13
    static let small: FontSize = .init(value: 13)
    
    /// 17
    static let medium: FontSize = .init(value: 17)
    
    /// 18
    static let title: FontSize = .init(value: 18)
    
    /// 20
    static let popupTitle: FontSize = .init(value: 20)
    
    /// 17
    static let alertButton: FontSize = .init(value: 17)
    
    /// 18
    static let actionButton: FontSize = .init(value: 18)
    
    static let textFieldFloatingLabel: FontSize = .init(value: 15)
    
    static let headerTitle: FontSize = .init(value: 19)
    
    static func custom(_ value: CGFloat) -> FontSize {
        .init(value: value)
    }
}
