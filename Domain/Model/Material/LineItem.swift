//
//  LineItem.swift
//  Domain
//
//  Created by Dao Van Nha on 17/11/2023.
//

import Foundation

public struct LineItem: DomainModel {
    public private(set) var id: String = ""
    public private(set) var imageUrl: URL?
    public private(set) var unit: String = ""
    public private(set) var name: String = ""
    public private(set) var price: Double = 0
    public private(set) var quantity: Double = 0
    
    public init() {}
    
    public init(id: String,
                imageUrl: URL?,
                unit: String,
                name: String,
                price: Double,
                quantity: Double) {
        self.id = id
        self.imageUrl = imageUrl
        self.unit = unit
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}

extension LineItem {
    public init(metarial: Material,
                quantity: Double) {
        self.init(id: metarial.id,
                  imageUrl: metarial.imageUrl,
                  unit: metarial.unit,
                  name: metarial.name,
                  price: metarial.price,
                  quantity: quantity)
    }
    
    public mutating func setQuantity(quantity: Double) {
        self.quantity = quantity
    }
}
