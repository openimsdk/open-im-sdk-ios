@testable import OpenIMSDK
import XCTest

final class OpenIMClientTests: XCTestCase {
    func testInitialState() {
        let client = OpenIMClient(callbackQueue: .main)
        XCTAssertEqual(client.state, .idle)
    }

    func testUnavailableAdapterFailsInitialization() {
        let client = OpenIMClient(adapter: UnavailableOpenIMCoreAdapter(), callbackQueue: .main)
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
            if case let .failure(error) = result {
                XCTFail("login failed: \(error)")
            }
            loginExpectation.fulfill()
        }
        wait(for: [loginExpectation], timeout: 1)
        XCTAssertEqual(client.state, .loggedIn(userID: "user-1"))

        let logoutExpectation = expectation(description: "logout")
        client.logout { result in
            if case let .failure(error) = result {
                XCTFail("logout failed: \(error)")
            }
            logoutExpectation.fulfill()
        }
        wait(for: [logoutExpectation], timeout: 1)
        XCTAssertEqual(client.state, .initialized)

        client.uninitialize()
        XCTAssertEqual(client.state, .idle)
    }

    func testLoginBeforeInitializationReportsInvalidState() {
        let client = OpenIMClient(adapter: TestAdapter())
        let expectation = expectation(description: "invalid login")

        client.login(userID: "user-1", token: "token") { result in
            guard case let .failure(error) = result else {
                XCTFail("Expected invalid state failure, got \(result)")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(
                error,
                .invalidState(expected: .initialized, actual: .idle)
            )
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testStaleLoginCompletionCannotResurrectClient() throws {
        let adapter = DeferredAdapter()
        let client = OpenIMClient(adapter: adapter)
        try client.initialize(configuration: OpenIMConfiguration(
            apiAddress: "https://api.example.com",
            websocketAddress: "wss://ws.example.com"
        ))

        let completionExpectation = expectation(description: "cancelled login")
        client.login(userID: "user-1", token: "token") { result in
            if case let .failure(error) = result {
                XCTFail("Expected stale success, got \(error)")
            }
            completionExpectation.fulfill()
        }
        XCTAssertEqual(client.state, .loggingIn(userID: "user-1"))

        client.uninitialize()
        XCTAssertEqual(client.state, .idle)

        adapter.completeLogin(.success(()))
        wait(for: [completionExpectation], timeout: 1)
        XCTAssertEqual(client.state, .idle)
    }
}

private final class TestAdapter: OpenIMCoreAdapter {
    func initialize(
        configuration _: OpenIMConfiguration,
        eventHandler _: @escaping (OpenIMCoreEvent) -> Void
    ) throws {}

    func login(
        userID _: String,
        token _: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        completion(.success(()))
    }

    func logout(completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.success(()))
    }

    func uninitialize() {}
}

private final class DeferredAdapter: OpenIMCoreAdapter {
    private var loginCompletion: ((Result<Void, OpenIMError>) -> Void)?

    func initialize(
        configuration _: OpenIMConfiguration,
        eventHandler _: @escaping (OpenIMCoreEvent) -> Void
    ) throws {}

    func login(
        userID _: String,
        token _: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        loginCompletion = completion
    }

    func logout(completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.success(()))
    }

    func uninitialize() {}

    func completeLogin(_ result: Result<Void, OpenIMError>) {
        loginCompletion?(result)
    }
}
