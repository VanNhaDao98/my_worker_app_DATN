//
//  PassthroughView.swift
//  Presentation
//
//  Created by Dao Van Nha on 10/10/2023.
//

import Foundation
import UIKit

protocol PassthroughViewSupport where Self: UIView {
    var nonPassthroughTextRange: UITextRange? { get set }
    func shouldPassthrough(_ point: CGPoint, with event: UIEvent?) -> Bool
}

open class PassthroughView: UIView {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)

        if view == self {
            return nil
        }

        return view
    }
}

open class PassthroughStackView: UIStackView {

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)

        if view == self {
            return nil
        }

        if let passthroughView = view as? PassthroughViewSupport,
            passthroughView.shouldPassthrough(point, with: event) {
            return nil
        }

        return view
    }
}
