//
//  CardUseCase.swift
//  Domain
//
//  Created by Dao Van Nha on 26/11/2023.
//

import Foundation
import PromiseKit
import Resolver

public protocol ICardUseCase {
    func createCard(card: Card) -> Promise<Void>
    func removeCard(id: String) -> Promise<Void>
    func getCard(id: String) -> Promise<Card?>
    
    func createWallet(id: String, data: Wallet) -> Promise<Void>
    
    func updateWallet(id: String, data: Wallet) -> Promise<Void>
    
    func getWallet(id: String) -> Promise<Wallet>
}

public struct CardUseCase: ICardUseCase {
    
    
    public init() {
    }
    
    @Injected
    private var repo: CardRepo
    
    public func createCard(card: Card) -> Promise<Void> {
        repo.createCard(card: card)
    }
    
    public func removeCard(id: String) -> Promise<Void> {
        repo.removeCard(id: id)
    }
    
    public func getCard(id: String) -> Promise<Card?> {
        repo.getCard(id: id)
    }
    
    public func createWallet(id: String, data: Wallet) -> Promise<Void> {
        repo.createWallet(id: id, data: data)
    }
    
    public func updateWallet(id: String, data: Wallet) -> Promise<Void> {
        repo.updateWallet(id: id, data: data)
    }
    
    public func getWallet(id: String) -> Promise<Wallet> {
        repo.getWallet(id: id)
    }
    
}
