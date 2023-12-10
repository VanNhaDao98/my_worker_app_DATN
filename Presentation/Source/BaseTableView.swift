//
//  BaseTableView.swift
//  Presentation
//
//  Created by Dao Van Nha on 09/10/2023.
//

import Foundation
import UIKit
import Utils

open class BaseTableView: UITableView {
    
    public var improveTouchesBehavior: Bool = true {
        didSet {
            delaysContentTouches = !improveTouchesBehavior
        }
    }
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        defauleSetup()
        config()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        defauleSetup()
        config()
    }
    
    
    private func config() {
        self.improveTouchesBehavior = true
    }
   
    
    open override func touchesShouldCancel(in view: UIView) -> Bool {
        if improveTouchesBehavior, view is UIControl {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
            
    }
}
