//
//  Account.swift
//  Domain
//
//  Created by Dao Van Nha on 01/11/2023.
//

import Foundation

public enum AccountError: Error {
    case error(String)
}

public struct Account: DomainModel {
    public private(set) var uid: String = ""
    public private(set) var email: String = ""
    public private(set) var displayName: String = ""
    public private(set) var photoUrl: URL?
    
    public init() {}
    
    public init(uid: String,
                email: String,
                displayName: String,
                photoUrl: URL?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.photoUrl = photoUrl
    }
}
extension Account {
    
    public mutating func set(displayName: String) {
        self.displayName = displayName
    }
    
    public mutating func set(photoUrl: URL?) {
        self.photoUrl = photoUrl
    }
}
