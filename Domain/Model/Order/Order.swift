//
//  Order.swift
//  Domain
//
//  Created by Dao Van Nha on 07/11/2023.
//

import Foundation
import UIKit

public enum OrderStatus: String, CaseIterable {
    case await
    case confirm
    case progress
    case pending
    case cancel
    case complete
    
    public init?(rawValue: String) {
        switch rawValue {
        case "await":
            self = .await
        case "confirm":
            self = .confirm
        case "progress":
            self = .progress
        case "pending":
            self = .pending
        case "complete":
            self = .complete
        default: self = .cancel
        }
    }
    
    public var title: String {
        switch self {
        case .await:
            return "Đang chờ chấp nhận"
        case .progress:
            return "Đang tiến hành"
        case .pending:
            return "Tạm dừng"
        case .cancel:
            return "Hủy bỏ"
        case .complete:
            return "Hoàn thành"
        case .confirm:
            return "Xác nhận"
        }
    }
}

public enum OrderPaymentStatus: String {
    case paid
    case unpaid
    
    public init?(rawValue: String) {
        switch rawValue {
        case "paid":
            self = .paid
        default: self = .unpaid
        }
    }
    
    public var title: String {
        switch self {
        case .paid:
            return "Đã thanh toán"
        case .unpaid:
            return "Chưa thanh toán"
        }
    }
}

public struct Order: DomainModel {
    public private(set) var id: String = ""
    public private(set) var job: Job?
    public private(set) var province: Province?
    public private(set) var district: District?
    public private(set) var ward: Ward?
    public private(set) var address: String = ""
    public private(set) var worker: Worker?
    public private(set) var estimateTime: Date?
    public private(set) var customer: Customer?
    public private(set) var describe: String?
    public private(set) var imageDes: UIImage?
    public private(set) var status: OrderStatus = .await
    public private(set) var paymentStatus: OrderPaymentStatus = .unpaid
    public private(set) var createOn: Date?
    public private(set) var lineItems: [LineItem] = []
    public private(set) var oldLineItems: [LineItem] = []
    public private(set) var cancelOn: Date?
    public private(set) var endTime: Date?
    public private(set) var price: Double = 0
    public private(set) var paymentTime: Date?
    
    public init() {}
    
    public init(id: String,
                job: Job?,
                province: Province?,
                district: District?,
                ward: Ward?,
                address: String,
                worker: Worker?,
                estimateTime: Date?,
                customer: Customer,
                describe: String?,
                imageDes: UIImage?,
                status: OrderStatus,
                paymentStatus: OrderPaymentStatus,
                createOn: Date?,
                lineItems: [LineItem],
                cancelOn: Date?,
                endTime: Date?,
                price: Double,
                paymentTime: Date?) {
        self.id = id
        self.job = job
        self.province = province
        self.district = district
        self.ward = ward
        self.address = address
        self.worker = worker
        self.estimateTime = estimateTime
        self.customer = customer
        self.describe = describe
        self.imageDes = imageDes
        self.status = status
        self.paymentStatus = paymentStatus
        self.createOn = createOn
        self.lineItems = lineItems
        self.oldLineItems = lineItems
        self.cancelOn = cancelOn
        self.endTime = endTime
        self.price = price
        self.paymentTime = paymentTime
    }
}

extension Order {
    
    mutating public func resetLineItem() {
        self.lineItems = oldLineItems
    }
    
    mutating public func setJob(job: Job) {
        self.job = job
    }
    
    mutating public func setProvince(province: Province?) {
        self.province = province
    }
    
    mutating public func setDistrict(district: District?) {
        self.district = district
    }
    
    mutating public func set(ward: Ward?) {
        self.ward = ward
    }
    
    mutating public func setAddress(address: String) {
        self.address = address
    }
    
    mutating public func setEstimateTime(time: Date?) {
        self.estimateTime = time
    }
    
    mutating public func setWorker(worker: Worker) {
        self.worker = worker
    }
    
    mutating public func setImage(image: UIImage?) {
        self.imageDes = image
    }
    
    mutating public func setDes(des: String) {
        self.describe = des
    }
    
    mutating public func setCustomer(customer: Customer) {
        self.customer = customer
        self.province = customer.province
        self.district = customer.district
        self.ward = customer.ward
        self.address = customer.address ?? ""
    }
    
    mutating public func setLineItems(lineItems: [LineItem]) {
        self.lineItems = lineItems
    }
    
    mutating public func updateQuantity(index: Int, quantity: Double) {
        if quantity == 0 {
            lineItems.remove(at: index)
        } else {
            var lineItem = lineItems[index]
            lineItem.setQuantity(quantity: quantity)
            lineItems[index] = lineItem
        }
    }
    
}
