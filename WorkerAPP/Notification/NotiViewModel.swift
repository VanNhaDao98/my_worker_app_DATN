//
//  NotiViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 21/10/2023.
//

import Foundation
import Presentation
import Domain

class NotiViewModel: BaseViewModel<NotiViewModel.Input, NotiViewModel.Output> {
    
    enum Input {
        case viewDidLoad
    }
    
    struct Output: VMOutPut {
        
    }
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            break
        }
    }
}
