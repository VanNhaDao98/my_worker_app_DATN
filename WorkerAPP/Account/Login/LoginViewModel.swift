//
//  LoginViewModel.swift
//  CustomerApp
//
//  Created by Dao Van Nha on 22/10/2023.
//

import Foundation
import Presentation
import Domain
import Resolver
import PromiseKit

class LoginViewModel: BaseViewModel<LoginViewModel.Input, LoginViewModel.Output> {
    
    enum Input {
        case viewDidLoad
        case updateEmail(_ email: String?)
        case updatePassword(_ password: String?)
        case login
        case resetPassword(_ email: String)
        case tapResetPassword
    }
    
    struct Output: VMOutPut {
        var actionFail: (String) -> Void
        var showLoading: () -> Void
        var didRequestResetPassword: (String) -> Void
        var resetPassword: () -> Void
        
        var emptyAccount: (Account) -> Void
        var successGenericAccount: (Worker) -> Void
        var loginView: () -> Void
    }
    
    private var login = Login()
    
    @Injected
    private var accountUseCase: IAccountUseCase
    
    @Injected
    private var dbUseCase: IDataBaseUseCase
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            output.showLoading()
            accountUseCase.getCurrentAccount().done { account in
                if let account = account {
                    AccountUtils.shard.setAccount(account: account)
                    self.getGenericAccount(account: account)
                } else {
                    self.output.loginView()
                }
            }.catch { error in
                
            }.finally {
                self.output.hideLoading()
            }
        case .updateEmail(let email):
            login.set(email: email)
        case .updatePassword(let password):
            login.set(password: password)
        case .login:
            self.loginAccount()
//            dbUseCase.create()
        case .resetPassword(let email):
            resetPassword(email: email)
        case .tapResetPassword:
            output.resetPassword()
        }
    }
    
    private func loginAccount() {
        if !validate() {
            return
        }
        output.showLoading()
        accountUseCase.login(model: login).done { accout in
            AccountUtils.shard.setAccount(account: accout)
            self.getGenericAccount(account: accout)
        }.catch { error in
            self.output.actionFail(error.localizedDescription)
        }.finally {
            self.output.hideLoading()
        }
    }
    
    private func validate() -> Bool {
        if login.email.isEmpty {
            output.actionFail("Địa chỉ email không được bỏ trống")
            return false
        }
        
        if !login.email.isValidEmail() {
            output.actionFail("Địa chỉ email sai định dạng")
            return false
        }
        
        if login.password.isEmpty {
            output.actionFail("Mật khẩu không được  bỏ trống")
            return false
        }
        
        return true
    }
    
    private func resetPassword(email: String) {
        output.showLoading()
        accountUseCase.resetPassword(email: email).done {
            self.output.didRequestResetPassword("Yêu cầu của bạn đã được hệ thống ghi nhận. Vui lòng check Mail của bạn")
        }.catch { error in
            self.output.actionFail(error.localizedDescription)
        }.finally {
            self.output.hideLoading()
        }
    }
    
    private func getGenericAccount(account: Account) {
        
        var value: Worker?
        let promise1 = accountUseCase.getDetailWorker(id: account.uid)
        let promise2 = accountUseCase.getDegrees(id: account.uid)
        output.showLoading()
        when(fulfilled: promise1, promise2).done { account in
            var genericAccount = account.0
            let degrees = account.1
            
            genericAccount?.setAccountDegree(degree: degrees)
            value = genericAccount
        }.catch { error in
            print(error.localizedDescription)
        }.finally {
            self.output.hideLoading()
            if let value = value {
                self.output.successGenericAccount(value)
            } else {
                self.output.emptyAccount(account)
            }
        }
    }
    
}
