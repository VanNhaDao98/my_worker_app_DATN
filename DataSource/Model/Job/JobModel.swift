//
//  JobModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 04/11/2023.
//

import Foundation
import Domain

struct JobModel: Codable {
    var id: Int?
    var code: String?
    var name: String?
}

extension JobModel: DomainMapper {
    typealias E = Job
    
    static func from(model: Job) -> JobModel {
        .init(id: model.id,
              code: model.code,
              name: model.name)
    }
    
    func toDomain() -> Job {
        .init(id: id ?? 0,
              code: code ?? "",
              name: name ?? "",
              type: .init(rawValue: code ?? "") ?? .orther)
    }
    
}
