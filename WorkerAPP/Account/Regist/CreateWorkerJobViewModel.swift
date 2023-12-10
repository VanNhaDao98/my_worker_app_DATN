//
//  CreateWorkerJobViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import Presentation
import Domain
import UIKit
import Resolver
import PromiseKit


class CreateWorkerJobViewModel: BaseViewModel<CreateWorkerJobViewModel.Input, CreateWorkerJobViewModel.Output> {
    enum Input {
        case viewDidLoad
        
        case didSelectJob(_ index: Int)
        
        case completion
    }
    
    struct Output: VMOutPut {
        var reloadView: () -> Void
        
        var loading: () -> Void
        
        var error: (String) -> Void
        
        var enableButton: (Bool) -> Void
        
        var didConfirm: (Worker) -> Void
    }
    
    @Injected
    private var useCase: IAccountUseCase
    
    @Injected var uploadUseCase: IUploadFileUseCase
    
    private var genericAccount: Worker
    
    private var jobs: [Job] = []
    
    public var jobsValue: ([Job], Job?) {
        return (jobs, genericAccount.job)
    }
    
    init(genericAccount: Worker) {
        self.genericAccount = genericAccount
    }
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            output.enableButton(genericAccount.job != nil)
            getData()
        case .didSelectJob(let index):
            let job = jobs[index]
            genericAccount.set(job: job)
            self.output.reloadView()
            output.enableButton(genericAccount.job != nil)
        case .completion:
            output.didConfirm(self.genericAccount)
//            var urlImage: URL? = nil
//            self.output.loading()
//            uploadUseCase.uploadImage(image: genericAccount.avatarImage).done { url in
//                urlImage = url
//            }.catch { _ in
//                urlImage = nil
//                self.output.hideLoading()
//            }.finally {
//                self.createData(urlImage: urlImage)
//            }
        }
    }
    
//    private func createData(urlImage: URL?) {
//        genericAccount.set(urlImage: urlImage)
//        let promise1: Promise<Void> = useCase.createWorkerGeneric(account: genericAccount)
//        let promise2: Promise<Void> = useCase.updateAccount(account: genericAccount.account ?? Account())
//        let promise3: Promise<Void> = useCase.createDegree(id: genericAccount.account?.uid ?? "note", degrees: genericAccount.degree)
//        let promise4: Promise<Void> = useCase.createWallet(id: genericAccount.account?.uid ?? "note", data: Wallet(totalMoney: 0))
//        output.loading()
//        when(fulfilled: promise1, promise2, promise3, promise4).done {
//            self.output.didCreateSuccess()
//            AccountUtils.shard.setAccount(account: self.genericAccount.account)
//        }.catch { error in
//            self.output.error(error.localizedDescription)
//        }.finally {
//            self.output.hideLoading()
//        }
//    }
    
    private func getData() {
        output.loading()
        useCase.getJobs().done { jobs in
            self.jobs = jobs
        }.catch { error in
            self.output.error(error.localizedDescription)
        }.finally {
            self.output.hideLoading()
            self.output.reloadView()
        }
    }
}
