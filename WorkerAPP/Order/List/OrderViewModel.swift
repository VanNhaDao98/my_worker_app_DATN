//
//  OrderViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 10/11/2023.
//

import Foundation
import Domain
import Presentation
import Resolver
import Utils
import UIKit
import UIComponents

extension OrderStatus {
    
    var color: UIColor {
        switch self {
        case .await:
            return .primary
        case .progress:
            return .green90
        case .pending:
            return .yellow90
        case .cancel:
            return .red90
        case .complete:
            return .grayText
        case .confirm:
            return .primary
        }
    }
    
    var bg: UIColor {
        
        switch self {
        case .await:
            return .primary5
        case .progress:
            return .green5
        case .pending:
            return .yellow5
        case .cancel:
            return .red5
        case .complete:
            return .BGNhat
        case .confirm:
            return .primary5
        }
    }
}

extension OrderPaymentStatus {
    var color: UIColor {
        switch self {
        case .paid:
            return .text
        case .unpaid:
            return .yellow90
        }
    }
    
    var bg: UIColor {
        switch self {
        case .paid:
            return .BGNhat
        case .unpaid:
            return .yellow5
        }
    }
}

class OrderViewModel: BaseViewModel<OrderViewModel.Input, OrderViewModel.Output> {
    
    enum Input {
        case viewDidLoad
        case sendData([Order])
        case selectItem(Int)
        case filter
        case updateFilterValue(_ values: [OrderStatus])
    }
    
    struct Output: VMOutPut {
        var loading: () -> Void
        var items: ([Order]) -> Void
        var detailItems: (Order) -> Void
        var filter: ([SelectionItem<OrderStatus>]) -> Void
        var headerTitle: (String) -> Void
    }
    
    @Injected
    private var useCase: IOrderUseCase
    
    public var orderValue: [Order] {
        return self.filterOrder
    }
    
    private var orders: [Order] = []
    
    private var filterOrder: [Order] = []
    
    private var isFilter: Bool = false {
        didSet {
            output.headerTitle(isFilter ? "Bộ lọc" : "Tất cả đơn hàng")
        }
    }
    
    private var filterValue: [OrderStatus] = []
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            getData()
            output.headerTitle(isFilter ? "Bộ lọc" : "Tất cả đơn hàng")
        case .sendData(let order):
            self.orders = order
            self.orders.sort {
                $0.createOn?.timeIntervalSince1970 ?? 1 > $1.createOn?.timeIntervalSince1970 ?? 1
            }
            if self.filterValue.isEmpty {
                self.filterOrder = self.orders
                self.isFilter = false
            } else {
                self.isFilter = true
                self.filterOrder = self.orders.filter({ order in
                    self.filterValue.contains(order.status)
                })
            }

            self.output.items(self.filterOrder)
        case .selectItem(let index):
            let order = orders[index]
            self.output.detailItems(order)
        case .filter:
            output.filter(OrderStatus.allCases.map({ .init(title: $0.title,
                                                           isSelected: self.filterValue.contains($0),
                                                           rawData: $0)}))
        case .updateFilterValue(let values):
            self.filterValue = values
            if self.filterValue.isEmpty {
                self.filterOrder = self.orders
                self.isFilter = false
            } else {
                self.isFilter = true
                self.filterOrder = self.orders.filter({ order in
                    self.filterValue.contains(order.status)
                })
            }
            self.output.items(self.filterOrder)
        }
    }
    
    private func getData() {
        output.loading()
        useCase.getListOrder(id: AccountUtils.shard.getAccount()?.uid ?? "").done { orders in
            self.orders = orders
            self.orders.sort {
                $0.createOn?.timeIntervalSince1970 ?? 1 > $1.createOn?.timeIntervalSince1970 ?? 1
            }
            self.filterOrder = self.orders
        }.catch { _ in
            
        }.finally {
            self.output.hideLoading()
            self.output.items(self.filterOrder)
        }
    }
}

