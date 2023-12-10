//
//  CreateWorkerGeneralViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 14/10/2023.
//

import Foundation
import Presentation
import Domain

class CreateWorkerGeneralViewModel: BaseViewModel<CreateWorkerGeneralViewModel.Input, CreateWorkerGeneralViewModel.Output> {
    enum Input {
        case viewDidLoad
        case tapAvatar
        case tapGeneric
        case tapAddress
        case tapDegree
        case updateAccount(_ account: Worker)
        case confirm
    }
    
    struct Output: VMOutPut {
        var avatar: (Worker) -> Void
        var generic: (Worker) -> Void
        var address: (Worker) -> Void
        var degree: (Worker) -> Void
        
        var avatarStatus: (Bool) -> Void
        var genericStatus: (Bool) -> Void
        var addressStatus: (Bool) -> Void
        var degreeStatus: (Bool) -> Void
        var buttonMode: (Bool) -> Void
        var didCreateAccount: (Worker) -> Void
    }
    private var genericAccount = Worker()
    
    init(account: Account?) {
        self.genericAccount.set(account: account)
    }
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            setStatus()
        case .tapAvatar:
            output.avatar(genericAccount)
        case .tapGeneric:
            output.generic(genericAccount)
        case .tapAddress:
            output.address(genericAccount)
        case .tapDegree:
            output.degree(genericAccount)
        case .updateAccount(let account):
            self.genericAccount = account
            setStatus()
        case .confirm:
            output.didCreateAccount(genericAccount)
        }
    }
    
    private func setStatus() {
        let avatarStatus = genericAccount.avatarImage != nil
        let genericStatus = !(genericAccount.fullName ?? "").isEmpty
        && !(genericAccount.phoneNumber ?? "").isEmpty
        && genericAccount.dateOfBirth != nil
        && genericAccount.gender != nil
        && !(genericAccount.describe ?? "").isEmpty
        
        let addressStatus = genericAccount.province != nil
        && genericAccount.district != nil
        && genericAccount.ward != nil
        && !(genericAccount.address ?? "").isEmpty
        
        let degreeStatus = !genericAccount.degree.isEmpty
        
        output.avatarStatus(avatarStatus)
        output.genericStatus(genericStatus)
        output.addressStatus(addressStatus)
        output.degreeStatus(degreeStatus)
        
        output.buttonMode(avatarStatus && genericStatus && addressStatus)
    }
}
