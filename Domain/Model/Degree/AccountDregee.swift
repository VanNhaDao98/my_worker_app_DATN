//
//  AccountDregee.swift
//  Domain
//
//  Created by Dao Van Nha on 03/11/2023.
//

import Foundation
import UIKit

public enum DegreeLevel: String, CaseIterable {
    case excellent
    case distinction
    case good
    case medium
    
    public init?(rawValue: String) {
        switch rawValue {
        case "excellent":
            self = .excellent
        case "good":
            self = .good
        case "distinction":
            self = .distinction
        default:
            self = .medium
        }
    }
    
    public var title: String {
        switch self {
        case .excellent:
            return "Xuất sắc"
        case .good:
            return "Khá"
        case .distinction:
            return "Giỏi"
        case .medium:
            return "Trung bình khá"
        }
    }
}

public struct AccountDregee: DomainModel {
    public private(set) var id: String = ""
    public private(set) var university: String = ""
    public private(set) var profile: String = ""
    public private(set) var level: DegreeLevel = .good
    public private(set) var startTime: Date?
    public private(set) var endTime: Date?
    public private(set) var degree: Degree = .init()
    
    public var imageUrl: URL?
    
    public init() {}
    
    public init(id: String ,
                university: String,
                level: DegreeLevel,
                startTime: Date?,
                endTime: Date?,
                degree: Degree,
                profile: String) {
        self.id = id
        self.university = university
        self.level = level
        self.startTime = startTime
        self.endTime = endTime
        self.degree = degree
        self.profile = profile
    }
}

extension AccountDregee {
    mutating public func setuniversity(_ name: String?) {
        self.university = name ?? ""
    }
    mutating public func setProfile(_ name: String?) {
        self.profile = name ?? ""
    }
    
    mutating public func setLevel(_ level: DegreeLevel) {
        self.level = level
    }
    
    mutating public func setDegree(_ degree: Degree) {
        self.degree = degree
    }
    
    mutating public func setStartTime(_ time: Date?) {
        self.startTime = time
    }
    
    mutating public func setEndTime(_ time: Date?) {
        self.endTime = time
    }
    
    mutating public func setUrlImage(_ url: URL?) {
        self.imageUrl = url
    }

}
