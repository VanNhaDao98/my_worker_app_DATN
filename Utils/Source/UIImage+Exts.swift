//
//  UIImage+Exts.swift
//  Utils
//
//  Created by Dao Van Nha on 09/10/2023.
//

import Foundation
import UIKit

public extension UIImage {
    
    static func from(color: UIColor,
                     size: CGSize = CGSize(width: 1, height: 1),
                     cornerRadius: CGFloat = 0.0) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setFillColor(color.cgColor)
        
        if cornerRadius > 0 {
            UIBezierPath(roundedRect: rect,
                         cornerRadius: cornerRadius)
            .fill()
        } else {
            context.fill(rect)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    @inlinable
    func alwaysTemplate() -> UIImage {
        withRenderingMode(.alwaysTemplate)
    }
    
    @inlinable
    func alwaysOriginal() -> UIImage {
        withRenderingMode(.alwaysOriginal)
    }
}

public struct ImageConstant {
    public static var userCircle: UIImage? = .init(named: "user_circle")
    public static var chevronRight: UIImage? = .init(named: "chevron-right")
    public static var chevronLeft: UIImage? = .init(named: "chevron-left")
    public static var chevronDown: UIImage? = .init(named: "chevron-down")
    public static var eyeSlashAlt: UIImage? = .init(named: "eye-slash-alt")
    public static var icLock: UIImage? = .init(named: "ic-lock")
    public static var shieldCheck: UIImage? = .init(named: "shield-check")
    public static var icVN: UIImage? = .init(named: "ic-vn")
    public static var defaultHeader: UIImage? = .init(named: "default-header")
    public static var icClose: UIImage? = .init(named: "ic-close")
    public static var imageEmpty: UIImage? = .init(named: "image-empty")
    public static var calendar: UIImage? = .init(named: "calendar")
    public static var checkfillCirle: UIImage? = .init(named: "checkfill_cirle")
    
    public static var jobCar: UIImage? = .init(named: "job-car")
    public static var jobElectricHome: UIImage? = .init(named: "job-electric-home")
    public static var jobElectric: UIImage? = .init(named: "job-electric")
    public static var jobMotoBike: UIImage? = .init(named: "job-motobike")
    public static var jobPc: UIImage? = .init(named: "job-pc")
    public static var jobHome: UIImage? = .init(named: "job-phone")
    public static var jobWater: UIImage? = .init(named: "job-water")
    public static var searchIcon: UIImage? = .init(named: "search-lg")
    public static var check: UIImage? = .init(named: "check")
    public static var icCheckboxSelectedDisabled24pt: UIImage? = .init(named: "ic_checkbox_selected_disabled_24pt")
    public static var icCheckboxSelected24pt: UIImage? = .init(named: "ic_checkbox_selected_24pt")
    public static var icCheckboxPartial24pt: UIImage? = .init(named: "ic_checkbox_partial_24pt")
    public static var icCheckboxDeselected24pt: UIImage? = .init(named: "ic_checkbox_deselected_24pt")
    public static var xmark: UIImage? = .init(named: "xmark")
    public static var briefcase: UIImage? = .init(named: "briefcase")
    public static var briefcaseFill: UIImage? = .init(named: "briefcase_fill")
    public static var messageCircle: UIImage? = .init(named: "message-circle")
    public static var messageCirclefill: UIImage? = .init(named: "message-circlefill")
    public static var bellAltFill: UIImage? = .init(named: "bell-alt-1fill")
    public static var bellAlt: UIImage? = .init(named: "bell-alt-1")
    public static var userfill: UIImage? = .init(named: "userfill")
    public static var user: UIImage? = .init(named: "user")
    public static var bacckground1: UIImage? = .init(named: "background_1")
    public static var locationPin: UIImage? = .init(named: "location-pin")
    public static var bookOpen: UIImage? = .init(named: "book-open")
    
    public static var category: UIImage? = .init(named: "category")
    public static var lifeRing: UIImage? = .init(named: "life-ring")
    public static var coin: UIImage? = .init(named: "coin")
    public static var lock: UIImage? = .init(named: "lock")
    public static var materialEmpty: UIImage? = .init(named: "material-empty")
    public static var pen: UIImage? = .init(named: "pen")
    public static var plusBlue: UIImage? = .init(named: "plus-blue")
    public static var phone: UIImage? = .init(named: "phone-flip")
    public static var locationPinAlt: UIImage? = .init(named: "location-pin-alt")
    public static var electricCircle: UIImage? = .init(named: "electric-circle")
    
    public static var jobWaterDes: UIImage? = .init(named: "job-water-des")
    public static var jobElectrictDes: UIImage? = .init(named: "job-electrict-des")
    public static var jobPcDes: UIImage? = .init(named: "job-pc-des")
    public static var jobPhoneDes: UIImage? = .init(named: "job-phone-des")
    public static var jobMotobikeDes: UIImage? = .init(named: "job-motobike-des")
    public static var jobOtoDes: UIImage? = .init(named: "job-oto-des")
    public static var jobGearDes: UIImage? = .init(named: "job-gear-des")
    public static var jobRefrigerationDes: UIImage? = .init(named: "job-refrigeration-des")
    public static var jobGear: UIImage? = .init(named: "job-gear")
    public static var clipboardMinus: UIImage? = .init(named: "clipboard-minus")
    public static var clipboardMinusFill: UIImage? = .init(named: "clipboard-minus-fill")
    
    public static var startGray: UIImage? = .init(named: "start-gray")
    public static var srartSelect: UIImage? = .init(named: "srart-select")
    public static var icPlus24pt: UIImage? = .init(named: "ic-plus-24pt")
    public static var icMinus24pt: UIImage? = .init(named: "ic-minus_24pt")
    public static var imgEmptySearchResult: UIImage? = .init(named: "img_empty_search_result")
    
    public static var banner_ai: UIImage? = .init(named: "news-banner-ai")
    public static var banner_newYear: UIImage? = .init(named: "banner_newYear")
    public static var banner_humg: UIImage? = .init(named: "banner_humg")
    public static var banner_cntt: UIImage? = .init(named: "banner_cntt")
    
    public static var filter: UIImage? = .init(named: "filter")
    
}
