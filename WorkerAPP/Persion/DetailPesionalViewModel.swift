//
//  DetailPesionalViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/10/2023.
//

import Foundation
import Presentation
import Resolver
import Domain
import UIKit
import PromiseKit

class DetailPesionalViewModel: BaseViewModel<DetailPesionalViewModel.Input, DetailPesionalViewModel.Output> {
    
    enum Input {
        case viewDidLoad
        case createMaterial
        case tapEditMaterial(Int)
        case updateMaterial(Int, Material)
        case detailLevel
        case sendData(_ orders: [Order])
    }
    
    struct Output: VMOutPut {
        var loading: () -> Void
        var sologan: (String) -> Void
        var generic: (Generic) -> Void
        var header: (Header) -> Void
        
        var degree: ([Degree]) -> Void
        var rate: ([RateValue]) -> Void
        var materials: ([Material]) -> Void
        
        var createMaterial: ([Material]) -> Void
        var error: (String) -> Void
        
        var editMaterial: (Int, Material) -> Void
        var skill: (String) -> Void
        var level: (Level) -> Void
        var detalLevel: (Job) -> Void
        
    }
    
    @Injected
    private var useCase: IAccountUseCase
    
    @Injected
    private var orderUseCase: IOrderUseCase
    
    public var rates: [RateValue] {
        return account.rates.map({ .init(rate: $0)})
    }
    
    public var materials: [Material] {
        return account.materials
    }
    
    private var account: Worker
    
    private var orders: [Order] = []
    
    init(account: Worker) {
        self.account = account
    }
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            getData()
        case .createMaterial:
            self.output.createMaterial(self.account.materials)
        case .tapEditMaterial(let index):
            let material = account.materials[index]
            self.output.editMaterial(index, material)
        case .updateMaterial(let index, let material):
            account.updateMaterial(index: index, marerial: material)
            guard let account = AccountUtils.shard.getAccount() else { return }
            output.loading()
            useCase.createMaterial(workerId: account.uid, material: self.account.materials).done {
                self.send(.viewDidLoad)
            }.catch { error in
                self.output.error("Sửa thuộc tính thất bại")
            }.finally {
                self.output.hideLoading()
            }
        case .detailLevel:
            guard let job = account.job else { return }
            self.output.detalLevel(job)
        case .sendData(let orders):
            self.orders = orders
            self.output.header(.init(account: self.account,
                                     order: self.orders))
        }
    }
    
    private func getData() {
        guard let account = AccountUtils.shard.getAccount() else { return }
        let promise1 = useCase.getDetailWorker(id: account.uid)
        let promise2 = useCase.getDegrees(id: account.uid)
        let promise3 = useCase.getRates(workerId: account.uid)
        let promise4 = useCase.getMaterials(workerId: account.uid)
        let promise5 = orderUseCase.getListOrder(id: account.uid)
        output.loading()
        when(fulfilled: promise1, promise2, promise3, promise4, promise5).done { account in
            var genericAccount = account.0
            let degrees = account.1
            let rates = account.2
            let materials = account.3
            genericAccount?.setAccountDegree(degree: degrees)
            genericAccount?.setRate(rates: rates)
            genericAccount?.setMaterials(materials: materials)
            if let account = genericAccount {
                self.account = account
            }
            self.orders = account.4
        }.catch { error in
        
        }.finally {
            self.output.hideLoading()
            self.output.sologan(self.account.describe ?? "Lao động là vinh quang")
            self.output.generic(.init(account: self.account))
            self.output.header(.init(account: self.account,
                                     order: self.orders))
            self.output.rate(self.account.rates.map({ .init(rate: $0)}))
            self.output.degree(self.account.degree.map({ .init(degree: $0)}))
            self.output.materials(self.account.materials)
            self.output.skill(self.account.skillDetail)
            self.output.level(.init(account: self.account))
        }
    }
}

extension DetailPesionalViewModel {
    
    struct Level {
        var level: String
        var knowledge: String
        var practice: String
        
        init(account: Worker) {
            self.level = "Bậc: \(account.jobLevel.currencyFormat())"
            self.knowledge = .join(account.job?.type.knowledge.first(where: { $0.key == account.jobLevel})?.value ?? [], separator: "\n")
            self.practice = .join(account.job?.type.practice.first(where: { $0.key == account.jobLevel})?.value ?? [], separator: "\n")
        }
    }
    struct Generic {
        var address: String
        var job: String
        var price: String
        var phoneNumber: String
        var jobIcon: UIImage?
        
        init(account: Worker) {
            self.address = account.province?.name ?? ""
            self.job = account.job?.type.title ?? ""
            self.price = account.price.currencyFormat()
            self.phoneNumber = account.phoneNumber ?? ""
            self.jobIcon = account.job?.type.deSelectImage
        }
    }
    
    struct Header {
        var url: URL?
        var customerValue: String
        var orderValue: String
        
        init(account: Worker,
             order: [Order]) {
            
            let customer: [String] = order.compactMap({ $0.customer?.id})
            
            let count = customer.reduce(into: [String]()) { result, value in
                if !result.contains(value) {
                    result.append(value)
                }
            }
            self.url = account.urlImage
            self.customerValue = count.count.string
            self.orderValue = order.count.string
        }
    }
    
    struct Degree {
        var title: String
        var level: String
        var time: String
        
        init(degree: AccountDregee) {
            self.title = "Bằng \(degree.degree.name) khoa \(degree.profile) trường \(degree.university)"
            self.level = "Xếp loại: \(degree.level.title)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY"
            var startTime: String = "---"
            var endTime: String = "---"
            if let time = degree.startTime {
                startTime = dateFormatter.string(from: time)
            }
            
            if let time = degree.endTime {
                endTime = dateFormatter.string(from: time)
            }
            self.time = "\(startTime) - \(endTime)"
        }
    }
    
    struct RateValue {
        var rate: Double
        var comment: String
        var createOn: String
        var customerName: String
        
        init(rate: Rate) {
            self.rate = rate.rate
            self.comment = rate.comment
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY"
            
            if let createOn = rate.createOn {
                self.createOn = dateFormatter.string(from: createOn)
            } else {
                self.createOn = "---"
            }
            self.customerName = rate.customername
        }
    }
}
