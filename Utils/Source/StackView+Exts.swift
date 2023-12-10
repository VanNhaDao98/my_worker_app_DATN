//
//  StackView+Exts.swift
//  Utils
//
//  Created by Dao Van Nha on 21/10/2023.
//

import Foundation
import UIKit

public extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
