//
//  AccountUtils.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 05/11/2023.
//

import Foundation
import Domain

class AccountUtils {
    
    public static var shard = AccountUtils()
    
    private var account: Account?
    
    private var genericAccount: Worker?
    
    public func setAccount(account: Account?) {
        self.account = account
    }
    
    public func getAccount() -> Account? {
        return account
    }
    
    public func reset() {
        account = nil
        genericAccount = nil
    }
    
    public func setGenericAccount(account: Worker?) {
        self.genericAccount = account
    }
    
    public func getGenericAccout() -> Worker? {
        return genericAccount
    }
}
