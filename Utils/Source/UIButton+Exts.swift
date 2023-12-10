//
//  UIButton+Exts.swift
//  Utils
//
//  Created by Dao Van Nha on 09/10/2023.
//

import Foundation
import UIKit

public extension UIButton {
    func setBacgroundColor(_ color: UIColor?, _ state: UIControl.State) {
        
        if let color = color {
            setBackgroundImage(UIImage.from(color: color), for: state)
        } else {
            setBackgroundImage(nil, for: state)
        }
    }
    
    func setTitle(title: String?, animated: Bool = true) {
        if animated {
            setTitle(title, for: .normal)
        } else {
            UIView.performWithoutAnimation {
                self.setTitle(title, for: .normal)
                self.layoutIfNeeded()
            }
        }
    }
    
    func setAttributedTitle(title: NSAttributedString?, animated: Bool = true) {
        if animated {
            setAttributedTitle(title, for: .normal)
        } else {
            UIView.performWithoutAnimation {
                self.setAttributedTitle(title, for: .normal)
                self.layoutIfNeeded()
            }
        }
    }
}
