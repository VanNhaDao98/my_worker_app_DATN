//
//  CardModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 26/11/2023.
//

import Foundation
import Domain

struct CardModel: Codable {
    var isActive: Bool?
    var value: Double?
    var code: String?
    
    enum CodingKeys: String, CodingKey {
        case isActive = "is_active"
        case value
        case code
    }
}

extension CardModel: DomainMapper {
    typealias E = Card
    
    static func from(model: Card) -> CardModel {
        .init(isActive: model.isActive,
              value: model.value,
              code: model.code)
    }
    
    func toDomain() -> Card {
        .init(isActive: isActive ?? false,
              value: value ?? 0,
              code: code ?? "")
    }
}
