//
//  Persion.swift
//  Domain
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation
import UIKit

public enum Gender: String, CaseIterable {
    case male
    case female
    case orther
}

extension Gender {
    public var title: String {
        switch self {
        case .male:
            return "Nam"
        case .female:
            return "Nữ"
        case .orther:
            return "Khác"
        }
    }
}

public enum WorkerStatus: String {
    case active
    case inActive
    
    public init?(rawValue: String) {
        switch rawValue {
        case "active":
            self = .active
        default: self = .inActive
        }
    }
}

public struct Worker: DomainModel {
    public private(set) var id: String = ""
    public private(set) var avatarImage: UIImage?
    public private(set) var dateOfBirth: Date?
    public private(set) var gender: Gender?
    public private(set) var fullName: String?
    public private(set) var province: Province?
    public private(set) var district: District?
    public private(set) var ward: Ward?
    public private(set) var address: String?
    public private(set) var phoneNumber: String?
    public private(set) var describe: String?
    public private(set) var jobId: Int = 0
    
    public private(set) var urlImage: URL?
    
    public private(set) var account: Account?
    
    public private(set) var degree: [AccountDregee] = []
    
    public private(set) var job: Job?
    public private(set) var jobLevel: Double = 0
    public private(set) var skillDetail: String = ""
    
    public private(set) var status: WorkerStatus = .active
    
    public private(set) var price: Double = 0
    
    public private(set) var rates: [Rate] = []
    
    public private(set) var materials: [Material] = []
    
    public init() {}
    
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
                id: String,
                describe: String?,
                job: Job?,
                status: WorkerStatus,
                price: Double,
                jobLevel: Double,
                skillDetail: String,
                jobId: Int) {
        self.jobLevel = jobLevel
        self.skillDetail = skillDetail
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
        self.describe = describe
        self.job = job
        self.status = status
        self.price = price
        self.jobId = jobId
    }
}

extension Worker {
    
    public mutating func setJobLevel(level: Double) {
        self.jobLevel = level
        if let job = job {
            self.caculatePrice(job: job, level: level)
        }
    }
    
    public mutating func setJobSkillDetail(skill: String) {
        self.skillDetail = skill
    }
    
    public mutating func updateMaterial(index: Int, marerial: Material) {
        self.materials[index] = marerial
    }
    
    public mutating func setMaterials(materials: [Material]) {
        self.materials = materials
    }
    
    public mutating func setRate(rates: [Rate]) {
        self.rates = rates
    }
    
    public mutating func setStatus(_ isOn: Bool) {
        self.status = isOn ? .active : .inActive
    }
    
    public mutating func set(job: Job?) {
        self.job = job
        let keys: [Double] = job?.type.practice.compactMap({ $0.key}) ?? []
        self.jobLevel = keys.min() ?? 0
        if let job = job {
            self.caculatePrice(job: job, level: keys.min() ?? 0)
        }
    }
    
    public mutating func set(avatar: UIImage?) {
        self.avatarImage = avatar
    }
    
    public mutating func set(dateOfbird: Date?) {
        self.dateOfBirth = dateOfbird
    }
    
    public mutating func set(gender: Gender) {
        self.gender = gender
    }
    
    public mutating func set(fullName: String?) {
        self.fullName = fullName
        self.account?.set(displayName: fullName ?? "")
    }
    
    public mutating func set(province: Province?) {
        self.province = province
    }
    
    public mutating func set(district: District?) {
        self.district = district
    }
    
    public mutating func set(ward: Ward?) {
        self.ward = ward
    }
    
    public mutating func set(address: String?) {
        self.address = address
    }
    
    public mutating func set(phoneNumber: String?) {
        self.phoneNumber = phoneNumber
    }
    
    public mutating func set(account: Account?) {
        self.account = account
    }
    
    public mutating func set(describe: String?) {
        self.describe = describe
    }
    
    public mutating func set(urlImage: URL?) {
        self.account?.set(photoUrl: urlImage)
    }
    
    public mutating func updateDegree(_ degree: AccountDregee) {
        self.degree.append(degree)
    }
    
    public mutating func deleteDegree(_ index: Int) {
        self.degree.remove(at: index)
    }
    
    public mutating func setDegree(index: Int, degree: AccountDregee) {
        self.degree[index] = degree
    }
    
