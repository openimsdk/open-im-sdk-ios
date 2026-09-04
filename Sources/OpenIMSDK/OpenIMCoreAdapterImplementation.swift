#if canImport(OpenIMCore)

    import Foundation
    import OpenIMCore

    /// Adapter for the gomobile-generated OpenIMCore module.
    ///
    /// This file is conditionally compiled so the Swift package can still run its
    /// model and state-machine tests without checking a large XCFramework into the
    /// source repository. CocoaPods (and the future SPM binary target) provide the
    /// `OpenIMCore` module at integration time.
    public final class NativeOpenIMCoreAdapter: OpenIMCoreAdapter {
        private let lock = NSLock()
        private var connectionListener: ConnectionListener?
        private var pendingCallbacks: [UUID: CoreCallback] = [:]

        public init() {}

        public func initialize(
            configuration: OpenIMConfiguration,
            eventHandler: @escaping (OpenIMCoreEvent) -> Void
        ) throws {
            let listener = ConnectionListener(eventHandler: eventHandler)
            let operationID = UUID().uuidString
            let configJSON = try makeConfigurationJSON(configuration)

            lock.lock()
            connectionListener = listener
            lock.unlock()

            guard Open_im_sdkInitSDK(listener, operationID, configJSON) else {
                lock.lock()
                connectionListener = nil
                lock.unlock()
                throw OpenIMError.core(code: -1, message: "OpenIMCore initialization failed")
            }
        }

        public func login(
            userID: String,
            token: String,
            completion: @escaping (Result<Void, OpenIMError>) -> Void
        ) {
            let callback = retainCallback(completion)
            Open_im_sdkLogin(callback, UUID().uuidString, userID, token)
        }

        public func logout(completion: @escaping (Result<Void, OpenIMError>) -> Void) {
            let callback = retainCallback(completion)
            Open_im_sdkLogout(callback, UUID().uuidString)
        }

        public func uninitialize() {
            Open_im_sdkUnInitSDK(UUID().uuidString)
            lock.lock()
            connectionListener = nil
            let callbacks = Array(pendingCallbacks.values)
            pendingCallbacks.removeAll()
            lock.unlock()

            callbacks.forEach { $0.cancel() }
        }

        private func makeConfigurationJSON(_ configuration: OpenIMConfiguration) throws -> String {
            let payload: [String: Any] = [
                "platformID": configuration.platform.rawValue,
                "apiAddr": configuration.apiAddress,
                "wsAddr": configuration.websocketAddress,
                "dataDir": configuration.dataDirectory?.path ?? "",
                "logLevel": configuration.logLevel,
                "isCompression": configuration.compression,
                "logFilePath": configuration.logFileURL?.path ?? "",
                "isLogStandardOutput": configuration.logToStandardOutput,
                "systemType": configuration.systemType,
            ]

            let data = try JSONSerialization.data(withJSONObject: payload, options: [])
            guard let json = String(data: data, encoding: .utf8) else {
                throw OpenIMError.core(code: -2, message: "Unable to encode OpenIMCore configuration")
            }
            return json
        }

        private func retainCallback(
            _ completion: @escaping (Result<Void, OpenIMError>) -> Void
        ) -> CoreCallback {
            let id = UUID()
            let callback = CoreCallback(
                completion: completion,
                onFinished: { [weak self] in
                    self?.releaseCallback(id)
                }
            )
            lock.lock()
            pendingCallbacks[id] = callback
            lock.unlock()
            return callback
        }

        private func releaseCallback(_ id: UUID) {
            lock.lock()
            pendingCallbacks.removeValue(forKey: id)
            lock.unlock()
        }
    }

    private final class CoreCallback: NSObject, Open_im_sdk_callbackBaseProtocol {
        private let lock = NSLock()
        private let completion: (Result<Void, OpenIMError>) -> Void
        private let onFinished: () -> Void
        private var isFinished = false

        init(
            completion: @escaping (Result<Void, OpenIMError>) -> Void,
            onFinished: @escaping () -> Void
        ) {
            self.completion = completion
            self.onFinished = onFinished
        }

        func onError(_ errCode: Int32, errMsg: String?) {
            finish(.failure(.core(code: Int(errCode), message: errMsg)))
        }

        func onSuccess(_: String?) {
            finish(.success(()))
        }

        func cancel() {
            finish(.failure(.cancelled))
        }

        private func finish(_ result: Result<Void, OpenIMError>) {
            lock.lock()
            guard !isFinished else {
                lock.unlock()
                return
            }
            isFinished = true
            lock.unlock()

            completion(result)
            onFinished()
        }
    }

    private final class ConnectionListener: NSObject, Open_im_sdk_callbackOnConnListenerProtocol {
        private let eventHandler: (OpenIMCoreEvent) -> Void

        init(eventHandler: @escaping (OpenIMCoreEvent) -> Void) {
            self.eventHandler = eventHandler
        }

        func onConnectFailed(_ errCode: Int32, errMsg: String?) {
            eventHandler(.connectionFailed(code: Int(errCode), message: errMsg))
        }

        func onConnectSuccess() {
            eventHandler(.connected)
        }

        func onConnecting() {
            eventHandler(.connecting)
        }

        func onKickedOffline() {
            eventHandler(.kickedOffline)
        }

        func onUserTokenExpired() {
            eventHandler(.tokenExpired)
        }

        func onUserTokenInvalid(_ errMsg: String?) {
            eventHandler(.tokenInvalid(message: errMsg))
        }
    }

#endif
