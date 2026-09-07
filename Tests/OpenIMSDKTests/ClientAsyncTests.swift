import XCTest
@testable import OpenIMSDK

final class ClientAsyncTests: XCTestCase {
    func testClientLifecycleAndListenersUsingAsyncAwait() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        XCTAssertEqual(client.state, .idle)

        let config = OpenIMConfiguration(
            apiAddress: "http://api.test",
            websocketAddress: "ws://ws.test",
            dataDirectory: URL(fileURLWithPath: "/tmp/openim_test")
        )
        try client.initialize(configuration: config)
        XCTAssertEqual(client.state, .initialized)
        XCTAssertEqual(adapter.lastInitializedConfig?.apiAddress, "http://api.test")

        // Async login
        try await client.login(userID: "test_uid", token: "test_token")
        XCTAssertEqual(client.state, .loggedIn(userID: "test_uid"))
        XCTAssertEqual(adapter.lastLoginCredentials?.userID, "test_uid")

        // Async logout
        try await client.logout()
        XCTAssertEqual(client.state, .initialized)
        XCTAssertTrue(adapter.logoutCalled)

        // Event observer
        var receivedEvents: [OpenIMCoreEvent] = []
        let observerID = client.observeEvents { event in
            receivedEvents.append(event)
        }
        client.removeEventObserver(observerID)

        // Test client listeners proxying to adapter
        final class DummyUserListener: OpenIMUserListener, @unchecked Sendable {}
        final class DummyFriendshipListener: OpenIMFriendshipListener, @unchecked Sendable {}
        final class DummyGroupListener: OpenIMGroupListener, @unchecked Sendable {}
        final class DummyConversationListener: OpenIMConversationListener, @unchecked Sendable {}
        final class DummyAdvancedMsgListener: OpenIMAdvancedMsgListener, @unchecked Sendable {}

        let uListener = DummyUserListener()
        let fListener = DummyFriendshipListener()
        let gListener = DummyGroupListener()
        let cListener = DummyConversationListener()
        let mListener = DummyAdvancedMsgListener()

        client.setUserListener(uListener)
        XCTAssertTrue(adapter.userListener === uListener)

        client.setFriendshipListener(fListener)
        XCTAssertTrue(adapter.friendshipListener === fListener)

        client.setGroupListener(gListener)
        XCTAssertTrue(adapter.groupListener === gListener)

        client.setConversationListener(cListener)
        XCTAssertTrue(adapter.conversationListener === cListener)

        client.setAdvancedMsgListener(mListener)
        XCTAssertTrue(adapter.advancedMsgListener === mListener)

        client.uninitialize()
        XCTAssertEqual(client.state, .idle)
        XCTAssertTrue(adapter.uninitializeCalled)
    }

    func testClientAsyncLoginFailureRestoresState() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        let config = OpenIMConfiguration(
            apiAddress: "http://api.test",
            websocketAddress: "ws://ws.test",
            dataDirectory: URL(fileURLWithPath: "/tmp/openim_test")
        )
        try client.initialize(configuration: config)

        adapter.shouldFail = true

        do {
            try await client.login(userID: "bad_uid", token: "bad_token")
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(client.state, .initialized)
        }
    }
}
