//
//  OrderUseCase.swift
//  Domain
//
//  Created by Dao Van Nha on 10/11/2023.
//

import Foundation
import Resolver
import PromiseKit

public protocol IOrderUseCase {
    
    func getListOrder(id: String) -> Promise<[Order]>
    
    func getDetailOrder(orderId: String) -> Promise<Order?>
    
    func updateOrderStatus(orderId: String, status: OrderStatus) -> Promise<Void>
    
    func updateLineItems(orderId: String, lineItems: [LineItem]) -> Promise<Void>
    
}

public struct OrderUseCase: IOrderUseCase {
    
    @Injected
    private var repo: OrderRepo
    
    public init() {
    }
    
    public func getListOrder(id: String) -> Promise<[Order]> {
        repo.getListOrder(id: id)
    }
    
    public func getDetailOrder(orderId: String) -> Promise<Order?> {
        repo.getDetailOrder(orderId: orderId)
    }
    
    
    public func updateOrderStatus(orderId: String, status: OrderStatus) -> Promise<Void> {
        repo.updateOrderStatus(orderId: orderId, status: status)
    }
    
    public func updateLineItems(orderId: String, lineItems: [LineItem]) -> Promise<Void> {
        repo.updateLineItems(orderId: orderId, lineItems: lineItems)
    }
    
}
