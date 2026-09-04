#if canImport(OpenIMCore)

    import Foundation
    @testable import OpenIMSDK
    import XCTest

    /// Opt-in smoke test for the real gomobile bridge.
    ///
    /// This test is deliberately skipped unless all environment variables are
    /// supplied. It must never make a live request during a normal CI or package
    /// validation run.
    final class OpenIMIntegrationTests: XCTestCase {
        func testLoginWithNativeCore() throws {
            let environment = ProcessInfo.processInfo.environment
            guard environment["OPENIM_RUN_INTEGRATION_TESTS"] == "1" else {
                throw XCTSkip("Set OPENIM_RUN_INTEGRATION_TESTS=1 to run the live OpenIM test.")
            }

            guard
                let userID = environment["OPENIM_TEST_USER_ID"], !userID.isEmpty,
                let token = environment["OPENIM_TEST_TOKEN"], !token.isEmpty,
                let apiAddress = environment["OPENIM_TEST_API_ADDR"], !apiAddress.isEmpty,
                let websocketAddress = environment["OPENIM_TEST_WS_ADDR"], !websocketAddress.isEmpty
            else {
                throw XCTSkip(
                    "Set OPENIM_TEST_USER_ID, OPENIM_TEST_TOKEN, OPENIM_TEST_API_ADDR, and OPENIM_TEST_WS_ADDR."
                )
            }

            let client = OpenIMClient(
                adapter: NativeOpenIMCoreAdapter(),
                callbackQueue: .main
            )
            try client.initialize(configuration: OpenIMConfiguration(
                apiAddress: apiAddress,
                websocketAddress: websocketAddress,
                dataDirectory: FileManager.default.temporaryDirectory
                    .appendingPathComponent("OpenIMSDKIntegration-\(UUID().uuidString)")
            ))
            defer { client.uninitialize() }

            let loginExpectation = expectation(description: "native core login")
            var loginResult: Result<Void, OpenIMError>?
            client.login(userID: userID, token: token) { result in
                loginResult = result
                loginExpectation.fulfill()
            }

            wait(for: [loginExpectation], timeout: 30)
            if case let .failure(error) = loginResult {
                XCTFail("Native OpenIMCore login failed: \(error)")
            }
            XCTAssertEqual(client.state, .loggedIn(userID: userID))
        }
    }

#endif
