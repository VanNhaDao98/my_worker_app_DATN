//
//  UITextField+Exts.swift
//  Utils
//
//  Created by Dao Van Nha on 10/10/2023.
//

import Foundation
import UIKit

public extension UITextField {
    
    func moveToStart() {
        let pos = beginningOfDocument
        selectedTextRange = textRange(from: pos, to: pos)
    }
    
    func moveToEnd() {
        let pos = endOfDocument
        selectedTextRange = textRange(from: pos, to: pos)
    }

}
