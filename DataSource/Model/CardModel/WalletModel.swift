//
//  WalletModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 06/11/2023.
//

import Foundation
import Domain

struct WalletModel: Codable {
    var totolMoney: Double?
}

extension WalletModel: DomainMapper {
    typealias E = Wallet
    
    static func from(model: Wallet) -> WalletModel {
        .init(totolMoney: model.totalMoney)
    }
    
    func toDomain() -> Wallet {
        .init(totalMoney: totolMoney ?? 0)
    }
}
