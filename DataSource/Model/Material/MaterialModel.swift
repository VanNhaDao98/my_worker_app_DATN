//
//  MaterialModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 13/11/2023.
//

import Foundation
import Domain

struct MaterialModel: Codable {
    var id: String?
    var imageUrl: String?
    var unit: String?
    var name: String?
    var price: Double?
    
}

extension MaterialModel: DomainMapper {
    typealias E = Material
    
    static func from(model: Material) -> MaterialModel {
        .init(id: model.id.isEmpty ? UUID().uuidString : model.id,
              imageUrl: model.imageUrl?.absoluteString,
              unit: model.unit,
              name: model.name,
              price: model.price)
    }
    
    func toDomain() -> Material {
        .init(id: id ?? "",
              imageUrl: imageUrl == nil ? nil : URL(string: imageUrl!),
              unit: unit ?? "",
              name: name ?? "",
              price: price ?? 0)
    }
}
