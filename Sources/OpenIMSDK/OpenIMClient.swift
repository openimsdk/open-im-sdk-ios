import Foundation

/// Swift-first entry point for the rewritten SDK.
public final class OpenIMClient {
    public enum State: Equatable, Sendable {
        case idle
        case initializing
        case initialized
        case loggingIn(userID: String)
        case loggedIn(userID: String)
        case loggingOut(userID: String)
    }

    /// Event callbacks are delivered asynchronously on `callbackQueue`.
    public typealias EventHandler = (OpenIMCoreEvent) -> Void

    private let stateQueue = DispatchQueue(label: "io.openim.sdk.client.state")
    private let adapterQueue = DispatchQueue(label: "io.openim.sdk.client.adapter")
    private let callbackQueue: DispatchQueue
    private let adapter: OpenIMCoreAdapter
    private var eventHandlers: [UUID: EventHandler] = [:]
    private var sessionID = UUID()
    private var stateStorage: State = .idle

    public var state: State {
        stateQueue.sync { stateStorage }
    }

    public init(
        adapter: OpenIMCoreAdapter,
        callbackQueue: DispatchQueue = .main
    ) {
        self.adapter = adapter
        self.callbackQueue = callbackQueue
    }

    /// Creates a client backed by the native core when that module is linked.
    /// In a SwiftPM checkout without the binary artifact this initializer
    /// remains constructible and reports `coreUnavailable` on initialization.
    public convenience init(callbackQueue: DispatchQueue = .main) {
        #if canImport(OpenIMCore)
            self.init(adapter: NativeOpenIMCoreAdapter(), callbackQueue: callbackQueue)
        #else
            self.init(adapter: UnavailableOpenIMCoreAdapter(), callbackQueue: callbackQueue)
        #endif
    }

    public func initialize(configuration: OpenIMConfiguration) throws {
        let currentSessionID = try stateQueue.sync { () -> UUID in
            guard stateStorage == .idle else {
                throw OpenIMError.invalidState(
                    expected: .idle,
                    actual: stateStorage
                )
            }
            stateStorage = .initializing
            let id = UUID()
            sessionID = id
            return id
        }

        do {
            try adapterQueue.sync {
                try adapter.initialize(configuration: configuration) { [weak self] event in
                    self?.handle(event: event, sessionID: currentSessionID)
                }
            }
        } catch {
            stateQueue.sync {
                guard sessionID == currentSessionID else { return }
                stateStorage = .idle
            }
            throw error
        }

        stateQueue.sync {
            guard sessionID == currentSessionID else { return }
            stateStorage = .initialized
        }
    }

    @discardableResult
    public func observeEvents(_ handler: @escaping EventHandler) -> UUID {
        let id = UUID()
        stateQueue.sync {
            eventHandlers[id] = handler
        }
        return id
    }

    public func removeEventObserver(_ id: UUID) {
        _ = stateQueue.sync {
            eventHandlers.removeValue(forKey: id)
        }
    }

    /// Starts a login request. The completion is always delivered on
    /// `callbackQueue`, including invalid-state failures.
    public func login(
        userID: String,
        token: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        let callbackQueue = self.callbackQueue
        var stateError: OpenIMError?
        let currentSessionID = stateQueue.sync { () -> UUID? in
            guard stateStorage == .initialized else {
                stateError = .invalidState(
                    expected: .initialized,
                    actual: stateStorage
                )
                return nil
            }
            stateStorage = .loggingIn(userID: userID)
            return sessionID
        }
        guard let currentSessionID else {
            if let stateError {
                deliver(completion: completion, result: .failure(stateError))
            }
            return
        }

        let adapter = self.adapter
        adapterQueue.async { [weak self] in
            adapter.login(userID: userID, token: token) { [weak self] result in
                self?.stateQueue.sync {
                    guard self?.sessionID == currentSessionID else { return }
                    if case .success = result {
                        self?.stateStorage = .loggedIn(userID: userID)
                    } else {
                        self?.stateStorage = .initialized
                    }
                }
                callbackQueue.async {
                    completion(result)
                }
            }
        }
    }

    /// Starts a logout request. The completion is always delivered on
    /// `callbackQueue`, including invalid-state failures.
    public func logout(completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        let callbackQueue = self.callbackQueue
        var stateError: OpenIMError?
        let currentSessionID = stateQueue.sync { () -> (UUID, String)? in
            guard case let .loggedIn(userID) = stateStorage else {
                stateError = .invalidState(
                    expected: .loggedIn,
                    actual: stateStorage
                )
                return nil
            }
            stateStorage = .loggingOut(userID: userID)
            return (sessionID, userID)
        }
        guard let currentSessionID else {
            if let stateError {
                deliver(completion: completion, result: .failure(stateError))
            }
            return
        }

        let adapter = self.adapter
        adapterQueue.async { [weak self] in
            adapter.logout { [weak self] result in
                self?.stateQueue.sync {
                    guard self?.sessionID == currentSessionID.0 else { return }
                    if case .success = result {
                        self?.stateStorage = .initialized
                    } else {
                        self?.stateStorage = .loggedIn(userID: currentSessionID.1)
                    }
                }
                callbackQueue.async {
                    completion(result)
                }
            }
        }
    }

    public func uninitialize() {
        let shouldUninitialize = stateQueue.sync { () -> Bool in
            guard stateStorage != .idle else { return false }
            sessionID = UUID()
            stateStorage = .idle
            return true
        }
        guard shouldUninitialize else { return }
        adapterQueue.sync {
            adapter.uninitialize()
        }
    }

    private func handle(event: OpenIMCoreEvent, sessionID: UUID) {
        let handlers = stateQueue.sync { () -> [EventHandler] in
            guard self.sessionID == sessionID else { return [] }
            return Array(eventHandlers.values)
        }
        callbackQueue.async {
            handlers.forEach { $0(event) }
        }
    }

    private func deliver(
        completion: @escaping (Result<Void, OpenIMError>) -> Void,
        result: Result<Void, OpenIMError>
    ) {
        callbackQueue.async {
            completion(result)
        }
    }
}
