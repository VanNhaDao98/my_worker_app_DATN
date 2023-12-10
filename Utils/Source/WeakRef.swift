//
//  WeakRef.swift
//  Utils
//
//  Created by Dao Van Nha on 14/10/2023.
//

import Foundation

public class WeakRef<Object: AnyObject> {
    public weak var object: Object?
    
    public init(object: Object? = nil) {
        self.object = object
    }
}
