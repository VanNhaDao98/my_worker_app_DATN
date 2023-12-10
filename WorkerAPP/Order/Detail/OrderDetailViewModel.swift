//
//  OrderDetailViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 11/11/2023.
//

import Foundation
import Domain
import Presentation
import Resolver
import Utils
import UIKit

class OrderDetailViewModel: BaseViewModel<OrderDetailViewModel.Input, OrderDetailViewModel.Output> {
    
    enum Input {
        case viewDidLoad
        case sendOrder(Order)
        case cancel
        case comfirm
        case progress
        case pending
        case complete
        case call
        case messenger
        case selectLineItem
        case updateLineItem([LineItem])
        case updateQuantity(_ index: Int, _ quantity: Double)
        case addLineItem
    }
    
    struct Output: VMOutPut {
        var loading: () -> Void
        var generic: (Generic) -> Void
        var customer: (CustomerData) -> Void
        var button: (ButtonStatus) -> Void
        
        var reloadTableView: () -> Void
        
        var lineItems: ([LineItem]) -> Void
        
        var error: (String) -> Void
        var success: (String) -> Void
    }
    
    private var editMode: Bool = false {
        didSet {
            self.output.button(.init(status: self.order.status, isEditMode: self.editMode))
        }
    }
    
    @Injected
    private var useCase: IOrderUseCase
    
    private var order: Order
    
    public var lineItems: [LineItem] {
        return order.lineItems
    }
    
    public var totalPriceLineItem: String {
        
        let totalPrice: Double = self.order.lineItems.reduce(into: Double()) { partialResult, lineItem in
            partialResult += lineItem.price * lineItem.quantity
        }
        return order.lineItems.isEmpty ? "Vật liệu" : "Giá vật liệu: \(totalPrice.currencyFormat())"
    }
    
    init(order: Order) {
        self.order = order
    }
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            getData()
        case .sendOrder(let order):
            self.order = order
            self.reloadView()
        case .cancel:
            if editMode {
                editMode = false
                order.resetLineItem()
                output.reloadTableView()
            } else {
                self.updateStatus(status: .cancel)
            }
        case .comfirm:
            self.updateStatus(status: .confirm)
        case .progress:
            self.updateStatus(status: .progress)
        case .pending:
            self.updateStatus(status: .pending)
        case .complete:
            self.updateStatus(status: .complete)
        case .call:
            Utility.call(phoneNumber: order.customer?.phoneNumber)
        case .messenger:
            MessageUtils.shared.openMessageApp(phoneNumber: order.customer?.phoneNumber)
        case .selectLineItem:
            self.output.lineItems(order.lineItems)
        case .updateLineItem(let lineItems):
            editMode = true
            order.setLineItems(lineItems: lineItems)
            output.reloadTableView()
        case .updateQuantity(let index, let quantity):
            editMode = true
            self.order.updateQuantity(index: index, quantity: quantity)
            self.output.reloadTableView()
        case .addLineItem:
            output.loading()
            useCase.updateLineItems(orderId: order.id, lineItems: order.lineItems).done {
                self.editMode = false
                self.output.success("Cập nhật vật liệu thành công")
            }.catch { _ in
                self.output.error("Cập nhật vật liệu thất bại")
            }.finally {
                self.output.hideLoading()
            }
        }
    }
    
    private func updateStatus(status: OrderStatus) {
        output.loading()
        useCase.updateOrderStatus(orderId: order.id, status: status).done {
            print("okie")
        }.catch { error in
            print(error)
        }.finally {
            self.output.hideLoading()
            self.reloadView()
        }

    }
    private func reloadView() {
        self.output.generic(.init(order: self.order))
        self.output.customer(.init(order: self.order))
        self.output.button(.init(status: self.order.status, isEditMode: self.editMode))
    }
    
    private func getData() {
        useCase.getDetailOrder(orderId: order.id).done { order in
            if let order = order {
                self.order = order
            }
        }.catch { _ in
            
        }.finally {
            self.reloadView()
        }
    }

}

extension OrderDetailViewModel {
    
    struct ButtonStatus {
        var isHiddenCanncelButton: Bool
        var isHiddenConfirmButton: Bool
        var isHiddenProgressButton: Bool
        var isHiddenPendingButton: Bool
        var isHiddenCompleteButtom: Bool
        var isHiddenButtonView: Bool
        var cancelTitle: String
        var isHiddenEditButton: Bool
        
