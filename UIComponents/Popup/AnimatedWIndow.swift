//
//  AnimatedWIndow.swift
//  UIComponents
//
//  Created by Dao Van Nha on 01/10/2024.
//

import Foundation
import UIKit

open class AnimatedWIndow: BaseWindow {
    
    public var previousWindow: UIWindow?
    
    public static var currentWindow: AnimatedWIndow?
    
    public func fadeIn(comptele: @escaping () -> Void) {
        fatalError("fadeIn ovride")
    }
    
    public func fadeOut(comptele: @escaping () -> Void) {
        fatalError("fadeOut ovride")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(comptele: @escaping () -> Void) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                self.previousWindow = keyWindow
            }
        }
        AnimatedWIndow.currentWindow = self
        
        makeKeyAndVisible()
        
        fadeIn {
            comptele()
        }
        
    }
    
    public func hide(comptele: @escaping () -> Void) {
        fadeOut {
            
            self.removeFromSuperview()
            self.layoutIfNeeded()
            
            self.previousWindow?.makeKeyAndVisible()
            
            AnimatedWIndow.currentWindow = nil
        }
        
        
    }
}
