//
//  DataSourceModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 29/10/2023.
//

import Foundation
import Domain

protocol DomainMapper {
    
    associatedtype E: DomainModel
    
    func toDomain() -> E
    
    static func from(model: E) -> Self
}

extension DomainMapper {
    
    public static func from(model: E?) -> Self? {
        guard let model = model else { return nil }
        return from(model: model)
    }
}
