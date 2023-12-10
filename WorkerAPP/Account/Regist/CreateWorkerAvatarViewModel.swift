//
//  CreateWorkerAvatarViewModel.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 14/10/2023.
//

import Foundation
import Presentation
import Domain
import UIKit

class CreateWorkerAvatarViewModel: BaseViewModel<CreateWorkerAvatarViewModel.Input, CreateWorkerAvatarViewModel.Output> {
    enum Input {
        case viewDidLoad
        case confirm
        case updateImage(_ image: UIImage?)
        case tapChooseImage
    }
    
    struct Output: VMOutPut {
        var didConfirmImage: (Worker) -> Void
        var image: (UIImage?) -> Void
        var chooseImage: () -> Void
        
    }
    
    private var genericAccount: Worker
    
    init(genericAccount: Worker) {
        self.genericAccount = genericAccount
    }
    
    override func handle(_ input: Input) {
        switch input {
        case .viewDidLoad:
            output.image(genericAccount.avatarImage)
        case .confirm:
            output.didConfirmImage(genericAccount)
        case .updateImage(let image):
            genericAccount.set(avatar: image)
            output.image(genericAccount.avatarImage)
        case .tapChooseImage:
            output.chooseImage()
        }
    }
}
