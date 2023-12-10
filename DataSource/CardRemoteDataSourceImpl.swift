//
//  CardRemoteDataSourceImpl.swift
//  DataSource
//
//  Created by Dao Van Nha on 26/11/2023.
//

import Foundation
import Domain
import PromiseKit

public class CardRemoteDataSourceImpl: BaseRepo, CardRepo {
    
    private var dataSource: CardRemoteDateSource = .init()
    
    public func createCard(card: Card) -> Promise<Void> {
        dataSource.createCard(card: CardModel.from(model: card))
    }
    
    public func removeCard(id: String) -> Promise<Void> {
        dataSource.removeCard(id: id)
    }
    
    public func getCard(id: String) -> Promise<Card?> {
        dataSource.getCard(id: id).map({
            $0?.toDomain()
        })
    }
    
    public func createWallet(id: String, data: Wallet) -> Promise<Void> {
        dataSource.createWellet(id: id, model: WalletModel.from(model: data))
    }
    
    public func updateWallet(id: String, data: Wallet) -> Promise<Void> {
        dataSource.updateWellet(id: id, model: WalletModel.from(model: data))
    }
    
    public func getWallet(id: String) -> Promise<Wallet> {
        dataSource.getWellet(id: id).map {
            $0?.toDomain() ?? Wallet(totalMoney: 0)
        }
    }
}
