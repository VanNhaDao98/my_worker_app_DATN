//
//  DegreeRepo.swift
//  Domain
//
//  Created by Dao Van Nha on 04/11/2023.
//

import Foundation
import PromiseKit

public protocol DegreeRepo {
    func getDegree() -> Promise<[Degree]>
}
