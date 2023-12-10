//
//  DataBaseUseCase.swift
//  Domain
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation
import PromiseKit
import Resolver

public protocol IDataBaseUseCase {
    func create()
    func readDemo() -> Promise<String>
}

public struct DataBaseUseCase: IDataBaseUseCase {
    
    @Injected
    private var repo: DataBaseRepo
    
    public init() {}
    
    public func create() {
        repo.createDemo()
    }
    
    public func readDemo() -> Promise<String> {
        repo.readDemo()
    }
}
