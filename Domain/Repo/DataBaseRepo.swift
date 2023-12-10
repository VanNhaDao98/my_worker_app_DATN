//
//  DataBaseRepo.swift
//  Domain
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation
import PromiseKit

public protocol DataBaseRepo {
    func createDemo()
    
    func readDemo() -> Promise<String>
    
    func getProvince() -> Promise<[Province]>
    
    func getDistrict(provinceId: Int) -> Promise<[District]>
    
    func getWard(provinceId: Int, districtId: Int) -> Promise<[Ward]>
}
