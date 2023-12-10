//
//  PersionalViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 17/10/2023.
//

import Foundation
import Presentation
import Domain
import Resolver
import PromiseKit

class PersionalViewModel: BaseViewModel<PersionalViewModel.Input, PersionalViewModel.Output> {
    
    enum Input {
        case viewDidLoad
        case detailAccount
        case logout
        case updatePassword
        case confirmUpddatePassword(_ password: String)
        case sendData(_ orders: [Order])
    }
    
    struct Output: VMOutPut {
        var loading: () -> Void
        var describe: (String) -> Void
        var detailAccount: (Worker) -> Void
        var logout: () -> Void
        var error: (String) -> Void
        var header: (DetailPesionalViewModel.Header) -> Void
        var success: (String) -> Void
        var updatePassword: () -> Void
    }
    
    @Injected
    private var useCase: IAccountUseCase
    
    @Injected
    private var orderUseCase: IOrderUseCase
    
    private var genericAccount: Worker?
    
    private var orders: [Order] = []
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            getData()
        case .detailAccount:
            if let account = genericAccount {
                output.detailAccount(account)
            }
        case .logout:
            output.loading()
            useCase.logout().done {
                self.output.logout()
                AccountUtils.shard.reset()
            }.catch { error in
                self.output.error(error.localizedDescription)
            }.finally {
                self.output.hideLoading()
            }
        case .updatePassword:
            output.updatePassword()
        case .confirmUpddatePassword(let password):
            output.loading()
            useCase.updatePassword(password: password).done {
                self.output.success("Cập nhật mật khẩu thành công")
            }.catch { error in
                self.output.error("Đổi mật khẩu thất bại")
            }.finally {
                self.output.hideLoading()
            }
        case .sendData(let orders):
            self.orders = orders
            self.output.header(.init(account: self.genericAccount ?? Worker(), order: self.orders))
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
            print(rates)
            genericAccount?.setAccountDegree(degree: degrees)
            genericAccount?.setRate(rates: rates)
            genericAccount?.setMaterials(materials: account.3)
            self.genericAccount = genericAccount
            self.orders = account.4
        }.catch { error in
            self.output.error(error.localizedDescription)
        }.finally {
            self.output.hideLoading()
            self.output.describe(self.genericAccount?.describe ?? "Lao động là vinh quang ")
            self.output.header(.init(account: self.genericAccount ?? Worker(), order: self.orders))
        }
    }
}

