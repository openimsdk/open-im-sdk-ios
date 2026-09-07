import XCTest
@testable import OpenIMSDK

final class ConversationManagerAsyncTests: XCTestCase {
    func testAllConversationManagerAPIsUsingAsyncAwait() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        // 1. getTotalUnreadMsgCount
        let total = try await client.conversation.getTotalUnreadMsgCount()
        XCTAssertEqual(total, 5)

        // 2. getAllConversationList
        let convs = try await client.conversation.getAllConversationList()
        XCTAssertEqual(convs.first?.conversationID, "c_1")

        // 3. getConversationListSplit
        let splitConvs = try await client.conversation.getConversationListSplit(offset: 0, count: 10)
        XCTAssertEqual(splitConvs.first?.conversationID, "c_split_0")

        // 4. getOneConversation
        let singleConv = try await client.conversation.getOneConversation(sessionType: .c2c, sourceID: "u_1")
        XCTAssertEqual(singleConv.conversationID, "c_1_u_1")

        // 5. getMultipleConversation
        let multipleConvs = try await client.conversation.getMultipleConversation(conversationIDs: ["c_1", "c_2"])
        XCTAssertEqual(multipleConvs.count, 2)
        XCTAssertEqual(multipleConvs.first?.conversationID, "c_1")

        // 6. setConversation
        let req = OpenIMConversationReq(recvMsgOpt: .receive, isPinned: true)
        try await client.conversation.setConversation(conversationID: "c_1", req: req)
        XCTAssertEqual(adapter.lastConversationReq?.conversationID, "c_1")
        XCTAssertEqual(adapter.lastConversationReq?.req.isPinned, true)

        // 7. hideConversation
        try await client.conversation.hideConversation(conversationID: "c_1")
        XCTAssertEqual(adapter.lastHiddenConversationID, "c_1")

        // 8. setConversationDraft
        try await client.conversation.setConversationDraft(conversationID: "c_1", draftText: "Hello draft")
        XCTAssertEqual(adapter.lastDraft?.conversationID, "c_1")
        XCTAssertEqual(adapter.lastDraft?.draftText, "Hello draft")

        // 9. setConversationPinned
        try await client.conversation.setConversationPinned(conversationID: "c_1", isPinned: true)
        XCTAssertEqual(adapter.lastPinned?.conversationID, "c_1")
        XCTAssertEqual(adapter.lastPinned?.isPinned, true)

        // 10. setConversationRecvMessageOpt
        try await client.conversation.setConversationRecvMessageOpt(conversationIDs: ["c_1"], status: .notReceive)
        XCTAssertEqual(adapter.lastRecvMessageOpt?.conversationIDs, ["c_1"])
        XCTAssertEqual(adapter.lastRecvMessageOpt?.status, .notReceive)

        // 11. markConversationMessageAsRead
        try await client.conversation.markConversationMessageAsRead(conversationID: "c_1")
        XCTAssertEqual(adapter.lastReadConversationID, "c_1")

        // 12. deleteConversationAndDeleteAllMsg
        try await client.conversation.deleteConversationAndDeleteAllMsg(conversationID: "c_1")
        XCTAssertEqual(adapter.lastDeletedConversationID, "c_1")

        // 13. clearConversationAndDeleteAllMsg
        try await client.conversation.clearConversationAndDeleteAllMsg(conversationID: "c_1")
        XCTAssertEqual(adapter.lastClearedConversationID, "c_1")

        // 14. setListener
        final class DummyConversationListener: OpenIMConversationListener, @unchecked Sendable {}
        let listener = DummyConversationListener()
        client.conversation.setListener(listener)
        XCTAssertTrue(adapter.conversationListener === listener)
    }

    func testConversationManagerErrorPropagation() async {
        let adapter = MockOpenIMCoreAdapter()
        adapter.shouldFail = true
        let client = OpenIMClient(adapter: adapter)

        do {
            _ = try await client.conversation.getAllConversationList()
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
