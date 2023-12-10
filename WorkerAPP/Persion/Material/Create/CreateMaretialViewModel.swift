//
//  CreateMaretialViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 13/11/2023.
//

import Foundation
import Presentation
import Domain
import Resolver
import UIKit
import Utils

class CreateMaretialViewModel: BaseViewModel<CreateMaretialViewModel.Input, CreateMaretialViewModel.Output> {
    
    enum Input {
        case viewDidLoad
        case confirm
        case addMaterial
        case delete(Int)
        
        case updateName(Int, String?)
        case updateUnit(Int, String?)
        case updatePrice(Int, String?)
        
        case chooseImage(Int)
        case updateImage(UIImage)
    }
    
    struct Output: VMOutPut {
        var items: ([Material]) -> Void
        var loading: () -> Void
        var didCrateMaterial: () -> Void
        
        var pickerImage: () -> Void
    }
    
    private var imageIndex = 0
    
    @Injected
    private var useCase: IAccountUseCase
    
    @Injected
    private var uploadFileUseCase: IUploadFileUseCase
    
    private var oldMaterials: [Material]
    
    init(oldMaterials: [Material]) {
        self.oldMaterials = oldMaterials
    }
    
    private var materials: [Material] = []
    
    public var materialValue: [Material] {
        return materials
    }
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            if materials.isEmpty {
                let material = Material()
                materials.append(material)
            }
            output.items(self.materials)
        case .confirm:
            guard let account = AccountUtils.shard.getAccount() else { return }
            self.output.loading()
            let newValue = self.oldMaterials + self.materialValue
            useCase.createMaterial(workerId: account.uid, material: newValue).done {
                self.output.didCrateMaterial()
            }.catch { error in
                print("error")
            }.finally {
                self.output.hideLoading()
            }
        case .addMaterial:
            let material = Material()
            materials.append(material)
            output.items(self.materials)
        case .delete(let index):
            materials.remove(at: index)
            output.items(self.materials)
        case .updateName(let index, let name):
            var material = self.materials[index]
            material.updateName(name: name ?? "")
            self.materials[index] = material
        case .updateUnit(let index, let unit):
            var material = self.materials[index]
            material.updateUnit(unit: unit ?? "")
            self.materials[index] = material
        case .chooseImage(let index):
            self.imageIndex = index
            output.pickerImage()
        case .updateImage(let image):
            self.output.loading()
            var url: URL? = nil
            uploadFileUseCase.uploadImage(image: image).done { urlImage in
                url = urlImage
            }.catch { error in
                print(error.localizedDescription)
            }.finally {
                self.output.hideLoading()
                var material = self.materials[self.imageIndex]
                material.updateURL(url: url)
                material.updateImage(image: image)
                self.materials[self.imageIndex] = material
                self.output.items(self.materials)
            }
        case .updatePrice(let index, let price):
            var material = self.materials[index]
            material.updatePrice(price: Formatter.shared.number(from: price))
            self.materials[index] = material
        }
    }
}
