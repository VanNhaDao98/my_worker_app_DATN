//
//  ProvinceModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation
import Domain

struct ProvinceModel: Codable {
    var id: Int?
    var name: String?
    var code: String?
    var countryId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case code
        case countryId = "country_id"
    }
}

extension ProvinceModel: DomainMapper {
    typealias E = Province
    
    static func from(model: Province) -> ProvinceModel {
        .init(id: model.id,
              name: model.name,
              code: model.code,
              countryId: 1)
    }
    
    func toDomain() -> Province {
        .init(id: id ?? 0,
              name: name ?? "",
              code: code ?? "",
              countryId: countryId ?? 1)
    }
}
