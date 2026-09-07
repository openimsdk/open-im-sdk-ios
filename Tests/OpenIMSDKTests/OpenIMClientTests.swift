@testable import OpenIMSDK
import XCTest

final class OpenIMClientTests: XCTestCase {
    func testInitialState() {
        let client = OpenIMClient(callbackQueue: .main)
        XCTAssertEqual(client.state, .idle)
    }

    func testConvenienceInitConstructsUsableClient() {
        let client = OpenIMClient()
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

    func testClientLifecycleWithAdapter() async throws {
        let adapter = TestAdapter()
        let client = OpenIMClient(adapter: adapter)
        let configuration = OpenIMConfiguration(
            apiAddress: "https://api.example.com",
            websocketAddress: "wss://ws.example.com"
        )

        try client.initialize(configuration: configuration)
        XCTAssertEqual(client.state, .initialized)

        try await client.login(userID: "user-1", token: "token")
        XCTAssertEqual(client.state, .loggedIn(userID: "user-1"))

        try await client.logout()
        XCTAssertEqual(client.state, .initialized)

        client.uninitialize()
        XCTAssertEqual(client.state, .idle)
    }

    func testLoginBeforeInitializationReportsInvalidState() async {
        let client = OpenIMClient(adapter: TestAdapter())

        do {
            try await client.login(userID: "user-1", token: "token")
            XCTFail("Expected invalid state failure")
        } catch let error as OpenIMError {
            XCTAssertEqual(
                error,
                .invalidState(expected: .initialized, actual: .idle)
            )
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testDoubleInitializationThrowsInvalidState() throws {
        let adapter = TestAdapter()
        let client = OpenIMClient(adapter: adapter)
        let config = OpenIMConfiguration(apiAddress: "https://api.example.com", websocketAddress: "wss://ws.example.com")

        try client.initialize(configuration: config)
        XCTAssertEqual(client.state, .initialized)

        XCTAssertThrowsError(try client.initialize(configuration: config)) { error in
            XCTAssertEqual(error as? OpenIMError, .invalidState(expected: .idle, actual: .initialized))
        }
    }

    func testLogoutBeforeLoginThrowsInvalidState() async {
        let adapter = TestAdapter()
        let client = OpenIMClient(adapter: adapter)

        do {
            try await client.logout()
            XCTFail("Expected invalid state failure")
        } catch let error as OpenIMError {
            XCTAssertEqual(error, .invalidState(expected: .loggedIn, actual: .idle))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testLogoutFailureRestoresLoggedInState() async throws {
        let adapter = TestAdapter()
        adapter.shouldFailLogout = true
        let client = OpenIMClient(adapter: adapter)
        let config = OpenIMConfiguration(apiAddress: "https://api.example.com", websocketAddress: "wss://ws.example.com")

        try client.initialize(configuration: config)
        try await client.login(userID: "user-1", token: "token")
        XCTAssertEqual(client.state, .loggedIn(userID: "user-1"))

        do {
            try await client.logout()
            XCTFail("Expected logout failure")
        } catch {
            XCTAssertEqual(client.state, .loggedIn(userID: "user-1"))
        }
    }

    func testUninitializeWhenIdleIsSafeNoOp() {
        let adapter = TestAdapter()
        let client = OpenIMClient(adapter: adapter)
        XCTAssertEqual(client.state, .idle)
        client.uninitialize()
        XCTAssertEqual(client.state, .idle)
    }

    func testEventObservationAndDelivery() throws {
        let adapter = TestAdapter()
        let client = OpenIMClient(adapter: adapter)
        let config = OpenIMConfiguration(apiAddress: "https://api.example.com", websocketAddress: "wss://ws.example.com")

        var receivedEvents: [OpenIMCoreEvent] = []
        let exp1 = expectation(description: "event 1")
        let exp2 = expectation(description: "event 2")
        let exp3 = expectation(description: "event 3")
        let exp4 = expectation(description: "event 4")
        let exp5 = expectation(description: "event 5")
        let exp6 = expectation(description: "event 6")

        let observerID = client.observeEvents { event in
            receivedEvents.append(event)
            switch event {
            case .connecting: exp1.fulfill()
            case .connected: exp2.fulfill()
            case .connectionFailed: exp3.fulfill()
            case .kickedOffline: exp4.fulfill()
            case .tokenExpired: exp5.fulfill()
            case .tokenInvalid: exp6.fulfill()
            }
        }

        try client.initialize(configuration: config)

        adapter.simulateEvent(.connecting)
        adapter.simulateEvent(.connected)
        adapter.simulateEvent(.connectionFailed(code: -1, message: "err"))
        adapter.simulateEvent(.kickedOffline)
        adapter.simulateEvent(.tokenExpired)
        adapter.simulateEvent(.tokenInvalid(message: "invalid"))

        wait(for: [exp1, exp2, exp3, exp4, exp5, exp6], timeout: 2.0)
        XCTAssertEqual(receivedEvents.count, 6)

        // Test remove observer
        client.removeEventObserver(observerID)
        adapter.simulateEvent(.connected)
        let expFlush = expectation(description: "flush")
        DispatchQueue.main.async { expFlush.fulfill() }
        wait(for: [expFlush], timeout: 1.0)
        XCTAssertEqual(receivedEvents.count, 6, "Observer should not receive events after removal")
    }

    func testStaleLoginCompletionCannotResurrectClient() async throws {
        let adapter = DeferredAdapter()
        let client = OpenIMClient(adapter: adapter)
        try client.initialize(configuration: OpenIMConfiguration(
            apiAddress: "https://api.example.com",
            websocketAddress: "wss://ws.example.com"
        ))

        let loginTask = Task {
            try await client.login(userID: "user-1", token: "token")
        }

        // Give the task a moment to reach loggingIn state
        try await Task.sleep(nanoseconds: 50_000_000)
        XCTAssertEqual(client.state, .loggingIn(userID: "user-1"))

        client.uninitialize()
        XCTAssertEqual(client.state, .idle)

        adapter.completeLogin(.success(()))
        _ = try? await loginTask.value
        XCTAssertEqual(client.state, .idle)
    }
}

private final class TestAdapter: OpenIMCoreAdapter {
    var shouldFailLogout = false
    private var eventHandler: ((OpenIMCoreEvent) -> Void)?

    func initialize(
        configuration _: OpenIMConfiguration,
        eventHandler: @escaping (OpenIMCoreEvent) -> Void
    ) throws {
        self.eventHandler = eventHandler
    }

    func simulateEvent(_ event: OpenIMCoreEvent) {
        eventHandler?(event)
    }

    func login(
        userID _: String,
        token _: String
    ) async throws {}

    func logout() async throws {
        if shouldFailLogout {
            throw OpenIMError.core(code: -1, message: "Logout failed")
        }
    }

    func uninitialize() {}
}

private final class DeferredAdapter: OpenIMCoreAdapter {
    private var loginContinuation: CheckedContinuation<Void, Error>?

    func initialize(
        configuration _: OpenIMConfiguration,
        eventHandler _: @escaping (OpenIMCoreEvent) -> Void
    ) throws {}

    func login(
        userID _: String,
        token _: String
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            loginContinuation = continuation
        }
    }

    func logout() async throws {}

    func uninitialize() {}

    func completeLogin(_ result: Result<Void, Error>) {
        loginContinuation?.resume(with: result)
    }
}
