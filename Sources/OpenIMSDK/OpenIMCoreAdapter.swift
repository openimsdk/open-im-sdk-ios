import Foundation

/// Events emitted by the native OpenIMCore bridge.
public enum OpenIMCoreEvent: Equatable, Sendable {
    case connecting
    case connected
    case connectionFailed(code: Int, message: String?)
    case kickedOffline
    case tokenExpired
    case tokenInvalid(message: String?)
}

/// Boundary between the Swift API and the gomobile-generated OpenIMCore module.
///
/// Keeping this protocol small allows the Swift package to be tested without a
/// device framework and prevents generated gomobile types from leaking into the
/// public Swift API.
public protocol OpenIMCoreAdapter: AnyObject {
    func initialize(
        configuration: OpenIMConfiguration,
        eventHandler: @escaping (OpenIMCoreEvent) -> Void
    ) throws

    func login(
        userID: String,
        token: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    )

    func logout(completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func uninitialize()
}

/// Default adapter used until an OpenIMCore XCFramework bridge is supplied.
public final class UnavailableOpenIMCoreAdapter: OpenIMCoreAdapter {
    public init() {}

    public func initialize(
        configuration: OpenIMConfiguration,
        eventHandler: @escaping (OpenIMCoreEvent) -> Void
    ) throws {
        throw OpenIMError.coreUnavailable
    }

    public func login(
        userID: String,
        token: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        completion(.failure(.coreUnavailable))
    }

    public func logout(completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }

    public func uninitialize() {}
}
