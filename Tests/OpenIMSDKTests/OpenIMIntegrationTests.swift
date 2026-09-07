#if canImport(OpenIMCore)

import Foundation
@testable import OpenIMSDK
import XCTest

/// Live integration tests using real OpenIM server and OpenIMCore native bridge.
final class OpenIMIntegrationTests: XCTestCase {
    private let defaultApiAddress = "https://web.openim.io/api"
    private let defaultWsAddress = "wss://web.openim.io/msg_gateway"

    func testLiveServerFullWorkflow() async throws {
        let env = ProcessInfo.processInfo.environment
        guard let userID = env["OPENIM_TEST_USER_ID"],
              let token = env["OPENIM_TEST_TOKEN"] else {
            throw XCTSkip("Skipping live integration test: set OPENIM_TEST_USER_ID and OPENIM_TEST_TOKEN to run.")
        }
        let apiAddress = env["OPENIM_TEST_API_ADDR"] ?? defaultApiAddress
        let websocketAddress = env["OPENIM_TEST_WS_ADDR"] ?? defaultWsAddress

        let client = OpenIMClient(
            adapter: NativeOpenIMCoreAdapter(),
            callbackQueue: .main
        )

        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("OpenIMSDKIntegration-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        try client.initialize(configuration: OpenIMConfiguration(
            apiAddress: apiAddress,
            websocketAddress: websocketAddress,
            dataDirectory: tempDir,
            platform: .android, // Token was minted with PlatformID 2
            logLevel: 6,
            logToStandardOutput: true
        ))

        defer {
            client.uninitialize()
        }

        // 1. Login to OpenIM backend
        try await client.login(userID: userID, token: token)
        XCTAssertEqual(client.state, .loggedIn(userID: userID))

        // 2. Fetch self user info over live server API
        let selfInfo = try await client.user.getSelfUserInfo()
        XCTAssertEqual(selfInfo.userID, userID)
        XCTAssertEqual(selfInfo.nickname, "5234")

        // 3. Create a local message
        let message = try client.message.createTextMessage(text: "Hello from OpenIM Swift SDK Integration Test!")
        XCTAssertEqual(message.contentType, .text)
        XCTAssertEqual(message.textElem?.content, "Hello from OpenIM Swift SDK Integration Test!")
        XCTAssertFalse(message.clientMsgID?.isEmpty ?? true)

        // 4. Allow short window for background sync to populate local DB
        try await Task.sleep(nanoseconds: 1_500_000_000)

        // 5. Query local synchronized friends and groups
        let friends = try await client.friend.getFriendList()
        XCTAssertFalse(friends.isEmpty, "User has friends synchronized from server")

        let groups = try await client.group.getJoinedGroupList()
        XCTAssertFalse(groups.isEmpty, "User has joined groups synchronized from server")
    }
}

#endif
