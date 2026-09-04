import Foundation

/// Swift-first entry point for the rewritten SDK.
public final class OpenIMClient {
    public enum State: Equatable, Sendable {
        case idle
        case initialized
        case loggedIn(userID: String)
    }

    public typealias EventHandler = (OpenIMCoreEvent) -> Void

    private let lock = NSLock()
    private let adapter: OpenIMCoreAdapter
    private var eventHandlers: [UUID: EventHandler] = [:]

    public private(set) var state: State = .idle

    public init(adapter: OpenIMCoreAdapter = UnavailableOpenIMCoreAdapter()) {
        self.adapter = adapter
    }

    public func initialize(configuration: OpenIMConfiguration) throws {
        lock.lock()
        guard state == .idle else {
            let actual = state
            lock.unlock()
            throw OpenIMError.invalidState(expected: .idle, actual: actual)
        }
        lock.unlock()

        try adapter.initialize(configuration: configuration) { [weak self] event in
            self?.handle(event: event)
        }

        lock.lock()
        state = .initialized
        lock.unlock()
    }

    @discardableResult
    public func observeEvents(_ handler: @escaping EventHandler) -> UUID {
        let id = UUID()
        lock.lock()
        eventHandlers[id] = handler
        lock.unlock()
        return id
    }

    public func removeEventObserver(_ id: UUID) {
        lock.lock()
        eventHandlers.removeValue(forKey: id)
        lock.unlock()
    }

    public func login(
        userID: String,
        token: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        lock.lock()
        guard case .initialized = state else {
            let actual = state
            lock.unlock()
            completion(.failure(.invalidState(expected: .initialized, actual: actual)))
            return
        }
        lock.unlock()

        adapter.login(userID: userID, token: token) { [weak self] result in
            if case .success = result {
                self?.lock.lock()
                self?.state = .loggedIn(userID: userID)
                self?.lock.unlock()
            }
            completion(result)
        }
    }

    public func logout(completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lock.lock()
        guard case .loggedIn = state else {
            let actual = state
            lock.unlock()
            completion(.failure(.invalidState(expected: .loggedIn(userID: "<any>"), actual: actual)))
            return
        }
        lock.unlock()

        adapter.logout { [weak self] result in
            if case .success = result {
                self?.lock.lock()
                self?.state = .initialized
                self?.lock.unlock()
            }
            completion(result)
        }
    }

    public func uninitialize() {
        adapter.uninitialize()
        lock.lock()
        state = .idle
        lock.unlock()
    }

    private func handle(event: OpenIMCoreEvent) {
        lock.lock()
        let handlers = Array(eventHandlers.values)
        lock.unlock()
        handlers.forEach { $0(event) }
    }
}
