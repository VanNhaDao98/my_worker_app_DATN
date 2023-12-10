//
//  RegistPhoneNumberViewModel.swift
//  CustomerApp
//
//  Created by Dao Van Nha on 22/10/2023.
//

import Foundation
import Presentation
import Domain
import Resolver

class RegistAccountViewModel: BaseViewModel<RegistAccountViewModel.Input, RegistAccountViewModel.Output> {
    
    enum Input {
        case viewDidLoad
        case updateEmail(_ phone: String?)
        case updatePassword(_ password: String?)
        case updateConfirmPassword(_ password: String?)
        case submit
        case showLoading
    }
    
    struct Output: VMOutPut {
        var showLoding: () -> Void
        var didRegistAccount: (Account) -> Void
        var error: (String) -> Void
    }
    
    private var login = Login()
    private var account: Account?
    
    @Injected
    private var useCase: IAccountUseCase
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            break
        case .submit:
            if !isValiddate() {
                return
            }
            self.send(.showLoading)
            useCase.create(model: login).done { account in
                self.output.didRegistAccount(account)
            }.catch { error in
                self.output.error(error.localizedDescription)
            }.finally {
                self.output.hideLoading()
            }
        case .showLoading:
            output.showLoding()
        case .updateEmail(let email):
            login.set(email: email)
        case .updatePassword(let passWord):
            login.set(password: passWord)
        case .updateConfirmPassword(let confirmPassword):
            login.set(confirmPassword: confirmPassword)
        }
    }
    
    private func isValiddate() -> Bool {
        if login.email.isEmpty {
            output.error("Địa chỉ email không được bỏ trống")
            return false
        }
        
        if !login.email.isValidEmail() {
            output.error("Địa chỉ email sai định dạng")
            return false
        }
        
        if login.password.isEmpty {
            output.error("Mật khẩu không được bỏ trống")
            return false
        }
        
        if login.confirmPassword.isEmpty {
            output.error("Xác nhận lại mật khẩu")
            return false
        }
        
        if login.password != login.confirmPassword {
            output.error("Xác nhận mật khẩu chưa đúng")
            return false
        }
        
        return true
    }
}


