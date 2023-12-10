//
//  OrderModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 09/11/2023.
//

import Foundation
import Domain
import UIKit

struct OrderModel: Codable {
    var id: String?
    var customerId: String?
    var workerId: String?
    var job: JobModel?
    var address: String?
    var province: ProvinceModel?
    var district: DistrictModel?
    var ward: WardModel?
    var worker: WorkerModel?
    var estimateTime: TimeInterval?
    var customer: CustomerModel?
    var describe: String?
    var status: String?
    var paymentStatus: String?
    var createOn: TimeInterval?
    var lineItem: [LineItemModel]?
    var cancelOn: TimeInterval?
    var endTime: TimeInterval?
    var price: Double?
    var paymentTime: TimeInterval?
    
    enum CodingKeys: String, CodingKey {
        case id
        case job
        case address
        case province
        case district
        case ward
        case worker
        case estimateTime = "estimate_time"
        case customer
        case describe
        case status
        case paymentStatus = "payment_status"
        case customerId = "customer_id"
        case workerId = "worker_id"
        case createOn = "create_on"
        case lineItem = "line_item"
        case cancelOn = "cancel_on"
        case endTime = "end_time"
        case price
        case paymentTime = "payment_time"
    }
}

extension OrderModel: DomainMapper {
    typealias E = Order
    
    func toDomain() -> Order {
        
        let l = lineItem?.map({ model in
            model.toDomain()
        }) ?? []
        
        return .init(id: id ?? "",
                     job: job?.toDomain(),
                     province: province?.toDomain(),
                     district: district?.toDomain(),
                     ward: ward?.toDomain(),
                     address: address ?? "",
                     worker: worker?.toDomain(),
                     estimateTime: estimateTime == nil ? nil : Date(timeIntervalSince1970: estimateTime!),
                     customer: customer?.toDomain() ?? Customer(),
                     describe: describe,
                     imageDes: nil,
                     status: .init(rawValue: status ?? "") ?? .await,
                     paymentStatus: .init(rawValue: paymentStatus ?? "") ?? .unpaid,
                     createOn: createOn == nil ? nil : Date(timeIntervalSince1970: createOn!),
                     lineItems: l,
                     cancelOn: cancelOn == nil ? nil : Date(timeIntervalSince1970: cancelOn!),
                     endTime: endTime == nil ? nil : Date(timeIntervalSince1970: endTime!),
                     price: price ?? 0,
                     paymentTime: paymentTime == nil ? nil : Date(timeIntervalSince1970: paymentTime!))
    }
    
    static func from(model: Order) -> OrderModel {
        .init(id: UUID().uuidString,
              customerId: model.customer?.id,
              workerId: model.worker?.id,
              job: JobModel.from(model: model.job),
              address: model.address,
              province: ProvinceModel.from(model: model.province),
              district: DistrictModel.from(model: model.district),
              ward: WardModel.from(model: model.ward),
              worker: WorkerModel.from(model: model.worker),
              estimateTime: model.estimateTime?.timeIntervalSince1970,
              customer: CustomerModel.from(model: model.customer),
              describe: model.describe,
              status: model.status.rawValue,
              paymentStatus: model.paymentStatus.rawValue,
              createOn: Date().timeIntervalSince1970,
              lineItem: model.lineItems.map({ LineItemModel.from(model: $0) }),
              price: model.price,
              paymentTime: model.paymentTime?.timeIntervalSince1970)
    }
}
