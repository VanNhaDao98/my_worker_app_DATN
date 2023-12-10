//
//  BaseCollectionView.swift
//  Presentation
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import UIKit

open class BaseCollectionView: UICollectionView {
    
    /// When enabled, touches in button inside header/footer view
    /// will not be delayed and also can be cancelled when scrolled
    @IBInspectable public var improveTouchBehavior: Bool = true {
        didSet {
            delaysContentTouches = !improveTouchBehavior
        }
    }
    
    public init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        improveTouchBehavior = true
    }
    
    open override func touchesShouldCancel(in view: UIView) -> Bool {
        if improveTouchBehavior, view is UIControl {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }
}

