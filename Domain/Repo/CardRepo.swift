//
//  CardRepo.swift
//  Domain
//
//  Created by Dao Van Nha on 26/11/2023.
//

import Foundation
import PromiseKit

public protocol CardRepo {
    func createCard(card: Card) -> Promise<Void>
    func removeCard(id: String) -> Promise<Void>
    func getCard(id: String) -> Promise<Card?>
    
    func createWallet(id: String, data: Wallet) -> Promise<Void>
    
    func updateWallet(id: String, data: Wallet) -> Promise<Void>
    
    func getWallet(id: String) -> Promise<Wallet>
}
