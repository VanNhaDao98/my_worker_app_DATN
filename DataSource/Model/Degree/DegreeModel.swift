//
//  DegreeModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 03/11/2023.
//

import Foundation
import Domain

struct DegreeModel: Codable {
    var id: Int?
    var code: String?
    var name: String?
}

extension DegreeModel: DomainMapper {
    typealias E = Degree
    
    static func from(model: Degree) -> DegreeModel {
        .init(id: model.id,
              code: model.code,
              name: model.name)
    }
    
    func toDomain() -> Degree {
        .init(id: id ?? 0,
              code: code ?? "",
              name: name ?? "")
    }
}
