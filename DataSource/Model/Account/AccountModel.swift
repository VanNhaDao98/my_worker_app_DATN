//
//  AccountModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 01/11/2023.
//

import Foundation
import Domain

struct AccountModel {
    var uid: String?
    var email: String?
    var displayName: String?
    var photoUrl: URL?
}

extension AccountModel: DomainMapper {
    
    typealias E = Account
    
    static func from(model: Account) -> AccountModel {
        .init(uid: model.uid,
              email: model.email,
              displayName: model.displayName,
              photoUrl: model.photoUrl)
    }
    
    func toDomain() -> Account {
        .init(uid: uid ?? "",
              email: email ?? "",
              displayName: displayName ?? "",
              photoUrl: photoUrl)
    }
}
