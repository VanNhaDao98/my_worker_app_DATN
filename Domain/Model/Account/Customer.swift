//
//  Persion.swift
//  Domain
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation
import UIKit

public struct Customer: DomainModel {
    public private(set) var avatarImage: UIImage?
    public private(set) var dateOfBirth: Date?
    public private(set) var gender: Gender?
    public private(set) var fullName: String?
    public private(set) var province: Province?
    public private(set) var district: District?
    public private(set) var ward: Ward?
    public private(set) var address: String?
    public private(set) var phoneNumber: String?
    
    public private(set) var urlImage: URL?
    
    
    public private(set) var id: String = ""
    
    
    public init() {}
    
    public init(id: String) {
        self.id = id
    }
    
    public init(avatarImage: UIImage?,
                dateOfBirth: Date?,
                gender: Gender?,
                fullName: String?,
                province: Province?,
                district: District?,
                ward: Ward?,
                address: String?,
                phoneNumber: String?,
                urlImage: URL?,
                id: String) {
        self.avatarImage = avatarImage
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.fullName = fullName
        self.province = province
        self.district = district
        self.ward = ward
        self.address = address
        self.phoneNumber = phoneNumber
        self.urlImage = urlImage
        self.id = id
    }
}
