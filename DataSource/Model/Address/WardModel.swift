//
//  WardModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation
import Domain

struct WardModel: Codable {
    var id: Int?
    var name: String?
    var code: String?
    var provinceID: Int?
    var districtID: Int?
    var districtCode: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case code
        case provinceID = "province_id"
        case districtID = "district_id"
        case districtCode = "district_code"
    }
}

extension WardModel: DomainMapper {
    typealias E = Ward
    
    static func from(model: Ward) -> WardModel {
        .init(id: model.id,
              name: model.name,
              code: model.code,
              provinceID: model.provinceID,
              districtID: model.districtID,
              districtCode: model.districtCode)
    }
    
    func toDomain() -> Ward {
        .init(id: id ?? 0,
              name: name ?? "",
              code: code ?? "",
              provinceID: provinceID ?? 0,
              districtID: districtID ?? 0,
              districtCode: districtCode ?? "")
    }
}
