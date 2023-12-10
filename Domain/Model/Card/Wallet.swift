//
//  Wallet.swift
//  Domain
//
//  Created by Dao Van Nha on 05/11/2023.
//

import Foundation

public struct Wallet: DomainModel {
    public private(set) var totalMoney: Double = 0
    
    public init(totalMoney: Double) {
        self.totalMoney = totalMoney
    }
    
    public mutating func recharge(_ amountMoney: Double) {
        self.totalMoney += amountMoney
    }
}
