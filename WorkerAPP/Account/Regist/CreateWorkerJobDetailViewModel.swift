//
//  CreateWorkerJobDetailViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 24/11/2023.
//

import Foundation
import Presentation
import Domain
import Resolver
import UIComponents
import UIKit
import Utils
import PromiseKit

class CreateWorkerJobDetailViewModel: BaseViewModel<CreateWorkerJobDetailViewModel.Input, CreateWorkerJobDetailViewModel.Output> {
    
    enum Input {
        case viewDidLoad
        case tapChooseJob
        case updateJob(_ job: Job)
        case updateDetailLevel(_ detail: String)
        case updateLevel(_ level: Double)
        case tapLevel
        
        case tapReference
        case complete
    }
    
    struct Output: VMOutPut {
        var loading: () -> Void
        var jobs: ([SelectionItem<Job>]) -> Void
        
        var item: (Item) -> Void
        
        var urlreference: (Job) -> Void
        var levels: ([SelectionItem<Double>]) -> Void
        var error: (String) -> Void
        
        var didComplete: () -> Void
    }
    
    @Injected
    private var useCase: IAccountUseCase
    
    @Injected
    private var uploadUseCase: IUploadFileUseCase
    
    @Injected
    private var cardUseCase: ICardUseCase
    
    private var jobs: [Job] = []
    
    private var worker: Worker
    
    init(worker: Worker) {
        self.worker = worker
    }
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            reloadItem()
            getData()
        case .tapChooseJob:
            output.jobs(self.jobs.map({ .init(title: $0.name,
                                              image: .image($0.type.selectImage!),
                                              isSelected: $0.id == self.worker.job?.id,
                                              rawData: $0)}))
        case .updateJob(let job):
            worker.set(job: job)
            reloadItem()
        case .updateDetailLevel(let detail):
            worker.setJobSkillDetail(skill: detail)
        case .updateLevel(let level):
            worker.setJobLevel(level: level)
            reloadItem()
        case .tapLevel:
            var levels: [Double] = self.worker.job?.type.practice.compactMap({ $0.key}) ?? []
            levels.sort(by: {
                $0 < $1
            })
            self.output.levels(levels.map({ .init(title: "Cấp bậc: \($0.currencyFormat())",
                                                  image: .image((self.worker.job?.type.selectImage)!),
                                                  isSelected: $0 == self.worker.jobLevel,
                                                  rawData: $0)}))
        case .tapReference:
            if let job = worker.job {
                output.urlreference(job)
            }
        case .complete:
            if worker.skillDetail.isEmpty {
                output.error("Chi tiết kỹ năng không được bỏ trống")
                return
            }
            var urlImage: URL? = nil
            self.output.loading()
            uploadUseCase.uploadImage(image: worker.avatarImage).done { url in
                urlImage = url
            }.catch { _ in
                urlImage = nil
                self.output.hideLoading()
            }.finally {
                self.createData(urlImage: urlImage)
            }
        }
    }
    
        private func createData(urlImage: URL?) {
            worker.set(urlImage: urlImage)
            let promise1: Promise<Void> = useCase.createWorkerGeneric(account: worker)
            let promise2: Promise<Void> = useCase.updateAccount(account: worker.account ?? Account())
            let promise3: Promise<Void> = useCase.createDegree(id: worker.account?.uid ?? "note", degrees: worker.degree)
            let promise4: Promise<Void> = cardUseCase.createWallet(id: worker.account?.uid ?? "note", data: Wallet(totalMoney: 0))
            output.loading()
            when(fulfilled: promise1, promise2, promise3, promise4).done {
                self.output.didComplete()
                AccountUtils.shard.setAccount(account: self.worker.account)
            }.catch { error in
                self.output.error(error.localizedDescription)
            }.finally {
                self.output.hideLoading()
            }
        }
    
    private func reloadItem() {
        output.item(.init(worker: worker))
    }
    
    private func getData() {
        output.loading()
        useCase.getJobs().done { jobs in
            self.jobs = jobs
        }.catch { error in
            
        }.finally {
            self.output.hideLoading()
        }
    }
}

extension CreateWorkerJobDetailViewModel {
    
    struct Item {
        var icon: UIImage?
        var jobName: String
        var level: String
        var price: String
        var detailLevel: String
        var practice: String
        var knowledge: String
        
        init(worker: Worker) {
            self.icon = worker.job?.type.selectImage ?? ImageConstant.imageEmpty
            self.jobName = worker.job?.name ?? "---"
            self.level = worker.jobLevel.currencyFormat()
            self.price = worker.price.currencyFormat()
            self.detailLevel = worker.skillDetail
            
            let knowledgeValue: [String] = worker.job?.type.knowledge.first(where: {$0.key == worker.jobLevel})?.value ?? []
            let practiceValue: [String] = worker.job?.type.practice.first(where: {$0.key == worker.jobLevel})?.value ?? []
            
            self.knowledge = .join(knowledgeValue, separator: "\n")
            self.practice = .join(practiceValue, separator: "\n")
        }
    }
}
