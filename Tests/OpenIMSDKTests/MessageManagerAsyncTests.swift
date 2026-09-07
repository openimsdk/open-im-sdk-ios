import XCTest
@testable import OpenIMSDK

final class MessageManagerAsyncTests: XCTestCase {
    func testAllMessageCreationAPIs() throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        // 1. createTextMessage
        let textMsg = try client.message.createTextMessage(text: "Hello")
        XCTAssertEqual(textMsg.contentType, .text)
        XCTAssertEqual(textMsg.textElem?.content, "Hello")

        // 2. createTextAtMessage
        let atMsg = try client.message.createTextAtMessage(text: "@u1", atUserIDs: ["u1"])
        XCTAssertEqual(atMsg.contentType, .at)
        XCTAssertEqual(atMsg.atTextElem?.text, "@u1")
        XCTAssertEqual(atMsg.atTextElem?.atUserList, ["u1"])

        // 3. createImageMessage
        let imgMsg = try client.message.createImageMessage(imagePath: "/path/img.png")
        XCTAssertEqual(imgMsg.contentType, .image)
        XCTAssertEqual(imgMsg.pictureElem?.sourcePath, "/path/img.png")

        // 4. createSoundMessage
        let soundMsg = try client.message.createSoundMessage(soundPath: "/path/sound.m4a", duration: 15)
        XCTAssertEqual(soundMsg.contentType, .audio)
        XCTAssertEqual(soundMsg.soundElem?.soundPath, "/path/sound.m4a")
        XCTAssertEqual(soundMsg.soundElem?.duration, 15)

        // 5. createVideoMessage
        let vidMsg = try client.message.createVideoMessage(videoPath: "/path/v.mp4", videoType: "mp4", duration: 60, snapshotPath: "/path/snap.png")
        XCTAssertEqual(vidMsg.contentType, .video)
        XCTAssertEqual(vidMsg.videoElem?.duration, 60)

        // 6. createFileMessage
        let fileMsg = try client.message.createFileMessage(filePath: "/path/doc.pdf", fileName: "doc.pdf")
        XCTAssertEqual(fileMsg.contentType, .file)
        XCTAssertEqual(fileMsg.fileElem?.fileName, "doc.pdf")

        // 7. createLocationMessage
        let locMsg = try client.message.createLocationMessage(description: "Office", longitude: 121.5, latitude: 25.0)
        XCTAssertEqual(locMsg.contentType, .location)
        XCTAssertEqual(locMsg.locationElem?.desc, "Office")

        // 8. createCustomMessage
        let customMsg = try client.message.createCustomMessage(data: "{}", extension: "ext", description: "custom")
        XCTAssertEqual(customMsg.contentType, .custom)
        XCTAssertEqual(customMsg.customElem?.desc, "custom")

        // 9. createQuoteMessage
        let quoteMsg = try client.message.createQuoteMessage(text: "reply", message: textMsg)
        XCTAssertEqual(quoteMsg.contentType, .quote)
        XCTAssertEqual(quoteMsg.quoteElem?.text, "reply")

        // 10. createCardMessage
        let cardMsg = try client.message.createCardMessage(cardInfo: OpenIMCardElem(userID: "card_u1", nickname: "Card User"))
        XCTAssertEqual(cardMsg.contentType, .card)
        XCTAssertEqual(cardMsg.cardElem?.userID, "card_u1")

        // 11. createFaceMessage
        let faceMsg = try client.message.createFaceMessage(index: 5, data: "sticker_data")
        XCTAssertEqual(faceMsg.contentType, .face)
        XCTAssertEqual(faceMsg.faceElem?.index, 5)

        // 12. createMergerMessage
        let mergeMsg = try client.message.createMergerMessage(messageList: [textMsg, imgMsg], title: "Chat Log", summaryList: ["Summary 1"])
        XCTAssertEqual(mergeMsg.contentType, .merge)
        XCTAssertEqual(mergeMsg.mergeElem?.title, "Chat Log")

