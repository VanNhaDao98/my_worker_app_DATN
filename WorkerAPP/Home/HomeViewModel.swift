//
//  HomeViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/10/2023.
//

import Foundation
import Presentation
import Domain
import Resolver
import PromiseKit
import UIKit
import Utils

class HomeViewModel: BaseViewModel<HomeViewModel.Input, HomeViewModel.Output> {
    
    enum Input {
        case viewDidLoad
        
        case changeStatue(_ isActive: Bool)
        
        case card(_ code: String)
        
        case openLine(Int)
        
        case sendData([Order])
    }
    
    struct Output: VMOutPut {
        var loading: () -> Void
        var headerTitle: (String) -> Void
        var activeStatus: (Bool) -> Void
        
        var updateStatusSuccess: () -> Void
        
        var error: (String) -> Void
        
        var totalMoney: (String) -> Void
        
        var reloadNewsTableView: () -> Void
        
        var report: (Report) -> Void
    }
    
    @Injected
    private var useCase: IAccountUseCase
    
    @Injected
    private var cardUseCase: ICardUseCase
    
    @Injected
    private var orderUseCase: IOrderUseCase
    
    private var genericAccount: Worker?
    
    private var wallet: Wallet?
    
    private var news: [News] = [ News(image: ImageConstant.banner_ai,
                                      url: URL(string: "https://cafef.vn/top-5-cong-viec-de-bi-thay-the-nhat-boi-ai-20230210133839525.chn"),
                                      title: "Top 5 công việc dễ bị thay thế nhất bởi AI",
                                      subTitle: "10-02-2023 - 13:40 PM"),
                                 News(image: ImageConstant.banner_humg,
                                      url: URL(string: "https://tuyensinhso.vn/school/dai-hoc-mo-dia-chat-co-so-ha-noi.html"),
                                      title: "Thông tin tuyển sinh đại học Mỏ - Địa chất",
                                      subTitle: "14/11/2023"),
                                 News(image: ImageConstant.banner_cntt,
                                      url: URL(string: "https://glints.com/vn/blog/muc-luong-nganh-cong-nghe-thong-tin-it/#:~:text=L%C6%B0%C6%A1ng%20c%C3%B4ng%20ngh%E1%BB%87%20th%C3%B4ng%20tin,v%C3%A0%20n%C4%83ng%20l%E1%BB%B1c%20m%E1%BB%97i%20ng%C6%B0%E1%BB%9Di."),
                                      title: "Lương Ngành Công Nghệ Thông Tin Có Cao Không?",
                                      subTitle: "10/02/2023"),
                                 News(image: ImageConstant.banner_newYear,
                                      url: URL(string: "https://nhandan.vn/thong-bao-lich-nghi-tet-nguyen-dan-nam-2024-post783886.html"),
                                      title: "Thông báo lịch nghỉ Tết Nguyên đán năm 2024",
                                      subTitle: " 27/11/2023")
    ]
    
    public var newsValue: [News] {
        return news
    }
    
    private var orders: [Order] = []
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            getData()
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name("wallet"), object: nil)
            
        case .changeStatue(let status):
            genericAccount?.setStatus(status)
            updateStatus()
        case .card(let code):
            output.loading()
            cardUseCase.getCard(id: code).done { card in
                if let card = card {
                    self.rechargeValue(card: card)
                } else {
                    print("Khong tim thay ma the phu hop")
                    self.output.hideLoading()
                }
                
            }.catch { error in
                print("error")
                self.output.hideLoading()
            }
        case .openLine(let index):
            let news = self.news[index]
            if let url = news.url {
                UIApplication.shared.open(url)
            }
        case .sendData(let values):
            self.orders = values
            self.output.report(.init(order: self.orders))
        }
    }
    
    private func rechargeValue(card: Card) {
        guard let account = AccountUtils.shard.getAccount() else { return }
        guard let wallet = wallet else { return }
        var w = wallet
        w.recharge(card.value)
        cardUseCase.updateWallet(id: account.uid, data: w).done {
            self.removeCard(card: card)
        }.catch { _ in
            self.output.hideLoading()
            print("Nap tien that bai")
        }
    }
    
    private func removeCard(card: Card) {
        cardUseCase.removeCard(id: card.code).done {
            print("xoa thanh cong")
        }.catch { _ in
            print("Xoa that bai")
        }.finally {
            self.output.hideLoading()
        }
    }
    @objc func handleNotification(_ notification: Notification) {
        if let data = notification.object as? Wallet {
            self.wallet = data
            self.output.totalMoney(data.totalMoney.currencyFormat())
        }
    }
    
    private func getData() {
        guard let account = AccountUtils.shard.getAccount() else { return }
        let promise1 = useCase.getDetailWorker(id: account.uid)
        let promise2 = useCase.getDegrees(id: account.uid)
        let promise3 = cardUseCase.getWallet(id: account.uid)
        let promise4 = orderUseCase.getListOrder(id: account.uid)
        output.loading()
        when(fulfilled: promise1, promise2, promise3, promise4).done { value in
            var genericAccount = value.0
            let degrees = value.1
            
            genericAccount?.setAccountDegree(degree: degrees)
            genericAccount?.set(account: account)
            self.wallet = value.2
            self.output.totalMoney(value.2.totalMoney.currencyFormat())
            self.genericAccount = genericAccount
            self.orders = value.3
        }.catch { error in
            print(error.localizedDescription)
        }.finally {
            self.output.hideLoading()
            self.output.headerTitle(self.genericAccount?.fullName ?? "---")
            self.output.activeStatus(self.genericAccount?.status == .active)
            self.output.report(.init(order: self.orders))
        }
    }
    
    private func updateStatus() {
        guard let account = genericAccount else { return }
        output.loading()
        useCase.updateStatus(account: account).done {
            self.output.updateStatusSuccess()
        }.catch { error in
            self.output.error(error.localizedDescription)
        }.finally {
            self.output.hideLoading()
            self.output.activeStatus(self.genericAccount?.status == .active)
        }
    }
}

extension HomeViewModel {
    struct Report {
        var totalMoney: String
        var customer: String
        var cancelOrder: String
        var order: String
        
        init(order: [Order]) {
            
            let orderCurrent = order.filter { order in
                if let createOn = order.createOn {
                    return areDatesEqual(date1: createOn, date2: Date())
                } else {
                    return false
                }
            }
            var money: Double = 0
            var customerCount: Int = orderCurrent.reduce(into: [String]()) { result, order in
                if !result.contains(order.customer?.id ?? "") {
                    result.append(order.customer?.id ?? "")
                }
            }.count
            var cancelOrder: Int =  orderCurrent.filter({ $0.status == .cancel}).count
            
            for order in orderCurrent {
                money += order.price
            }
            self.totalMoney = money.currencyFormat()
            self.customer = customerCount.string
            self.cancelOrder = cancelOrder.string
            self.order = orderCurrent.count.string
            
            func areDatesEqual(date1: Date, date2: Date) -> Bool {
                let calendar = Calendar.current
                let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
                let components2 = calendar.dateComponents([.year, .month, .day], from: date2)

                return components1.year == components2.year &&
                       components1.month == components2.month &&
                       components1.day == components2.day
            }
        }
    }
}

struct News {
    var image: UIImage?
    var url: URL?
    var title: String
    var subTitle: String
}
