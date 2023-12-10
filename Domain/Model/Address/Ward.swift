//
//  Ward.swift
//  Domain
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation

public struct Ward: DomainModel {
    public private(set) var id: Int = 0
    public private(set) var name: String = ""
    public private(set) var code: String = ""
    public private(set) var provinceID: Int = 0
    public private(set) var districtID: Int = 0
    public private(set) var districtCode: String = ""
    
    public init() {}
    public init(id: Int,
                name: String,
                code: String,
                provinceID: Int,
                districtID: Int,
                districtCode: String) {
        self.id = id
        self.name = name
        self.code = code
        self.provinceID = provinceID
        self.districtID = districtID
        self.districtCode = districtCode
    }
}
