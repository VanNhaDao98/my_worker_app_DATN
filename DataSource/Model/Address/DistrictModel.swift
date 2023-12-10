//
//  DistrictModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation
import Domain

struct DistrictModel: Codable {
    var id: Int?
    var name: String?
    var code: String?
    var provinceID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case code
        case provinceID = "province_id"
    }
}

extension DistrictModel: DomainMapper {
    typealias E = District
    
    static func from(model: District) -> DistrictModel {
        .init(id: model.id,
              name: model.name,
              code: model.code,
              provinceID: model.provinceID)
    }
    
    func toDomain() -> District {
        .init(id: id ?? 0,
              name: name ?? "",
              code: code ?? "",
              provinceID: provinceID ?? 0)
    }
}
