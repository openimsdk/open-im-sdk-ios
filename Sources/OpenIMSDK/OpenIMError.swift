import Foundation

public enum OpenIMError: Error, Equatable, Sendable {
    case invalidState(expected: OpenIMClient.State, actual: OpenIMClient.State)
    case coreUnavailable
    case core(code: Int, message: String?)
}

extension OpenIMError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .invalidState(expected, actual):
            return "Invalid client state. Expected \(expected), got \(actual)."
        case .coreUnavailable:
            return "The OpenIMCore adapter has not been configured."
        case let .core(code, message):
            return message.map { "OpenIMCore error \(code): \($0)" } ?? "OpenIMCore error \(code)."
        }
    }
}
