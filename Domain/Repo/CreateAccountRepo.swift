//
//  LoginRepo.swift
//  Domain
//
//  Created by Dao Van Nha on 29/10/2023.
//

import Foundation
import PromiseKit
import UIKit

public protocol CreateAccountRepo {
    func login(model: Login) -> Promise<Account>
    
    func logout() -> Promise<Void>
    
    func resetPassword(email: String) -> Promise<Void>
    
    func updatePassword(password: String) -> Promise<Void>
    
    func create(model: Login) -> Promise<Account>
    
    func getCurrentAccount() -> Promise<Account?>
    
    func updateAccount(account: Account) -> Promise<Void>
    
    func createGenericAccount(model: Worker) -> Promise<Void>
    
    func genericAccount(id: String) -> Promise<Worker?>

    func createWorkerGeneric(account: Worker) -> Promise<Void>
    
    func createDegree(id: String, degrees: [AccountDregee]) -> Promise<Void>
    
    func getDetailWorker(id: String) -> Promise<Worker?>
    
    func getDegrees(id: String) -> Promise<[AccountDregee]>
    
    func updateStatus(account: Worker) -> Promise<Void>
    
    func getRates(workerId: String) -> Promise<[Rate]>
    
    func createMaterials(workerId: String, material: [Material]) -> Promise<Void>
    
    func getMaterials(workerId: String) -> Promise<[Material]>
}
