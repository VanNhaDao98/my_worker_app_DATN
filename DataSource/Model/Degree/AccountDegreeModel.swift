//
//  AccountDegreeModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 03/11/2023.
//

import Foundation
import Domain

struct AccountDegreeModel: Codable {
    var id: String?
    var university: String?
    var level: String?
    var startTime: TimeInterval?
    var endTime: TimeInterval?
    var degree: DegreeModel?
    var profile: String?
}

extension AccountDegreeModel: DomainMapper {
    typealias E = AccountDregee
    
    static func from(model: AccountDregee) -> AccountDegreeModel {
        .init(id: UUID().uuidString,
              university: model.university,
              level: model.level.rawValue,
              startTime: model.startTime?.timeIntervalSince1970,
              endTime: model.endTime?.timeIntervalSince1970,
              degree: DegreeModel.from(model: model.degree),
              profile: model.profile)
    }
    
    func toDomain() -> AccountDregee {
        .init(id: id ?? "",
              university: university ?? "",
              level: DegreeLevel(rawValue: level ?? "") ?? .medium,
              startTime: startTime == nil ? nil : Date(timeIntervalSince1970: startTime!),
              endTime: endTime == nil ? nil : Date(timeIntervalSince1970: endTime!),
              degree: degree?.toDomain() ?? Degree(),
              profile: profile ?? "")
    }
}
