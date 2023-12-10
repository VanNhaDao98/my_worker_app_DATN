//
//  AddressUseCase.swift
//  Domain
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation
import PromiseKit
import Resolver

public protocol IAddressUseCase {
    
    func getProvince() -> Promise<[Province]>
    
    func getDistrict(provinceId: Int) -> Promise<[District]>
    
    func getWard(provinceId: Int, districtId: Int) -> Promise<[Ward]>
}

public struct AddressUseCase: IAddressUseCase {
    
    @Injected
    private var repo: DataBaseRepo
    
    public init() {}
    
    public func getProvince() -> Promise<[Province]> {
        repo.getProvince()
    }
    
    public func getDistrict(provinceId: Int) -> Promise<[District]> {
        repo.getDistrict(provinceId: provinceId)
    }

    public func getWard(provinceId: Int, districtId: Int) -> Promise<[Ward]> {
        repo.getWard(provinceId: provinceId, districtId: districtId)
    }
}
