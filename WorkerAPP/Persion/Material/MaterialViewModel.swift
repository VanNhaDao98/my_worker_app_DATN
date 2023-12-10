//
//  MaterialViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/10/2023.
//

import Foundation
import Presentation
import Resolver
import Domain

class MaterialViewModel: BaseViewModel<MaterialViewModel.Input, MaterialViewModel.Output> {
    
    enum Input {
        case viewDidLoad
        
        case create
        case tapEdit(Int)
        case edit(Int, Material)
        
        case search(query: String?)
        
        case remove(_ index: Int)
    }
    
    struct Output: VMOutPut {
        var loading: () -> Void
        var reloadView: () -> Void
        var error: (String) -> Void
        var createMaterial: ([Material]) -> Void
        var editMaterial: (Int, Material) -> Void
        var didUpdateMaterial: () -> Void
    }
    @Injected
    private var useCase: IAccountUseCase
    
    private var materials: [Material] = []
    
    private var defaultmaterial: [Material] = []
    
    public var maretialValue: [Material] {
        return materials
    }
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            getData()
        case .create:
            self.output.createMaterial(materials)
        case .tapEdit(let index):
            let material = materials[index]
            self.output.editMaterial(index, material)
        case .edit(let index, let marerial):
            self.materials[index] = marerial
            
            for (index, value) in defaultmaterial.enumerated() {
                if value.id == marerial.id {
                    self.defaultmaterial[index] = marerial
                }
            }
            guard let account = AccountUtils.shard.getAccount() else { return }
            output.loading()
            useCase.createMaterial(workerId: account.uid, material: defaultmaterial).done {
                self.send(.viewDidLoad)
                self.output.didUpdateMaterial()
            }.catch { error in
                self.output.error("Sửa vật liệu thất bại")
            }.finally {
                self.output.hideLoading()
            }
        case .search(let query):
            search(query: query ?? "")
        case .remove(let index):
            let material = self.materials[index]
            self.defaultmaterial.removeAll(where: { $0.id == material.id})
            guard let account = AccountUtils.shard.getAccount() else { return }
            output.loading()
            useCase.createMaterial(workerId: account.uid, material: defaultmaterial).done {
                self.send(.viewDidLoad)
                self.output.didUpdateMaterial()
            }.catch { error in
                self.output.error("Xóa vật liệu thất bại")
            }.finally {
                self.output.hideLoading()
            }
        }
    }
    
    private func search(query: String) {
        if query.isEmpty {
            self.materials = self.defaultmaterial
        } else {
            func normalizeString(_ input: String) -> String {
                return input.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
            }
            self.materials = defaultmaterial.filter({ value in
                let normalizedQuery = normalizeString(query)
                return normalizeString(value.name).contains(normalizedQuery)
            })
        }
        self.output.reloadView()
    }
    
    private func getData() {
        output.loading()
        guard let account = AccountUtils.shard.getAccount() else { return }
        useCase.getMaterials(workerId: account.uid).done { value in
            self.defaultmaterial = value
            self.materials = self.defaultmaterial
            self.output.reloadView()
        }.catch { error in
            print(error)
        }.finally {
            self.output.hideLoading()
        }
    }
}
