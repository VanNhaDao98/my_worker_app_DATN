//
//  CreateWorkerPersonalViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 14/10/2023.
//

import Foundation
import Presentation
import Domain
import UIComponents

public enum CreateAccountError: Error {
    case error(_ error: String)
}

class CreateWorkerPersonalViewModel: BaseViewModel<CreateWorkerPersonalViewModel.Input, CreateWorkerPersonalViewModel.Output> {
    enum Input {
        case viewDidLoad
        case confirm
        
        case updateName(String?)
        case updateDescribe(String?)
        case tapBirthDay
        case tapGender
        case updatePhoneNumber(String?)
        
        case updateBirthDat(Date?)
        case updateGender(Gender)
    }
    
    struct Output: VMOutPut {
        var didConfirm: (Worker) -> Void
        var generic: (Generic) -> Void
        var date: (Date) -> Void
        var gender: ([SelectionItem<Gender>]) -> Void
        var enableButton: (Bool) -> Void
        var error: (String) -> Void
    }
    
    private var genericAccount: Worker
    
    init(genericAccount: Worker) {
        self.genericAccount = genericAccount
    }
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
           reloadView()
            isEnableButton()
        case .confirm:
            do {
                try validate()
                output.didConfirm(genericAccount)
            } catch CreateAccountError.error(let error) {
                self.output.error(error)
            } catch {}
        case .updateName(let name):
            genericAccount.set(fullName: name)
            isEnableButton()
        case .updateDescribe(let describe):
            genericAccount.set(describe: describe)
            isEnableButton()
        case .tapBirthDay:
            output.date(genericAccount.dateOfBirth ?? Date())
        case .tapGender:
            output.gender(Gender.allCases.map({ .init(title: $0.title,
                                                      isSelected: $0 == genericAccount.gender,
                                                      rawData: $0)}))
        case .updateBirthDat(let birthDay):
            genericAccount.set(dateOfbird: birthDay)
            reloadView()
            isEnableButton()
        case .updateGender(let gender):
            genericAccount.set(gender: gender)
            reloadView()
            isEnableButton()
        case .updatePhoneNumber(let phone):
            genericAccount.set(phoneNumber: phone)
            isEnableButton()
        }
    }
    
    func reloadView() {
        output.generic(.init(account: genericAccount))
    }
    
    func validate() throws {
        if (genericAccount.fullName ?? "").isEmpty {
            throw CreateAccountError.error("Vui lòng nhập họ và tên")
        }
        
        if !(genericAccount.phoneNumber ?? "").isValidPhoneNumber() {
            throw CreateAccountError.error("Số điện thoại sai định dạng")
        }
        
        if (genericAccount.phoneNumber ?? "").isEmpty {
            throw CreateAccountError.error("Vui lòng nhập só điện thoại")
        }
    }
    
    func isEnableButton() {
        let isEnable = !(genericAccount.fullName ?? "").isEmpty
        && !(genericAccount.phoneNumber ?? "").isEmpty
        && genericAccount.dateOfBirth != nil
        && genericAccount.gender != nil
        && !(genericAccount.describe ?? "").isEmpty
        output.enableButton(isEnable)
    }
    
}

extension CreateWorkerPersonalViewModel {
    
    struct Generic {
        var fullname: String
        var birthday: String
        var gender: String
        var describe: String
        var phone: String
        
        init(account: Worker) {
            self.fullname = account.fullName ?? ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY"
            if let date = account.dateOfBirth {
                self.birthday = dateFormatter.string(from: date)
            } else {
                self.birthday = ""
            }
            self.gender = account.gender?.title ?? ""
            self.describe = account.describe ?? ""
            self.phone = account.phoneNumber ?? ""
        }
    }
}
