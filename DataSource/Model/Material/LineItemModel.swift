//
//  LineItemModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 17/11/2023.
//

import Foundation
import Domain

struct LineItemModel: Codable {
    var id: String?
    var imageUrl: String?
    var unit: String?
    var name: String?
    var price: Double?
    var quantity: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageUrl = "image_url"
        case unit
        case name
        case price
        case quantity
    }
}

extension LineItemModel: DomainMapper {
    typealias E = LineItem
    
    func toDomain() -> LineItem {
        .init(id: id ?? "",
              imageUrl: imageUrl == nil ? nil : URL(string: imageUrl!),
              unit: unit ?? "",
              name: name ?? "",
              price: price ?? 0,
              quantity: quantity ?? 0)
    }
    
    static func from(model: LineItem) -> LineItemModel {
        .init(id: model.id,
              imageUrl: model.imageUrl?.absoluteString,
              unit: model.unit,
              name: model.name,
              price: model.price,
              quantity: model.quantity)
    }
}
