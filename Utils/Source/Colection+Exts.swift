//
//  Colection+Exts.swift
//  Utils
//
//  Created by Dao Van Nha on 16/10/2023.
//

import Foundation

public extension Collection {
    var notEmpty: Bool {
        !isEmpty
    }
    
    func notContains(_ element: Element) -> Bool where Element: Equatable {
        !contains(element)
    }
}
