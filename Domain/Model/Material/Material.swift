//
//  Material.swift
//  Domain
//
//  Created by Dao Van Nha on 12/11/2023.
//

import Foundation
import UIKit

public struct Material: DomainModel {
    public private(set) var id: String = ""
    public private(set) var image: UIImage?
    public private(set) var imageUrl: URL?
    public private(set) var unit: String = ""
    public private(set) var name: String = ""
    public private(set) var price: Double = 0
    
    public init() {}
    
    public init(id: String,
                imageUrl: URL?,
                unit: String,
                name: String,
                price: Double) {
        self.id = id
        self.imageUrl = imageUrl
        self.unit = unit
        self.name = name
        self.price = price
    }
}

extension Material {
    
    public mutating func updatePrice(price: Double) {
        self.price = price
    }
    
    public mutating func updateName(name: String) {
        self.name = name
    }
    
    public mutating func updateUnit(unit: String) {
        self.unit = unit
    }
    
    public mutating func updateURL(url: URL?) {
        self.imageUrl = url
    }
    
    public mutating func updateImage(image: UIImage?) {
        self.image = image
    }
}


