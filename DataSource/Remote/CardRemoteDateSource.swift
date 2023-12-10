//
//  CardRemoteDateSource.swift
//  DataSource
//
//  Created by Dao Van Nha on 26/11/2023.
//

import Foundation
import PromiseKit
import FirebaseDatabase

struct CardRemoteDateSource {
    public init() {}
    
    func createCard(card: CardModel) -> Promise<Void> {
        Promise { resolver in
            let databaseRef = Database.database().reference()
            let cardRef = databaseRef.child("Card").child(card.code ?? "--")
            
            do {
                let jsonData = try JSONEncoder().encode(card)
                if let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                    cardRef.setValue(json) { error, _ in
                        guard let error = error else { return resolver.fulfill_()}
                        resolver.resolve(error)
                    }
                }
            } catch {
                resolver.reject(error)
            }
        }
    }
    
    func removeCard(id: String) -> Promise<Void> {
        Promise { resolver in
            let databaseRef = Database.database().reference()
            let cardRef = databaseRef.child("Card").child(id)
            
            cardRef.removeValue { error, _ in
                guard let error = error else { return resolver.fulfill_()}
                return resolver.reject(error)
            }
        }
    }
    
    func getCard(id: String) -> Promise<CardModel?> {
        Promise { resolver in
            let databaseRef = Database.database().reference()
            let cardRef = databaseRef.child("Card").child(id)
            
            cardRef.observeSingleEvent(of: .value, with: { snapshot in
                guard snapshot.exists() else { return resolver.fulfill( nil) }
                
                guard let data = snapshot.value as? [String: Any] else { return resolver.fulfill(nil)}
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let card = try JSONDecoder().decode(CardModel.self, from: jsonData)
                    resolver.fulfill(card)
                } catch {
                    resolver.reject(error)
                }
            }){ (error) in
                resolver.reject(error)
            }
        }
    }
    
    func createWellet(id: String, model: WalletModel) -> Promise<Void> {
        Promise { resolver in
            let databaseRef = Database.database().reference()
            let welletRef = databaseRef.child("Wallet").child(id)
            
            do {
                let jsonEncoder = JSONEncoder()
                let jsondata = try jsonEncoder.encode(model)
                
                if let json = try JSONSerialization.jsonObject(with: jsondata) as? [String: Any] {
                    welletRef.setValue(json) { error, _ in
                        guard let error = error else { return resolver.fulfill_()}
                        resolver.reject(error)
                    }
                }
            } catch {
                resolver.reject(error)
            }
            
        }
    }
    
    func updateWellet(id: String, model: WalletModel) -> Promise<Void> {
        Promise { resolver in
            let databaseRef = Database.database().reference()
            let welletRef = databaseRef.child("Wallet").child(id)
            do {
                let jsonEncoder = JSONEncoder()
                let jsondata = try jsonEncoder.encode(model)
                
                if let json = try JSONSerialization.jsonObject(with: jsondata) as? [String: Any] {
                    welletRef.setValue(json) { error, _ in
                        guard let error = error else { return resolver.fulfill_()}
                        resolver.reject(error)
                    }
                }
            } catch {
            }
        }
    }
    
    func getWellet(id: String) -> Promise<WalletModel?> {
        Promise { resolver in
            let databaseRef = Database.database().reference()
            let welletRef = databaseRef.child("Wallet").child(id)
            
            welletRef.observe(.value, with: { snapshot in
                guard snapshot.exists() else { return resolver.fulfill(nil) }
                guard let data = snapshot.value as? [String: Any] else { return resolver.fulfill(nil) }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    let wallet = try JSONDecoder().decode(WalletModel.self, from: jsonData)
                    resolver.fulfill(wallet)
                    NotificationCenter.default.post(name: NSNotification.Name("wallet"), object: wallet.toDomain())
                } catch {
                    resolver.fulfill(nil)
                }
            }) { error in
                resolver.reject(error)
            }
        }
    }
    
}
