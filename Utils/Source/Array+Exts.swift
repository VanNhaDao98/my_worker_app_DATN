//
//  Array+Exts.swift
//  Utils
//
//  Created by Dao Van Nha on 16/10/2023.
//

import Foundation

public protocol StringFilterable {
    var filterString: String? { get }
}

public extension Array {
    func filter(by query: String?, comparingBy: ((Element) -> String?)) -> [Element] {
        guard let query = query?.trim(), query.count > 0 else {
            return self
        }
        
        var output = [Element]()
        for element in self {
            guard let compareText = comparingBy(element) else {
                continue
            }
            
            if compareText.removeAccents().lowercased().contains(query.removeAccents().lowercased()) {
                output.append(element)
            }
        }
        
        return output
    }
    
    func filter(by query: String?) -> [Element] where Element: StringFilterable {
        filter(by: query, comparingBy: { $0.filterString })
    }
}
