//
//  DetailJobLevelViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 26/11/2023.
//

import Foundation
import Presentation
import Domain

class DetailJobLevelViewModel: BaseViewModel<DetailJobLevelViewModel.Input, DetailJobLevelViewModel.Output> {
    
    enum Input {
        case viewDidLoad
    }
    
    struct Output: VMOutPut {
        var item: ([Item]) -> Void
    }
    
    private var job: Job
    
    init(job: Job) {
        self.job = job
    }
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            getData()
        }
    }
    
    private func getData() {
        var items: [Item] = []
        var levels: [Double] = self.job.type.practice.compactMap({ $0.key})
        levels.sort(by: {
            $0 < $1
        })
        
        for level in levels {
            let rank: String = level.currencyFormat()
            let knowledge: [String] = self.job.type.knowledge[level] ?? []
            let practice: [String] = self.job.type.practice[level] ?? []
            
            let item: Item = .init(level: rank,
                                   knowledge: knowledge,
                                   practice: practice)
            
            items.append(item)
        }
        
        output.item(items)
    }
}

extension DetailJobLevelViewModel {
    struct Item {
        var level: String
        var knowledge: String
        var practice: String
        
        init(level: String,
             knowledge: [String],
             practice: [String]) {
            self.level = "Cấp bậc: \(level)"
            self.knowledge = .join(knowledge, separator: "\n")
            self.practice = .join(practice, separator: "\n")
        }
    }
}
