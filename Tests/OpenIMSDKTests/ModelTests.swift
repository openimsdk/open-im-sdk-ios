import XCTest
@testable import OpenIMSDK

final class ModelTests: XCTestCase {
    func testUserInfoCoding() throws {
        let json = """
        {
            "userID": "u123",
            "nickname": "Alice",
            "faceURL": "https://example.com/avatar.png",
            "createTime": 1700000000,
            "globalRecvMsgOpt": 0
        }
        """.data(using: .utf8)!

        let user = try JSONDecoder().decode(OpenIMUserInfo.self, from: json)
        XCTAssertEqual(user.userID, "u123")
        XCTAssertEqual(user.nickname, "Alice")
        XCTAssertEqual(user.globalRecvMsgOpt, .receive)

        let encoded = try JSONEncoder().encode(user)
        let roundtrip = try JSONDecoder().decode(OpenIMUserInfo.self, from: encoded)
        XCTAssertEqual(roundtrip, user)
    }

    func testFriendInfoCoding() throws {
        let json = """
        {
            "ownerUserID": "u1",
            "userID": "u2",
            "nickname": "Bob",
            "remark": "My Friend Bob",
            "createTime": 1700000001
        }
        """.data(using: .utf8)!

        let friend = try JSONDecoder().decode(OpenIMFriendInfo.self, from: json)
        XCTAssertEqual(friend.userID, "u2")
        XCTAssertEqual(friend.remark, "My Friend Bob")
    }

    func testGroupInfoCoding() throws {
        let json = """
        {
            "groupID": "g100",
            "groupName": "Swift Developers",
            "groupType": 0,
            "memberCount": 42,
            "status": 0,
            "needVerification": 1
        }
        """.data(using: .utf8)!

        let group = try JSONDecoder().decode(OpenIMGroupInfo.self, from: json)
        XCTAssertEqual(group.groupID, "g100")
        XCTAssertEqual(group.groupName, "Swift Developers")
        XCTAssertEqual(group.groupType, .normal)
        XCTAssertEqual(group.memberCount, 42)
        XCTAssertEqual(group.status, .ok)
        XCTAssertEqual(group.needVerification, .allNeedVerification)
    }

    func testConversationInfoCoding() throws {
        let json = """
        {
            "conversationID": "c2c_u1_u2",
            "conversationType": 1,
            "userID": "u2",
            "showName": "Bob",
            "unreadCount": 3,
            "recvMsgOpt": 2,
            "isPinned": true
        }
        """.data(using: .utf8)!

        let conv = try JSONDecoder().decode(OpenIMConversationInfo.self, from: json)
        XCTAssertEqual(conv.conversationID, "c2c_u1_u2")
        XCTAssertEqual(conv.conversationType, .c2c)
        XCTAssertEqual(conv.unreadCount, 3)
        XCTAssertEqual(conv.recvMsgOpt, .notNotify)
        XCTAssertEqual(conv.isPinned, true)
    }

    func testMessageInfoCoding() throws {
        let json = """
        {
            "clientMsgID": "msg_001",
            "serverMsgID": "svr_001",
            "sendID": "u1",
            "recvID": "u2",
            "contentType": 101,
            "status": 2,
            "textElem": {
                "content": "Hello OpenIM Swift!"
            }
        }
        """.data(using: .utf8)!

        let msg = try JSONDecoder().decode(OpenIMMessageInfo.self, from: json)
        XCTAssertEqual(msg.clientMsgID, "msg_001")
        XCTAssertEqual(msg.contentType, .text)
        XCTAssertEqual(msg.status, .sendSuccess)
        XCTAssertEqual(msg.textElem?.content, "Hello OpenIM Swift!")
    }

    func testCustomAndLocationElementsCoding() throws {
        let locationJSON = """
        {
            "description": "Taipei 101",
            "longitude": 121.5654,
            "latitude": 25.0330
        }
        """.data(using: .utf8)!

        let location = try JSONDecoder().decode(OpenIMLocationElem.self, from: locationJSON)
        XCTAssertEqual(location.desc, "Taipei 101")
        XCTAssertEqual(location.longitude, 121.5654)

        let customJSON = """
        {
            "data": "custom_data",
            "description": "custom_desc",
            "extension": "custom_ext"
        }
        """.data(using: .utf8)!

        let custom = try JSONDecoder().decode(OpenIMCustomElem.self, from: customJSON)
        XCTAssertEqual(custom.data, "custom_data")
        XCTAssertEqual(custom.desc, "custom_desc")
        XCTAssertEqual(custom.extension, "custom_ext")
    }
}
