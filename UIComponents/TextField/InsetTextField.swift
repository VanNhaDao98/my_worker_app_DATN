//
//  InsetTextField.swift
//  Presentation
//
//  Created by Dao Van Nha on 10/10/2023.
//

import UIKit

open class InsetTextField: UITextField {

    var insets: UIEdgeInsets = .zero
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }

}
