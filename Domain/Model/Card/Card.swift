//
//  Card.swift
//  Domain
//
//  Created by Dao Van Nha on 26/11/2023.
//

import Foundation

public struct Card: DomainModel {
    public private(set) var isActive: Bool
    public private(set) var value: Double
    public private(set) var code: String
    
    
    public init(isActive: Bool,
                value: Double,
                code: String) {
        self.isActive = isActive
        self.value = value
        self.code = code
    }
}
