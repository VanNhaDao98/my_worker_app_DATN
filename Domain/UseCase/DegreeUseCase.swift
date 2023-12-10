//
//  DegreeUseCase.swift
//  Domain
//
//  Created by Dao Van Nha on 04/11/2023.
//

import Foundation
import PromiseKit
import Resolver

public protocol IDegreeUseCase {
    func getDegree() -> Promise<[Degree]>
}

public struct DegreeUseCase: IDegreeUseCase {
    @Injected
    private var repo: DegreeRepo
    
    public init() {}
    
    public func getDegree() -> Promise<[Degree]> {
        repo.getDegree()
    }
}
