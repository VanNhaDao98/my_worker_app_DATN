//
//  OrderRemoteDataSourceImpl.swift
//  DataSource
//
//  Created by Dao Van Nha on 10/11/2023.
//

import Foundation
import Domain
import PromiseKit

public class OrderRemoteDataSourceImpl: BaseRepo, OrderRepo {
    
    private var dataSource = DataBaseRemoteDataSource()
    
    public func getListOrder(id: String) -> Promise<[Order]> {
        dataSource.getListOrder(id: id).map { models in
            models.map({ $0.toDomain()})
        }
    }
    
    public func getDetailOrder(orderId: String) -> Promise<Order?> {
        dataSource.getOrderDetail(orderId: orderId).map {
            $0?.toDomain()
        }
    }
    
    public func updateOrderStatus(orderId: String, status: OrderStatus) -> Promise<Void> {
        dataSource.updateStatusOrder(status: status.rawValue, orderId: orderId)
    }
    
    public func updateLineItems(orderId: String, lineItems: [LineItem]) -> Promise<Void> {
        dataSource.updateMaterialOrder(orderId: orderId, lineItems: lineItems.map({ LineItemModel.from(model: $0)}))
    }
}