        init(status: OrderStatus, isEditMode: Bool) {
            
            if !isEditMode {
                self.isHiddenEditButton = true
                self.isHiddenButtonView = false
                self.cancelTitle = "Hủy đơn hàng"
                switch status {
                case .await:
                    self.isHiddenCanncelButton = false
                    self.isHiddenConfirmButton = false
                    self.isHiddenProgressButton = true
                    self.isHiddenPendingButton = true
                    self.isHiddenCompleteButtom = true
                case .confirm:
                    self.isHiddenCanncelButton = false
                    self.isHiddenConfirmButton = true
                    self.isHiddenProgressButton = false
                    self.isHiddenPendingButton = true
                    self.isHiddenCompleteButtom = true
                case .progress:
                    self.isHiddenCanncelButton = true
                    self.isHiddenConfirmButton = true
                    self.isHiddenProgressButton = true
                    self.isHiddenPendingButton = false
                    self.isHiddenCompleteButtom = false
                case .pending:
                    self.isHiddenCanncelButton = true
                    self.isHiddenConfirmButton = true
                    self.isHiddenProgressButton = false
                    self.isHiddenPendingButton = true
                    self.isHiddenCompleteButtom = true
                case .cancel:
                    self.isHiddenCanncelButton = true
                    self.isHiddenConfirmButton = true
                    self.isHiddenProgressButton = true
                    self.isHiddenPendingButton = true
                    self.isHiddenCompleteButtom = true
                    self.isHiddenButtonView = true
                case .complete:
                    self.isHiddenCanncelButton = true
                    self.isHiddenConfirmButton = true
                    self.isHiddenProgressButton = true
                    self.isHiddenPendingButton = true
                    self.isHiddenCompleteButtom = true
                    self.isHiddenButtonView = true
                }
            } else {
                self.cancelTitle = "Hủy"
                self.isHiddenEditButton = false
                self.isHiddenButtonView = false
                self.isHiddenCanncelButton = false
                self.isHiddenConfirmButton = true
                self.isHiddenProgressButton = true
                self.isHiddenPendingButton = true
                self.isHiddenCompleteButtom = true
                self.isHiddenButtonView = true
            }
        }
    }
    
    struct CustomerData {
        var name: String
        var urlImage: URL?
        var birthday: String
        var address: String
        var phoneNumber: String
        var status: OrderStatus
        
        init(order: Order?) {
            let customer = order?.customer
            self.name = customer?.fullName ?? ""
            self.urlImage = customer?.urlImage
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY"
            if let date = customer?.dateOfBirth {
                self.birthday = dateFormatter.string(from: date)
            } else {
                self.birthday = "---"
            }
            self.address = .join([customer?.district?.name, customer?.province?.name], separator: ", ")
            self.phoneNumber = customer?.phoneNumber ?? ""
            self.status = order?.status ?? .cancel
        }
    }
    
    struct Generic {
        var code: String
        var address: NSAttributedString
        var issue: NSAttributedString
        var duaOn: NSAttributedString
        var createOn: String
        var status: OrderStatus
        var paymentStatus: OrderPaymentStatus
        var jobIcon: UIImage?
        var isHiddenCancelOn: Bool
        var cancelOn: String
        var isHiddenTimeEnd: Bool
        var timeEnd: String
        
        init(order: Order) {
            self.isHiddenCancelOn = order.cancelOn == nil
            self.isHiddenTimeEnd = order.endTime == nil
            self.paymentStatus = order.paymentStatus
            self.status = order.status
            self.code = order.job?.name ?? ""
            let address: String = .join([order.address,
                                         order.ward?.name,
                                         order.district?.name,
                                         order.province?.name],
                                        separator: ", ")
            self.address = AttributedStringMaker(string: "Địa chỉ: \(address)")
                .font(Fonts.defaultFont(ofSize: .default))
                .color(.text50)
                .first(match: "Địa chỉ:", maker: {
                    $0.font(Fonts.mediumFont(ofSize: .default)).color(.text)
            }).build()
            self.issue = AttributedStringMaker(string: "Vấn đề: \(order.describe ?? "")")
                .font(Fonts.defaultFont(ofSize: .default))
                .color(.text50)
                .first(match: "Vấn đề:", maker: {
                    $0.font(Fonts.mediumFont(ofSize: .default)).color(.text)
            }).build()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
            var estimateTime: String = ""
            if let duaOnTime =  order.estimateTime {
                estimateTime = dateFormatter.string(from: duaOnTime)
            }
            self.duaOn =  AttributedStringMaker(string: "Thời gian mong muốn: \(estimateTime)")
                .font(Fonts.defaultFont(ofSize: .default))
                .color(ColorConstant.text50)
                .first(match: "Thời gian mong muốn:", maker: {
                $0.font(Fonts.mediumFont(ofSize: .default)).color(ColorConstant.text)
            }).build()
            
            if let createTime = order.createOn {
                self.createOn = "Tạo lúc: \(dateFormatter.string(from: createTime))"
            } else {
                self.createOn = ""
            }
            
            if let date = order.cancelOn{
                self.cancelOn = "Huỷ lúc: \(dateFormatter.string(from: date))"
            } else {
                self.cancelOn = ""
            }
            
            if let date = order.endTime {
                self.timeEnd = "Tạo lúc: \(dateFormatter.string(from: date))"
            } else {
                self.timeEnd = ""
            }
            self.jobIcon = order.job?.type.selectImage
        }
    }
}
