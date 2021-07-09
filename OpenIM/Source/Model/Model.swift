//
//  Model.swift
//  OpenIM
//
//  Created by Snow on 2021/6/10.
//

import Foundation

public enum OIMConversationType: Int, Codable {
    case c2c = 1
    case group = 2
}

public enum OIMGender: Int, Codable {
    case unknown = 0
    case male = 1
    case female = 2
}

public class OIMUser: Codable, Hashable {
    public var uid = ""
    public var name = ""
    public var icon: URL?
    public var gender = OIMGender.unknown
    public var mobile = ""
    public var birth = ""
    public var email = ""
    public var ex = ""
    public var comment = ""
    public var isInBlackList = false
    public var isFriend = false
    
    public init() {}
    
    private enum CodingKeys: String, CodingKey {
        case uid, name, icon, gender, mobile, birth, email, ex, comment, isInBlackList
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        name = try container.decode(String.self, forKey: .name)
        icon = try? container.decode(URL.self, forKey: .icon)
        gender = try container.decode(OIMGender.self, forKey: .gender)
        mobile = try container.decode(String.self, forKey: .mobile)
        birth = try container.decode(String.self, forKey: .birth)
        email = try container.decode(String.self, forKey: .email)
        ex = try container.decode(String.self, forKey: .ex)
        if let value = try? container.decode(String.self, forKey: .comment) {
            comment = value
        }
        if let value = try? container.decode(Int.self, forKey: .isInBlackList) {
            isInBlackList = value != 0
        }
    }
    
    public static func == (lhs: OIMUser, rhs: OIMUser) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    public func hash(into hasher: inout Hasher) {
        uid.hash(into: &hasher)
    }
    
    public func getName() -> String {
        return comment.isEmpty ? name : comment
    }
}

public class OIMFriendApplicationModel: Decodable {
    public enum Flag: Int, Decodable {
        case reject = -1
        case `default` = 0
        case agree = 1
    }
    
    public var info = OIMUser()
    public var applyTime = TimeInterval.zero
    public var reqMessage = ""
    public var flag = Flag.default
    
    private enum CodingKeys: String, CodingKey {
        case applyTime,
             reqMessage,
             flag
    }
    
    required public init(from decoder: Decoder) throws {
        info = try OIMUser(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(String.self, forKey: .applyTime),
           let doubleValue = TimeInterval(value) {
            applyTime = doubleValue
        }
        reqMessage = try container.decode(String.self, forKey: .reqMessage)
        flag = try container.decode(Flag.self, forKey: .flag)
    }
}

public struct OIMCheckFriend: Decodable {
    public let uid: String
    public let flag: Int
}
