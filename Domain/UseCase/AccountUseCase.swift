//
//  AccountUseCase.swift
//  Domain
//
//  Created by Dao Van Nha on 29/10/2023.
//

import Foundation
import Resolver
import PromiseKit
import UIKit

public protocol IAccountUseCase {
    func login(model: Login) -> Promise<Account>
    
    func logout() -> Promise<Void>
    
    func resetPassword(email: String) -> Promise<Void>
    
    func updatePassword(password: String) -> Promise<Void>
    
    func create(model: Login) -> Promise<Account>
    
    func getCurrentAccount() -> Promise<Account?>
    
    func updateAccount(account: Account) -> Promise<Void>
    
    func createGenericAccount(model: Worker) -> Promise<Void>
    
    func genericAccount(id: String) -> Promise<Worker?>
    
    func getJobs() -> Promise<[Job]>
    
    func createWorkerGeneric(account: Worker) -> Promise<Void>
    
    func createDegree(id: String, degrees: [AccountDregee]) -> Promise<Void>
    
    func getDetailWorker(id: String) -> Promise<Worker?>
    
    func getDegrees(id: String) -> Promise<[AccountDregee]>
    
    func updateStatus(account: Worker) -> Promise<Void>
    
    
    func getRates(workerId: String) -> Promise<[Rate]>
    
    func createMaterial(workerId: String, material: [Material]) -> Promise<Void>
    
    func getMaterials(workerId: String) -> Promise<[Material]>
}

public struct AccountUseCase: IAccountUseCase {
    
    public init() {}
    
    @Injected
    private var repo: CreateAccountRepo
    
    @Injected
    private var uploadFileRepo: UpLoadFileRepo
    
    @Injected
    private var jobRepo: JobRepo

    public func login(model: Login) -> Promise<Account> {
        repo.login(model: model)
    }
    
    public func logout() -> Promise<Void> {
        repo.logout()
    }
    
    public func resetPassword(email: String) -> Promise<Void> {
        repo.resetPassword(email: email)
    }
    
    public func updatePassword(password: String) -> Promise<Void> {
        repo.updatePassword(password: password)
    }
    
    public func create(model: Login) -> Promise<Account> {
        repo.create(model: model)
    }
    
    public func getCurrentAccount() -> Promise<Account?> {
        repo.getCurrentAccount()
    }
    
    public func updateAccount(account: Account) -> Promise<Void> {
        return repo.updateAccount(account: account)
    }
    
    public func createGenericAccount(model: Worker) -> Promise<Void> {
        repo.createGenericAccount(model: model)
    }
    
    public func genericAccount(id: String) -> Promise<Worker?> {
        repo.genericAccount(id: id)
    }

    public func getJobs() -> Promise<[Job]> {
        jobRepo.getJobs()
    }
    
    public func createWorkerGeneric(account: Worker) -> Promise<Void> {
        repo.createWorkerGeneric(account: account)
    }
    
    public func createDegree(id: String, degrees: [AccountDregee]) -> Promise<Void> {
        repo.createDegree(id: id, degrees: degrees)
    }
    
    public func getDetailWorker(id: String) -> Promise<Worker?> {
        return repo.getDetailWorker(id: id)
    }
    
    public func getDegrees(id: String) -> Promise<[AccountDregee]> {
        repo.getDegrees(id: id)
    }
    
    public func updateStatus(account: Worker) -> Promise<Void> {
        repo.updateStatus(account: account)
    }
    
    public func getRates(workerId: String) -> Promise<[Rate]> {
        repo.getRates(workerId: workerId)
    }
    
    public func createMaterial(workerId: String, material: [Material]) -> Promise<Void> {
        repo.createMaterials(workerId: workerId, material: material)
    }
    
    public func getMaterials(workerId: String) -> Promise<[Material]> {
        repo.getMaterials(workerId: workerId)
    }
    
}
