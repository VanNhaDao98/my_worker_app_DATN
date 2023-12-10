//
//  JobDataSourceImpl.swift
//  DataSource
//
//  Created by Dao Van Nha on 04/11/2023.
//

import Foundation
import Domain
import PromiseKit

public class JobDataSourceImpl: BaseRepo, JobRepo {
    
    private var dataSource: DataBaseRemoteDataSource = .init()
    
    public func getJobs() -> Promise<[Job]> {
        dataSource.getJobs().map { models in
            models.map({ $0.toDomain() })
        }
    }
}
