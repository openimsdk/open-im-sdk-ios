import XCTest
@testable import OpenIMSDK

final class OpenIMClientTests: XCTestCase {
    func testInitialState() {
        let client = OpenIMClient()
        XCTAssertEqual(client.state, .idle)
    }

    func testUnavailableAdapterFailsInitialization() {
        let client = OpenIMClient()
        XCTAssertThrowsError(try client.initialize(configuration: OpenIMConfiguration(
            apiAddress: "https://api.example.com",
            websocketAddress: "wss://ws.example.com"
        ))) { error in
            XCTAssertEqual(error as? OpenIMError, .coreUnavailable)
        }
        XCTAssertEqual(client.state, .idle)
    }

    func testClientLifecycleWithAdapter() throws {
        let adapter = TestAdapter()
        let client = OpenIMClient(adapter: adapter)
        let configuration = OpenIMConfiguration(
            apiAddress: "https://api.example.com",
            websocketAddress: "wss://ws.example.com"
        )

        try client.initialize(configuration: configuration)
        XCTAssertEqual(client.state, .initialized)

        let loginExpectation = expectation(description: "login")
        client.login(userID: "user-1", token: "token") { result in
            if case .failure(let error) = result {
                XCTFail("login failed: \(error)")
            }
            loginExpectation.fulfill()
        }
        wait(for: [loginExpectation], timeout: 1)
        XCTAssertEqual(client.state, .loggedIn(userID: "user-1"))

        let logoutExpectation = expectation(description: "logout")
        client.logout { result in
            if case .failure(let error) = result {
                XCTFail("logout failed: \(error)")
            }
            logoutExpectation.fulfill()
        }
        wait(for: [logoutExpectation], timeout: 1)
        XCTAssertEqual(client.state, .initialized)
    }
}

private final class TestAdapter: OpenIMCoreAdapter {
    func initialize(
        configuration: OpenIMConfiguration,
        eventHandler: @escaping (OpenIMCoreEvent) -> Void
    ) throws {}

    func login(
        userID: String,
        token: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        completion(.success(()))
    }

    func logout(completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.success(()))
    }

    func uninitialize() {}
}
