//
//  SelectMaterialViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/11/2023.
//

import Foundation
import Presentation
import Domain
import Resolver

class SelectMaterialViewModel: BaseViewModel<SelectMaterialViewModel.Input, SelectMaterialViewModel.Output> {
    
    enum Input {
        case viewDidLoad
        case confirm
        case selectLineItem(_ index: Int)
        case search(_ query: String)
        case updateQuantity(_ index: Int, _ quantity: Double)
    }
    
    struct Output: VMOutPut {
        var reloadView: () -> Void
        var didConfirm: ([LineItem]) -> Void
        
    }
    
    private var defaultLineItems: [LineItem] = []
    private var lineItems: [LineItem] = []
    
    private var currentLineItems: [LineItem]
    
    private var parseVariantToLineItem: (Material) -> LineItem
    
    public var lineItemsValue: [LineItem] {
        return lineItems
    }
    
    public var currentValue: [LineItem] {
        return currentLineItems
    }
    
    
    init(currentLineItems: [LineItem],
         parseVariantToLineItem: @escaping (Material) -> LineItem) {
        self.currentLineItems = currentLineItems
        self.parseVariantToLineItem = parseVariantToLineItem
    }
    
    @Injected
    private var useCase: IAccountUseCase
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            getData()
        case .confirm:
            output.didConfirm(self.currentLineItems)
        case .selectLineItem(let index):
            var lineItem = self.lineItems[index]
            if self.currentLineItems.contains(where: { $0.id == lineItem.id }) {
                self.currentLineItems.removeAll(where: { $0.id == lineItem.id })
            } else {
                lineItem.setQuantity(quantity: 1)
                self.currentLineItems.append(lineItem)
            }
            self.output.reloadView()
        case .search(let query):
            self.search(query: query)
        case .updateQuantity(let index, let quantity):
            var lineItem = self.lineItems[index]
            lineItem.setQuantity(quantity: quantity)
            if quantity == 0 {
                self.currentLineItems.removeAll(where: { $0.id == lineItem.id })
            } else {
                if let index = currentLineItems.firstIndex(where: { $0.id == lineItem.id}) {
                    self.currentLineItems[index] = lineItem
                }
            }
            
            self.output.reloadView()
        }
    }
    
    private func search(query: String) {
        if query.isEmpty {
            self.lineItems = self.defaultLineItems
        } else {
            func normalizeString(_ input: String) -> String {
                return input.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
            }
            self.lineItems = defaultLineItems.filter({ value in
                let normalizedQuery = normalizeString(query)
                return normalizeString(value.name).contains(normalizedQuery)
            })
        }
        self.output.reloadView()
    }
    
    private func getData() {
        guard let account = AccountUtils.shard.getAccount() else { return }
        useCase.getMaterials(workerId: account.uid).done { values in
            self.setLineItems(materials: values)
        }.catch { _ in
            
        }.finally {
            self.output.reloadView()
        }
    }
    
    private func setLineItems(materials: [Material]) {
        self.defaultLineItems = materials.map({ self.parseVariantToLineItem($0)})
        for (index, lineItem) in defaultLineItems.enumerated() {
            if let value = self.currentLineItems.first(where: { $0.id == lineItem.id}) {
                self.defaultLineItems[index] = value
            }
        }
        
        self.lineItems = defaultLineItems
    }
}
