//
//  CreateWorkerDegreeViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import Presentation
import Domain
import Resolver
import UIComponents
import UIKit

class CreateWorkerDegreeViewModel: BaseViewModel<CreateWorkerDegreeViewModel.Input, CreateWorkerDegreeViewModel.Output> {
    enum Input {
        case viewDidLoad
        case confirm
        case loading
        
        case addDegree
        case remove(_ index: Int)
        
        case updateName(Int, String?)
        case tapLevel(Int)
        case tapType(Int)
        case tapStartTime(Int)
        case tapEndTime(Int)
        
        case updateLevel(Int, DegreeLevel)
        case updateType(Int, Degree)
        case updateStartTime(Int, Date?)
        case updateEndTime(Int, Date?)
        
        case updateProfile(Int, String?)
        
    }
    
    struct Output: VMOutPut {
        var didConfirm: (Worker) -> Void
        var loading: () -> Void
        var error: (String) -> Void
        
        var currentDegree: ([AccountDregee]) -> Void
        
        var level: (Int, [SelectionItem<DegreeLevel>]) -> Void
        var type: (Int, [SelectionItem<Degree>]) -> Void
        var startTime: (Int, Date?) -> Void
        var endTime: (Int, Date?) -> Void
        
        var reloadAtIndex: (Int) -> Void
        
        var modeButton: (Bool) -> Void
    }
    
    @Injected
    private var useCase: IDegreeUseCase
    
    private var genericAccount: Worker
    
    private var degrees: [Degree] = []
    
    init(genericAccount: Worker) {
        self.genericAccount = genericAccount
    }
    
    public var accountDegreeValue: [AccountDregee] {
        return genericAccount.degree
    }
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            getData()
            if genericAccount.degree.isEmpty {
                let accountDegee = AccountDregee()
                genericAccount.updateDegree(accountDegee)
            }
            reloadView()
            setMode()
        case .confirm:
            output.didConfirm(genericAccount)
        case .loading:
            output.loading()
        case .addDegree:
            let accountDegee = AccountDregee()
            genericAccount.updateDegree(accountDegee)
            reloadView()
            setMode()
        case .remove(let index):
            genericAccount.deleteDegree(index)
            reloadView()
            setMode()
        case .updateName(let index, let text):
            var degree = genericAccount.degree[index]
            degree.setuniversity(text)
            genericAccount.setDegree(index: index, degree: degree)
            setMode()
        case .tapLevel(let index):
            let degree = genericAccount.degree[index]
            output.level(index, DegreeLevel.allCases.map({ .init(title: $0.title,
                                                                 isSelected: $0 == degree.level,
                                                                 rawData: $0)}))
        case .tapType(let index):
            let degree = genericAccount.degree[index]
            output.type(index, degrees.map({ .init(title: $0.name,
                                                   isSelected: $0.id == degree.degree.id,
                                                   rawData: $0)}))
        case .tapStartTime(let index):
            let degree = genericAccount.degree[index]
            output.startTime(index, degree.startTime)
        case .tapEndTime(let index):
            let degree = genericAccount.degree[index]
            output.endTime(index, degree.endTime)
        case .updateLevel(let index, let level):
            var degree = genericAccount.degree[index]
            degree.setLevel(level)
            genericAccount.setDegree(index: index, degree: degree)
            output.reloadAtIndex(index)
            setMode()
        case .updateType(let index, let type):
            var degree = genericAccount.degree[index]
            degree.setDegree(type)
            genericAccount.setDegree(index: index, degree: degree)
            output.reloadAtIndex(index)
            setMode()
        case .updateStartTime(let index, let time):
            var degree = genericAccount.degree[index]
            if let startTime = time {
                if startTime > degree.endTime ?? Date() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.output.error("Thời gian bắt đầu không thể lớn hơn thời gian kết thúc")
                    })
                    return
                }
            }
            degree.setStartTime(time)
            genericAccount.setDegree(index: index, degree: degree)
            output.reloadAtIndex(index)
            setMode()
        case .updateEndTime(let index, let time):
            var degree = genericAccount.degree[index]
            if let endTime = time, let startTime = degree.startTime {
                if startTime > endTime {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.output.error("Thời gian bắt đầu không thể lớn hơn thời gian kết thúc")
                    })
                    return
                }
            }
            degree.setEndTime(time)
            genericAccount.setDegree(index: index, degree: degree)
            output.reloadAtIndex(index)
            setMode()
        case .updateProfile(let index, let text):
            var degree = genericAccount.degree[index]
            degree.setProfile(text)
            genericAccount.setDegree(index: index, degree: degree)
            setMode()
        }
    }
    
    private func getData() {
        self.send(.loading)
        useCase.getDegree().done { data in
            self.degrees = data
        }.catch { error in
            self.output.error(error.localizedDescription)
        }.finally {
            self.output.hideLoading()
        }
    }
    
    private func reloadView() {
        output.currentDegree(genericAccount.degree)
    }
    
    private func setMode() {
        output.modeButton(valiDate())
    }
    
    private func valiDate() -> Bool {
        
        let degrees = genericAccount.degree
        for degree in degrees {
            if degree.university.isEmpty {
                return false
            }
            
            if degree.degree.id == 0 {
                return false
            }
            
            if degree.startTime == nil {
                return false
            }
            
            if degree.endTime == nil {
                return false
            }
            
            if degree.profile.isEmpty {
                return false
            }
        }
        return true
    }
}

extension CreateWorkerDegreeViewModel {
    struct DegreeValue {
        var name: String
        var level: String
        var type: String
        var startTime: String
        var endTime: String
        var profile: String
        
        init(degree: AccountDregee) {
            self.name = degree.university
            self.level = degree.level.title
            self.type = degree.degree.name
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY"
            if let start = degree.startTime {
                self.startTime = dateFormatter.string(from: start)
            } else {
                self.startTime = ""
            }
            
            if let end = degree.endTime {
                self.endTime = dateFormatter.string(from: end)
            } else {
                self.endTime = ""
            }
            self.profile = degree.profile
        }
        
    }
}
