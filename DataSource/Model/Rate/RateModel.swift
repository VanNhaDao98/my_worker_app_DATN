//
//  RateModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 12/11/2023.
//

import Foundation
import Domain

struct RateModel: Codable {
    var id: String?
    var workerId: String?
    var customerId: String?
    var customerName: String?
    var rate: Double?
    var comment: String?
    var createOn: TimeInterval?
    
    enum CodingKeys: String, CodingKey {
        case id
        case workerId = "worker_id"
        case customerId = "customer_id"
        case customerName = "customer_name"
        case rate
        case comment
        case createOn = "create_on"
    }
}

extension RateModel: DomainMapper {
    
    typealias E = Rate
    
    func toDomain() -> Rate {
        .init(id: id ?? "",
              workerId: workerId ?? "",
              rate: rate ?? 0,
              customerId: customerId ?? "",
              customername: customerName ?? "",
              createOn: createOn == nil ? nil : Date(timeIntervalSince1970: createOn!),
              comment: comment ?? "")
    }
    
    static func from(model: Rate) -> RateModel {
        .init(id: model.id.isEmpty ? UUID().uuidString : model.id,
              workerId: model.workerId,
              customerId: model.customerId,
              customerName: model.customername,
              rate: model.rate,
              comment: model.comment,
              createOn: model.createOn == nil ? Date().timeIntervalSince1970 : model.createOn?.timeIntervalSince1970)
    }
}
