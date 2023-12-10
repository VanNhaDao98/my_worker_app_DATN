//
//  UploadFileDataSourceImpl.swift
//  DataSource
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation
import Domain
import UIKit
import PromiseKit

public class UploadFileDataSourceImpl: BaseRepo, UpLoadFileRepo {
    
    private var dataSource: UploadFileRemoteDataSource = .init()
    
    public func uploadImage(image: UIImage?) -> Promise<URL?> {
        dataSource.uploadImage(image: image)
    }
    
}
