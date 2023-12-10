//
//  JobRepo.swift
//  Domain
//
//  Created by Dao Van Nha on 04/11/2023.
//

import Foundation
import PromiseKit

public protocol JobRepo {
    func getJobs() -> Promise<[Job]>
}