        // 13. createForwardMessage
        let fwdMsg = try client.message.createForwardMessage(message: textMsg)
        XCTAssertEqual(fwdMsg.clientMsgID, "msg_test_fwd")
    }

    func testAllMessageOperationsUsingAsyncAwait() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        let msg = try client.message.createTextMessage(text: "Hello World")

        // 1. sendMessage
        var progressValues: [Int] = []
        let sent = try await client.message.sendMessage(message: msg, recvID: "user_2", onProgress: { progressValues.append($0) })
        XCTAssertEqual(sent.status, .sendSuccess)
        XCTAssertEqual(adapter.lastSentMessage?.clientMsgID, msg.clientMsgID)
        XCTAssertFalse(progressValues.isEmpty)

        // 2. getAdvancedHistoryMessageList
        let options = OpenIMGetMessageOptions(conversationID: "c1", count: 20)
        let history = try await client.message.getAdvancedHistoryMessageList(options: options)
        XCTAssertEqual(history.isEnd, true)
        XCTAssertEqual(history.messageList?.first?.clientMsgID, "hist_1")

        // 3. revokeMessage
        try await client.message.revokeMessage(conversationID: "c1", clientMsgID: "msg_test_1")
        XCTAssertEqual(adapter.lastRevokedMessage?.conversationID, "c1")
        XCTAssertEqual(adapter.lastRevokedMessage?.clientMsgID, "msg_test_1")

        // 4. typingStatusUpdate
        try await client.message.typingStatusUpdate(recvID: "user_2", msgTip: "typing...")
        XCTAssertEqual(adapter.lastTypingStatus?.recvID, "user_2")
        XCTAssertEqual(adapter.lastTypingStatus?.msgTip, "typing...")

        // 5. markMessagesAsReadByMsgID
        try await client.message.markMessagesAsReadByMsgID(conversationID: "c1", clientMsgIDs: ["m1", "m2"])
        XCTAssertEqual(adapter.lastMarkedAsReadMsgIDs?.conversationID, "c1")
        XCTAssertEqual(adapter.lastMarkedAsReadMsgIDs?.clientMsgIDs, ["m1", "m2"])

        // 6. deleteMessage
        try await client.message.deleteMessage(conversationID: "c1", clientMsgID: "msg_test_1")
        XCTAssertEqual(adapter.lastDeletedMessage?.conversationID, "c1")
        XCTAssertEqual(adapter.lastDeletedMessage?.clientMsgID, "msg_test_1")

        // 7. deleteMessageFromLocalStorage
        try await client.message.deleteMessageFromLocalStorage(conversationID: "c1", clientMsgID: "msg_test_1")
        XCTAssertEqual(adapter.lastDeletedLocalMessage?.conversationID, "c1")
        XCTAssertEqual(adapter.lastDeletedLocalMessage?.clientMsgID, "msg_test_1")

        // 8. deleteAllMsgFromLocal
        try await client.message.deleteAllMsgFromLocal()
        XCTAssertTrue(adapter.deleteAllLocalMsgCalled)

        // 9. deleteAllMsgFromLocalAndSvr
        try await client.message.deleteAllMsgFromLocalAndSvr()
        XCTAssertTrue(adapter.deleteAllLocalAndSvrMsgCalled)

        // 10. searchLocalMessages
        let searchParam = OpenIMSearchParam(conversationID: "c1", keywordList: ["test"])
        let searchRes = try await client.message.searchLocalMessages(param: searchParam)
        XCTAssertEqual(adapter.lastSearchLocalMessagesParam?.conversationID, "c1")
        XCTAssertEqual(searchRes.totalCount, 1)

        // 11. setListener
        final class DummyAdvancedMsgListener: OpenIMAdvancedMsgListener, @unchecked Sendable {}
        let listener = DummyAdvancedMsgListener()
        client.message.setListener(listener)
        XCTAssertTrue(adapter.advancedMsgListener === listener)
    }

    func testMessageManagerErrorPropagation() async throws {
        let adapter = MockOpenIMCoreAdapter()
        adapter.shouldFail = true
        let client = OpenIMClient(adapter: adapter)

        let msg = try client.message.createTextMessage(text: "Fail me")
        do {
            _ = try await client.message.sendMessage(message: msg, recvID: "u2")
            XCTFail("Expected failure")
        } catch let error as OpenIMError {
            if case let .core(code, message) = error {
                XCTAssertEqual(code, -999)
                XCTAssertEqual(message, "Simulated network failure")
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
