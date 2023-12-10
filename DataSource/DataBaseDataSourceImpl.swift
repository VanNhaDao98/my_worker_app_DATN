//
//  DataBaseDataSourceImpl.swift
//  DataSource
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation
import Domain
import PromiseKit

public class DataBaseDataSourceImpl: BaseRepo, DataBaseRepo {
    
    private var dataSource: DataBaseRemoteDataSource = .init()
    
    public func createDemo() {
        dataSource.create()
    }
    
    public func readDemo() -> Promise<String> {
        dataSource.readDemo()
    }
    
    public func getProvince() -> Promise<[Province]> {
        dataSource.getProvince().map({ model in
            model.map({ $0.toDomain() })
        })
    }
    
    public func getDistrict(provinceId: Int) -> Promise<[District]> {
        dataSource.getDistrict(provinceId: provinceId).map({
            $0.map({ model in model.toDomain() })
        })
    }
    
    public func getWard(provinceId: Int, districtId: Int) -> Promise<[Ward]> {
        dataSource.getWard(provinceId: provinceId, districtId: districtId).map { list in
            list.map({ $0.toDomain()})
        }
    }
    
}
