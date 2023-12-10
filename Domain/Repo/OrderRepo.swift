//
//  OrderRepo.swift
//  Domain
//
//  Created by Dao Van Nha on 10/11/2023.
//

import Foundation
import PromiseKit

public protocol OrderRepo {
    
    func getListOrder(id: String) -> Promise<[Order]>
    
    func getDetailOrder(orderId: String) -> Promise<Order?>
    
    func updateOrderStatus(orderId: String, status: OrderStatus) -> Promise<Void>
    
    func updateLineItems(orderId: String, lineItems: [LineItem]) -> Promise<Void>
}
