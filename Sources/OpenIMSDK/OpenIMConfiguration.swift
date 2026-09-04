import Foundation

/// Configuration required to start an OpenIM client.
public struct OpenIMConfiguration: Equatable, Sendable {
    public enum Platform: Int, Sendable {
        case iPhone = 1
        case android = 2
        case windows = 3
        case macOS = 4
        case web = 5
        case miniWeb = 6
        case linux = 7
        case androidPad = 8
        case iPad = 9
    }

    public var apiAddress: String
    public var websocketAddress: String
    public var dataDirectory: URL?
    public var platform: Platform
    public var logLevel: Int
    public var compression: Bool
    public var logToStandardOutput: Bool
    public var logFileURL: URL?
    public var systemType: String

    public init(
        apiAddress: String,
        websocketAddress: String,
        dataDirectory: URL? = nil,
        platform: Platform = .iPhone,
        logLevel: Int = 6,
        compression: Bool = false,
        logToStandardOutput: Bool = true,
        logFileURL: URL? = nil,
        systemType: String = "iOS"
    ) {
        self.apiAddress = apiAddress
        self.websocketAddress = websocketAddress
        self.dataDirectory = dataDirectory
        self.platform = platform
        self.logLevel = logLevel
        self.compression = compression
        self.logToStandardOutput = logToStandardOutput
        self.logFileURL = logFileURL
        self.systemType = systemType
    }
}
