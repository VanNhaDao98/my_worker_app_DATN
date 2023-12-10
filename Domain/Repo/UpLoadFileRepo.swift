//
//  UpLoadFileRepo.swift
//  Domain
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation
import UIKit
import PromiseKit

public protocol UpLoadFileRepo {
    func uploadImage(image: UIImage?) -> Promise<URL?>
}
