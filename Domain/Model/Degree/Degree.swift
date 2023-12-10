//
//  Degree.swift
//  Domain
//
//  Created by Dao Van Nha on 03/11/2023.
//

import Foundation

public struct Degree: DomainModel {
    
    public private(set) var id: Int = 0
    public private(set) var code: String = ""
    public private(set) var name: String = ""
    
    public init() {}
    
    public init(id: Int,
                code: String,
                name: String) {
        self.id = id
        self.code = code
        self.name = name
    }
}
