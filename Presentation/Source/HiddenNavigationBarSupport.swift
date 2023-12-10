//
//  HiddenNavigationBarSupport.swift
//  Presentation
//
//  Created by Dao Van Nha on 11/10/2023.
//

import Foundation
import UIKit

public protocol HiddenNavigationBarSupport {
    var shouldNavigationHiddenBar: Bool { get }
    func invalidateNavigationBarHiddenState(animated: Bool)
}

public extension HiddenNavigationBarSupport where Self: UIViewController {
    var shouldNavigationHiddenBar: Bool {
        return true
    }
    
    func invalidateNavigationBarHiddenState(animated: Bool) {
        guard let nav = navigationController, parent?.navigationController !== nav else {
            return
        }
        
        if nav.isNavigationBarHidden == shouldNavigationHiddenBar {
            return
        }
        
        nav.setNavigationBarHidden(shouldNavigationHiddenBar, animated: animated)
    }
}
