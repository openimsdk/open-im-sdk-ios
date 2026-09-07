import Foundation

public enum OpenIMError: Error, Equatable, Sendable {
    public enum ExpectedState: Equatable, Sendable {
        case idle
        case initialized
        case loggedIn
    }

    /// The operation cannot be performed from the current client state.
    case invalidState(expected: ExpectedState, actual: OpenIMClient.State)
    /// An in-flight core operation was invalidated by `uninitialize()`.
    case cancelled
    case coreUnavailable
    case core(code: Int, message: String?)
    case decodingFailed(message: String)
    case encodingFailed(message: String)
    case invalidParameter(message: String)
}

extension OpenIMError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .invalidState(expected, actual):
            return "Invalid client state. Expected \(expected), got \(actual)."
        case .cancelled:
            return "The OpenIMCore operation was cancelled."
        case .coreUnavailable:
            return "The OpenIMCore adapter has not been configured."
        case let .core(code, message):
            return message.map { "OpenIMCore error \(code): \($0)" } ?? "OpenIMCore error \(code)."
        case let .decodingFailed(message):
            return "Failed to decode response: \(message)"
        case let .encodingFailed(message):
            return "Failed to encode parameter: \(message)"
        case let .invalidParameter(message):
            return "Invalid parameter: \(message)"
        }
    }
}
