//
//  District.swift
//  Domain
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation

public struct District: DomainModel {
    public private(set) var id: Int = 0
    public private(set) var name: String = ""
    public private(set) var code: String = ""
    public private(set) var provinceID: Int = 0
    
    public init() {}
    
    public init(id: Int,
                name: String,
                code: String,
                provinceID: Int) {
        self.id = id
        self.name = name
        self.code = code
        self.provinceID = provinceID
    }
}
