//
//  RegistAccountModel.swift
//  DataSource
//
//  Created by Dao Van Nha on 01/11/2023.
//

import Foundation
import Domain

struct WorkerModel: Codable {
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
    var describe: String?
    var job: JobModel?
    var status: String?
    var price: Double?
    var jobLevel: Double?
    var jobSkill: String?
    var jobId: Int?
    
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
        case imageUrl = "image_url"
        case describe
        case job
        case status
        case price
        case jobLevel = "job_level"
        case jobSkill = "job_skill"
        case jobId = "job_id"
    }
}

extension WorkerModel:DomainMapper {
    typealias E = Worker
    
    func toDomain() -> Worker {
        return .init(avatarImage: nil,
                     dateOfBirth: birthDay == nil ? nil : Date(timeIntervalSince1970: birthDay!),
                     gender: nil,
                     fullName: fullName,
                     province: province?.toDomain(),
                     district: district?.toDomain(),
                     ward: ward?.toDomain(),
                     address: address,
                     phoneNumber: phoneNumber,
                     urlImage: URL(string: imageUrl ?? ""),
                     id: id ?? "",
                     describe: describe,
                     job: job?.toDomain(),
                     status: .init(rawValue: status ?? "") ?? .inActive,
                     price: price ?? 0,
                     jobLevel: jobLevel ?? 0,
                     skillDetail: jobSkill ?? "",
                     jobId: jobId ?? 0)
    }
    
    static func from(model: Worker) -> WorkerModel {
        .init(id: model.account?.uid ?? model.id,
              fullName: model.fullName,
              email: model.account?.email,
              birthDay: model.dateOfBirth?.timeIntervalSince1970,
              gender: model.gender?.rawValue,
              phoneNumber: model.phoneNumber,
              province: ProvinceModel.from(model: model.province),
              district: DistrictModel.from(model: model.district),
              ward: WardModel.from(model: model.ward),
              address: model.address,
              imageUrl: model.account?.photoUrl?.absoluteString,
              describe: model.describe,
              job: JobModel.from(model: model.job),
              status: model.status.rawValue,
              price: model.price,
              jobLevel: model.jobLevel,
              jobSkill: model.skillDetail,
              jobId: model.job?.id)
    }
}


