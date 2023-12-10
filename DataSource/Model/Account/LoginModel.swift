//
//  LoginModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 29/10/2023.
//

import Foundation
import Domain

struct LoginModel {
    var email: String?
    var password: String?
}

extension LoginModel: DomainMapper {
    typealias E = Login
    
    static func from(model: Login) -> LoginModel {
        return .init(email: model.email,
                     password: model.password)
    }
    
    func toDomain() -> Login {
        .init(email: email ?? "",
              password: password ?? "")
    }
    
}
