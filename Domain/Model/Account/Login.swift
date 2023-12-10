//
//  Login.swift
//  Domain
//
//  Created by Dao Van Nha on 29/10/2023.
//

import Foundation

public struct Login: DomainModel {
    public private(set) var email: String = ""
    public private(set) var password: String = ""
    
    public private(set) var confirmPassword: String = ""
    
    public init(email: String = "",
                password: String = "") {
        self.email = email
        self.password = password
    }
}

extension Login {
    
    public mutating func set(email: String?) {
        self.email = email ?? ""
    }
    
    public mutating func set(password: String?) {
        self.password = password ?? ""
    }
    public mutating func set(confirmPassword: String?) {
        self.confirmPassword = confirmPassword ?? ""
    }

}
