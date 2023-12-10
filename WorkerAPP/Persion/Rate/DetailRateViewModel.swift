//
//  DetailRateViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 14/11/2023.
//

import Foundation
import Presentation
import Resolver
import Domain

class DetailRateViewModel: BaseViewModel<DetailRateViewModel.Input, DetailRateViewModel.Output> {
    
    enum Input {
        case viewDidLoad
    }
    
    struct Output: VMOutPut {
        var items: () -> Void
    }
    private var rates: [Rate] = []
    
    public var ratesValue: [Rate] {
        return rates
    }
    
    @Injected
    private var useCase: IAccountUseCase
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            getData()
        }
    }
    
    private func getData() {
        guard let account = AccountUtils.shard.getAccount() else { return }
        useCase.getRates(workerId: account.uid).done { items in
            self.rates = items
        }.catch { error in
            
        }.finally {
            self.reloadView()
        }
    }
    
    private func reloadView() {
        output.items()
    }
}
