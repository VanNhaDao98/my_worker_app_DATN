//
//  Loading.swift
//  Utils
//
//  Created by Dao Van Nha on 13/10/2023.
//

import Foundation
import JGProgressHUD

open class Loading {
    
    public static let shared = Loading()
    private let hud = JGProgressHUD()
    
    public func showLoading(view: UIView, text: String = "Loading") {
        hud.textLabel.text = text
        hud.show(in: view)
    }
    
    public func hideLoading(afterDelay: Double = 0.5) {
        hud.dismiss(afterDelay: afterDelay)
    }
}
