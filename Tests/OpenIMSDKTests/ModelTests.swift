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

    func testConversationAdditionalModels() throws {
        let notDisturb = OpenIMConversationNotDisturbInfo(conversationID: "c1", result: .notReceive)
        XCTAssertEqual(notDisturb.conversationID, "c1")
        XCTAssertEqual(notDisturb.result, .notReceive)

        let inputStatus = OpenIMInputStatusChangedData(conversationID: "c1", userID: "u1", platformIDs: [1, 2])
        XCTAssertEqual(inputStatus.conversationID, "c1")
        XCTAssertEqual(inputStatus.userID, "u1")
        XCTAssertEqual(inputStatus.platformIDs, [1, 2])

        let req = OpenIMConversationReq(
            userID: "u1",
            groupID: "g1",
            recvMsgOpt: .receive,
            isPinned: false,
            groupAtType: .atMe,
            isPrivateChat: true,
            burnDuration: 30,
            ex: "customEx"
        )
        XCTAssertEqual(req.userID, "u1")
        XCTAssertEqual(req.groupID, "g1")
        XCTAssertEqual(req.isPinned, false)
        XCTAssertEqual(req.isPrivateChat, true)
        XCTAssertEqual(req.burnDuration, 30)
        XCTAssertEqual(req.ex, "customEx")
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

    func testMessageInfoEquality() {
        let msg1 = OpenIMMessageInfo(clientMsgID: "id1")
        let msg2 = OpenIMMessageInfo(clientMsgID: "id1")
        let msg3 = OpenIMMessageInfo(clientMsgID: "id2")
        XCTAssertEqual(msg1, msg2)
        XCTAssertNotEqual(msg1, msg3)

        // Fallback comparison without clientMsgID
        let fallback1 = OpenIMMessageInfo(serverMsgID: "s1", sendID: "u1", recvID: "u2", contentType: .text, content: "hi", status: .sendSuccess)
        let fallback2 = OpenIMMessageInfo(serverMsgID: "s1", sendID: "u1", recvID: "u2", contentType: .text, content: "hi", status: .sendSuccess)
        let fallbackDiff = OpenIMMessageInfo(serverMsgID: "s2", sendID: "u1", recvID: "u2", contentType: .text, content: "hi", status: .sendSuccess)
        XCTAssertEqual(fallback1, fallback2)
        XCTAssertNotEqual(fallback1, fallbackDiff)
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

    func testMessageElements() throws {
        let picInfo = OpenIMPictureInfo(uuID: "u", type: "jpg", size: 100, width: 200, height: 300, url: "http://pic")
        XCTAssertEqual(picInfo.width, 200)

        let picElem = OpenIMPictureElem(sourcePath: "/path", sourcePicture: picInfo, bigPicture: picInfo, snapshotPicture: picInfo)
        XCTAssertEqual(picElem.sourcePath, "/path")

        let soundElem = OpenIMSoundElem(uuID: "s", soundPath: "/s.mp3", sourceUrl: "http://s", dataSize: 50, duration: 10)
        XCTAssertEqual(soundElem.duration, 10)

        let videoElem = OpenIMVideoElem(
            videoPath: "/v.mp4", videoUUID: "vu", videoUrl: "http://v", videoType: "mp4", videoSize: 200,
            duration: 15, snapshotPath: "/snap.png", snapshotUUID: "su", snapshotSize: 50, snapshotUrl: "http://snap",
            snapshotWidth: 100, snapshotHeight: 200
        )
        XCTAssertEqual(videoElem.videoType, "mp4")

        let fileElem = OpenIMFileElem(filePath: "/f.pdf", uuID: "fu", sourceUrl: "http://f", fileName: "f.pdf", fileSize: 500)
        XCTAssertEqual(fileElem.fileName, "f.pdf")

        let entity = OpenIMMessageEntity(type: "mention", offset: 0, length: 5, url: "http://u", info: "info")
        XCTAssertEqual(entity.offset, 0)

        let advText = OpenIMAdvancedTextElem(text: "Hello", messageEntityList: [entity])
        XCTAssertEqual(advText.text, "Hello")

        let atInfo = OpenIMAtInfo(atUserID: "u1", groupNickname: "User 1")
        XCTAssertEqual(atInfo.atUserID, "u1")

        let typingElem = OpenIMTypingElem(msgTips: "typing...")
        XCTAssertEqual(typingElem.msgTips, "typing...")

        let cardElem = OpenIMCardElem(userID: "card1", nickname: "Card 1", faceURL: "http://c", ex: "ex")
        XCTAssertEqual(cardElem.userID, "card1")

        let faceElem = OpenIMFaceElem(index: 2, data: "face_data")
        XCTAssertEqual(faceElem.index, 2)
    }

    func testMessageModels() throws {
        let quote = OpenIMQuoteElem(text: "quote text", quoteMessage: OpenIMMessageInfo(clientMsgID: "q1"))
        XCTAssertEqual(quote.text, "quote text")

        let atText = OpenIMAtTextElem(text: "at text", atUserList: ["u1"], atUsersInfo: [], quoteMessage: nil, isAtSelf: true)
        XCTAssertEqual(atText.isAtSelf, true)

        let merge = OpenIMMergeElem(title: "Merge Title", abstractList: ["abs"], multiMessage: [], messageEntityList: [])
        XCTAssertEqual(merge.title, "Merge Title")

        let push = OpenIMOfflinePushInfo(title: "Title", desc: "Desc", iOSPushSound: "sound", iOSBadgeCount: true, operatorUserID: "op", ex: "ex")
        XCTAssertEqual(push.title, "Title")
        XCTAssertEqual(push.iOSBadgeCount, true)

        let getOptions = OpenIMGetMessageOptions(userID: "u1", groupID: "g1", conversationID: "c1", startClientMsgID: "m1", count: 30)
        XCTAssertEqual(getOptions.count, 30)

        let histInfo = OpenIMGetAdvancedHistoryMessageListInfo(isEnd: true, lastMinSeq: 5, errCode: 0, errMsg: "ok", messageList: [])
        XCTAssertEqual(histInfo.isEnd, true)

        let searchParam = OpenIMSearchParam(
            conversationID: "c1", keywordList: ["k"], keywordListMatchType: 1, senderUserIDList: ["u1"],
            messageTypeList: [101], searchTimePosition: 100, searchTimePeriod: 200, pageIndex: 1, count: 20
        )
        XCTAssertEqual(searchParam.keywordList, ["k"])

        let itemInfo = OpenIMSearchResultItemInfo(conversationID: "c1", messageCount: 5, conversationType: .c2c, showName: "Name", faceURL: "http://f", messageList: [])
        XCTAssertEqual(itemInfo.messageCount, 5)

        let searchRes = OpenIMSearchResultInfo(totalCount: 1, searchResultItems: [itemInfo], findResultItems: [itemInfo])
        XCTAssertEqual(searchRes.totalCount, 1)

        let revoked = OpenIMMessageRevokedInfo(
            revokerID: "r1", revokerRole: 60, revokerNickname: "Revoker", clientMsgID: "m1",
            revokeTime: 1000, sourceMessageSendTime: 900, sourceMessageSendID: "s1", sourceMessageSenderNickname: "Sender", sessionType: 1
        )
        XCTAssertEqual(revoked.revokerID, "r1")

        let receipt = OpenIMReceiptInfo(userID: "u1", groupID: "g1", msgIDList: ["m1"], readTime: 1000, msgFrom: 1, contentType: 101, sessionType: 1)
        XCTAssertEqual(receipt.userID, "u1")
    }

    func testTypesEnums() {
        XCTAssertEqual(OpenIMPlatform.allCases.count, 9)
        XCTAssertEqual(OpenIMPlatform.iPhone.rawValue, 1)
        XCTAssertEqual(OpenIMPlatform.android.rawValue, 2)
        XCTAssertEqual(OpenIMPlatform.windows.rawValue, 3)
        XCTAssertEqual(OpenIMPlatform.macOS.rawValue, 4)
        XCTAssertEqual(OpenIMPlatform.web.rawValue, 5)
        XCTAssertEqual(OpenIMPlatform.miniWeb.rawValue, 6)
        XCTAssertEqual(OpenIMPlatform.linux.rawValue, 7)
        XCTAssertEqual(OpenIMPlatform.androidPad.rawValue, 8)
        XCTAssertEqual(OpenIMPlatform.iPad.rawValue, 9)

        XCTAssertEqual(OpenIMMessageContentType.text.rawValue, 101)
        XCTAssertEqual(OpenIMMessageStatus.sendSuccess.rawValue, 2)
        XCTAssertEqual(OpenIMConversationType.c2c.rawValue, 1)
        XCTAssertEqual(OpenIMMessageLevel.user.rawValue, 100)
        XCTAssertEqual(OpenIMReceiveMessageOpt.receive.rawValue, 0)
        XCTAssertEqual(OpenIMGroupMemberFilter.all.rawValue, 0)
        XCTAssertEqual(OpenIMGroupMemberRole.admin.rawValue, 60)
        XCTAssertEqual(OpenIMApplicationStatus.accept.rawValue, 1)
        XCTAssertEqual(OpenIMRelationship.friend.rawValue, 1)
        XCTAssertEqual(OpenIMGroupAtType.atMe.rawValue, 1)
        XCTAssertEqual(OpenIMGroupVerificationType.directly.rawValue, 2)
        XCTAssertEqual(OpenIMGroupType.superGroup.rawValue, 1)
        XCTAssertEqual(OpenIMGroupStatus.ok.rawValue, 0)
        XCTAssertEqual(OpenIMJoinType.invited.rawValue, 2)
        XCTAssertEqual(OpenIMAllowType.allowed.rawValue, 0)
        XCTAssertEqual(OpenIMLoginStatus.logged.rawValue, 3)
        XCTAssertEqual(OpenIMGetHistoryViewType.history.rawValue, 0)
    }
}
