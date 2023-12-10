//
//  UploadFileUseCase.swift
//  Domain
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation
import UIKit
import PromiseKit
import Resolver

public protocol IUploadFileUseCase {
    func uploadImage(image: UIImage?) -> Promise<URL?>
}

public struct UploadFileUseCase: IUploadFileUseCase {
    
    @Injected
    private var repo: UpLoadFileRepo
    
    public init() {}
    
    public func uploadImage(image: UIImage?) -> Promise<URL?> {
        repo.uploadImage(image: image)
    }
}
