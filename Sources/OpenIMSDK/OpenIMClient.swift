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

    public private(set) lazy var user: OpenIMUserManager = OpenIMUserManager(client: self, adapter: adapter)
    public private(set) lazy var friend: OpenIMFriendManager = OpenIMFriendManager(client: self, adapter: adapter)
    public private(set) lazy var group: OpenIMGroupManager = OpenIMGroupManager(client: self, adapter: adapter)
    public private(set) lazy var conversation: OpenIMConversationManager = OpenIMConversationManager(client: self, adapter: adapter)
    public private(set) lazy var message: OpenIMMessageManager = OpenIMMessageManager(client: self, adapter: adapter)

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

    /// Starts a login request using Swift async/await.
    public func login(userID: String, token: String) async throws {
        let currentSessionID = try stateQueue.sync { () -> UUID in
            guard stateStorage == .initialized else {
                throw OpenIMError.invalidState(
                    expected: .initialized,
                    actual: stateStorage
                )
            }
            stateStorage = .loggingIn(userID: userID)
            return sessionID
        }

        do {
            try await adapter.login(userID: userID, token: token)
            stateQueue.sync {
                guard self.sessionID == currentSessionID else { return }
                self.stateStorage = .loggedIn(userID: userID)
            }
        } catch {
            stateQueue.sync {
                guard self.sessionID == currentSessionID else { return }
                self.stateStorage = .initialized
            }
            throw error
        }
    }

    /// Starts a logout request using Swift async/await.
    public func logout() async throws {
        let (currentSessionID, userID) = try stateQueue.sync { () -> (UUID, String) in
            guard case let .loggedIn(uid) = stateStorage else {
                throw OpenIMError.invalidState(
                    expected: .loggedIn,
                    actual: stateStorage
                )
            }
            stateStorage = .loggingOut(userID: uid)
            return (sessionID, uid)
        }

        do {
            try await adapter.logout()
            stateQueue.sync {
                guard self.sessionID == currentSessionID else { return }
                self.stateStorage = .initialized
            }
        } catch {
            stateQueue.sync {
                guard self.sessionID == currentSessionID else { return }
                self.stateStorage = .loggedIn(userID: userID)
            }
            throw error
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

    // MARK: - Listener Configuration
    public func setUserListener(_ listener: OpenIMUserListener?) {
        adapter.setUserListener(listener)
    }

    public func setFriendshipListener(_ listener: OpenIMFriendshipListener?) {
        adapter.setFriendshipListener(listener)
    }

    public func setGroupListener(_ listener: OpenIMGroupListener?) {
        adapter.setGroupListener(listener)
    }

    public func setConversationListener(_ listener: OpenIMConversationListener?) {
        adapter.setConversationListener(listener)
    }

    public func setAdvancedMsgListener(_ listener: OpenIMAdvancedMsgListener?) {
        adapter.setAdvancedMsgListener(listener)
    }
}
