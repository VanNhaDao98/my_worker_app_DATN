//
//  AccountDataSourceImpl.swift
//  DataSource
//
//  Created by Dao Van Nha on 29/10/2023.
//

import Foundation
import Domain
import PromiseKit
import UIKit

public class AccountDataSourceImpl: BaseRepo, CreateAccountRepo {
    
    private var dataSource = AccountRemoteDataSource()
    
    private var dbSource = DataBaseRemoteDataSource()
    
    public func login(model: Login) -> Promise<Account> {
        dataSource.login(model: LoginModel.from(model: model)).map({
            $0.toDomain()
        })
    }
    
    public func logout() -> Promise<Void> {
        dataSource.logout()
    }
    
    public func resetPassword(email: String) -> Promise<Void> {
        dataSource.resetPassword(email: email)
    }
    
    public func updatePassword(password: String) -> Promise<Void> {
        dataSource.updatePassword(password: password)
    }
    
    public func create(model: Login) -> Promise<Account> {
        dataSource.createAccount(model: LoginModel.from(model: model)).map({
            $0.toDomain()
        })
    }
    
    public func getCurrentAccount() -> Promise<Account?> {
        dataSource.getCurrentAccount().map { model in
            if let model = model {
                return model.toDomain()
            }
            return nil
        }
    }
    
    public func updateAccount(account: Account) -> Promise<Void> {
        dataSource.updateAccount(imgUrl: account.photoUrl,
                                 displayName: account.displayName)
    }
    
    public func createGenericAccount(model: Worker) -> Promise<Void> {
        dbSource.createCustomer(regist: WorkerModel.from(model: model))
    }
    
    public func genericAccount(id: String) -> Promise<Worker?> {
        dbSource.genericAccount(id: id).map {
            $0?.toDomain()
        }
    }
    
    public func createWorkerGeneric(account: Worker) -> Promise<Void> {
        dbSource.createGenericWorker(account: WorkerModel.from(model: account))
    }
    
    public func createDegree(id: String, degrees: [AccountDregee]) -> Promise<Void> {
        dbSource.createDegree(uid: id, degrees: degrees.map({ AccountDegreeModel.from(model: $0)}))
    }
    
    public func getDetailWorker(id: String) -> Promise<Worker?> {
        dbSource.getDetailWorker(id: id).map { model in
            model?.toDomain()
        }
    }
    
    public func getDegrees(id: String) -> Promise<[AccountDregee]> {
        dbSource.getDetailDegree(id: id).map { model in
            model.map({ $0.toDomain() })
        }
    }
    public func updateStatus(account: Worker) -> Promise<Void> {
        dbSource.setStatusWorker(model: WorkerModel.from(model: account))
    }
    
    public func getRates(workerId: String) -> Promise<[Rate]> {
        dbSource.getListRate(workerId: workerId).map({
            $0.map { model in
                model.toDomain()
            }
        })
    }
    
    public func createMaterials(workerId: String, material: [Material]) -> Promise<Void> {
        dbSource.createMaterials(workerId: workerId, materials: material.map({ MaterialModel.from(model: $0) }))
    }
    
    public func getMaterials(workerId: String) -> Promise<[Material]> {
        dbSource.getMaterial(id: workerId).map { models in
            models.map({ $0.toDomain()})
        }
    }
}