    public mutating func setAccountDegree(degree: [AccountDregee]) {
        self.degree = degree
    }
    public mutating func caculatePrice(job: Job, level: Double) {
        switch job.type {
            
        case .water:
            self.price = 25000
        case .electricity:
            self.price = 27000
        case .refrigeration:
            self.price = 30000
        case .orther:
            self.price = 0
        case .turner:
            switch level {
            case 2:
                self.price = 25000
            case 3:
                self.price = 27500
            case 4:
                self.price = 31000
            case 5:
                self.price = 35000
            case 6:
                self.price = 40000
            case 7:
                self.price = 46000
            case 8:
                self.price = 46000
            default:
                self.price = 0
            }
        case .machine:
            switch level {
            case 2:
                self.price = 25000
            case 3:
                self.price = 27500
            case 4:
                self.price = 31000
            case 5:
                self.price = 35000
            case 6:
                self.price = 40000
            case 7:
                self.price = 46000
            case 8:
                self.price = 46000
            default:
                self.price = 0
            }
        case .miller:
            switch level {
            case 2:
                self.price = 25000
            case 3:
                self.price = 27500
            case 4:
                self.price = 31000
            case 5:
                self.price = 35000
            case 6:
                self.price = 40000
            case 7:
                self.price = 46000
            case 8:
                self.price = 46000
            default:
                self.price = 0
            }
        case .planer:
            switch level {
            case 2:
                self.price = 25000
            case 3:
                self.price = 27500
            case 4:
                self.price = 31000
            case 5:
                self.price = 35000
            case 6:
                self.price = 40000
            case 7:
                self.price = 46000
            case 8:
                self.price = 46000
            default:
                self.price = 0
            }
        case .noun:
            switch level {
            case 2:
                self.price = 25000
            case 3:
                self.price = 27500
            case 4:
                self.price = 31000
            case 5:
                self.price = 35000
            case 6:
                self.price = 40000
            case 7:
                self.price = 46000
            case 8:
                self.price = 46000
            default:
                self.price = 0
            }
        case .farrier:
            switch level {
            case 2:
                self.price = 25000
            case 3:
                self.price = 27500
            case 4:
                self.price = 31000
            case 5:
                self.price = 35000
            case 6:
                self.price = 40000
            case 7:
                self.price = 46000
            case 8:
                self.price = 46000
            default:
                self.price = 0
            }
        case .welder:
            switch level {
            case 2:
                self.price = 25000
            case 3:
                self.price = 27500
            case 4:
                self.price = 31000
            case 5:
                self.price = 35000
            case 6:
                self.price = 40000
            case 7:
                self.price = 46000
            case 8:
                self.price = 46000
            default:
                self.price = 0
            }
        case .electricwelder:
            switch level {
            case 2:
                self.price = 25000
            case 3:
                self.price = 27500
            case 4:
                self.price = 31000
            case 5:
                self.price = 35000
            case 6:
                self.price = 40000
            case 7:
                self.price = 46000
            case 8:
                self.price = 46000
            default:
                self.price = 0
            }
        case .carpenter:
            switch level {
            case 2:
                self.price = 25000
            case 3:
                self.price = 27500
            case 4:
                self.price = 31000
            case 5:
                self.price = 35000
            case 6:
                self.price = 40000
            case 7:
                self.price = 46000
            case 8:
                self.price = 46000
            default:
                self.price = 0
            }
        case .thone:
            switch level {
            case 2:
                self.price = 25000
            case 3:
                self.price = 27500
            case 4:
                self.price = 31000
            case 5:
                self.price = 35000
            case 6:
                self.price = 40000
            case 7:
                self.price = 46000
            default:
                self.price = 0
            }

        case .betong:
            switch level {
            case 2:
                self.price = 25000
            case 3:
                self.price = 27500
            case 4:
                self.price = 31000
            case 5:
                self.price = 35000
            default:
                self.price = 0
            }

        case .cotthep:
            switch level {
            case 2:
                self.price = 25000
            case 3:
                self.price = 27500
            case 4:
                self.price = 31000
            case 5:
                self.price = 35000
            default:
                self.price = 0
            }
        case .sonvoi:
            switch level {
            case 2:
                self.price = 25000
            case 3:
                self.price = 27500
            case 4:
                self.price = 31000
            case 5:
                self.price = 35000
            default:
                self.price = 0
            }
        }
    }
}
