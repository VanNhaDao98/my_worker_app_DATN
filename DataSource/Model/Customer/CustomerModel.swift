//
//  RegistAccountModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 01/11/2023.
//

import Foundation
import Domain

struct CustomerModel: Codable {
    var id: String?
    var fullName: String?
    var email: String?
    var birthDay: TimeInterval?
    var gender: String?
    var phoneNumber: String?
    var province: ProvinceModel?
    var district: DistrictModel?
    var ward: WardModel?
    var address: String?
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case birthDay = "birth_day"
        case gender
        case phoneNumber = "phone_number"
        case province
        case district
        case ward
        case address
        case imageUrl
    }
}

extension CustomerModel:DomainMapper {
    typealias E = Customer
    
    func toDomain() -> Customer {
        return .init(avatarImage: nil,
                     dateOfBirth: birthDay == nil ? nil : Date(timeIntervalSince1970: birthDay!),
                     gender: nil,
                     fullName: fullName,
                     province: province?.toDomain(),
                     district: district?.toDomain(),
                     ward: ward?.toDomain(),
                     address: address,
                     phoneNumber: phoneNumber,
                     urlImage: imageUrl == nil ? nil : URL(string: imageUrl!),
                     id: id ?? "")
    }
    
    static func from(model: Customer) -> CustomerModel {
        .init()
    }
}


