//
//  Rate.swift
//  Domain
//
//  Created by Dao Van Nha on 12/11/2023.
//

import Foundation

public struct Rate: DomainModel {
    
    public private(set) var id: String = ""
    public private(set) var workerId: String = ""
    public private(set) var rate: Double = 0
    public private(set) var customerId: String = ""
    public private(set) var customername: String = ""
    public private(set) var createOn: Date?
    public private(set) var comment: String = ""
    
    public init() {}
    
    public init(id: String,
                workerId: String,
                rate: Double,
                customerId: String,
                customername: String,
                createOn: Date?,
                comment: String) {
        self.id = id
        self.rate = rate
        self.customerId = customerId
        self.customername = customername
        self.createOn = createOn
        self.comment = comment
        self.workerId = workerId
    }
}
