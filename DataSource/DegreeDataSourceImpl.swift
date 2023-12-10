//
//  DegreeDataSourceImpl.swift
//  DataSource
//
//  Created by Dao Van Nha on 04/11/2023.
//

import Foundation
import Domain
import PromiseKit

public class DegreeDataSourceImpl: BaseRepo, DegreeRepo {
    
    private var dataSource: DataBaseRemoteDataSource = .init()
    
    public func getDegree() -> Promise<[Degree]> {
        dataSource.getDegree().map { models in
            models.map({ $0.toDomain()})
        }
    }
}
