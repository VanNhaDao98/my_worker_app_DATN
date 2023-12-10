//
//  BaseWindow.swift
//  UIComponents
//
//  Created by Dao Van Nha on 13/10/2023.
//

import UIKit

open class BaseWindow: UIWindow {

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
