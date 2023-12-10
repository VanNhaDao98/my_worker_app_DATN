//
//  LoginRemoteDataSource.swift
//  DataSource
//
//  Created by Dao Van Nha on 29/10/2023.
//

import UIKit
import Foundation
import FirebaseAuth
import PromiseKit

struct AccountRemoteDataSource {
    
    func login(model: LoginModel) -> Promise<AccountModel> {
        return Promise { resolver in
            Auth.auth().signIn(withEmail: model.email ?? "",
                               password: model.password ?? "") { result, error in
                if let error = error {
                    return resolver.reject(error)
                } else {
                    let account = AccountModel(uid: result?.user.uid,
                                               email: result?.user.email,
                                               displayName: result?.user.displayName,
                                               photoUrl: result?.user.photoURL)
                    return resolver.fulfill(account)
                }
            }
        }
    }
    
    func logout() -> Promise<Void> {
        return Promise { resolver in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                resolver.fulfill_()
            } catch let signOutError as NSError {
                return resolver.reject(signOutError)
            }
        }
    }
    
    func resetPassword(email: String) -> Promise<Void> {
        return Promise { resolver in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    return resolver.reject(error)
                } else {
                    return resolver.fulfill_()
                }
            }
        }
    }
    
    func updatePassword(password: String) -> Promise<Void> {
        return Promise { resolver in
            Auth.auth().currentUser?.updatePassword(to: password) { error in
                if let error = error {
                    return resolver.reject(error)
                } else {
                    return resolver.fulfill_()
                }
            }
        }
    }
    
    func createAccount(model: LoginModel) -> Promise<AccountModel> {
        return Promise { resolver in
            Auth.auth().createUser(withEmail: model.email ?? "",
                                   password: model.password ?? "") { result, error in
                if let error = error {
                    return resolver.reject(error)
                } else {
                    let account = AccountModel(uid: result?.user.uid,
                                               email: result?.user.email,
                                               displayName: result?.user.displayName,
                                               photoUrl: result?.user.photoURL)
                    return resolver.fulfill(account)
                }
            }
        }
    }
    
    func getCurrentAccount() -> Promise<AccountModel?> {
        return Promise { resolver in
            if let user = Auth.auth().currentUser {
                let data = AccountModel(uid: user.uid,
                                        email: user.email,
                                        displayName: user.displayName,
                                        photoUrl: user.photoURL)
                resolver.fulfill(data)
            } else {
                resolver.fulfill(nil)
            }
        }
    }
    
    func updateAccount(imgUrl: URL?,
                       displayName: String) -> Promise<Void> {
        return Promise { resolver in
            if let user = Auth.auth().currentUser {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.photoURL = imgUrl
                
                changeRequest.commitChanges { error in
                    guard let error = error else { return resolver.fulfill_()}
                    resolver.reject(error)
                }
            }
        }
    }
}

