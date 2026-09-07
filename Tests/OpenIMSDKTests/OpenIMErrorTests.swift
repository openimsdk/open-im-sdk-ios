import Foundation
@testable import OpenIMSDK
import XCTest

final class OpenIMErrorTests: XCTestCase {
    func testExpectedStateCases() {
        XCTAssertEqual(OpenIMError.ExpectedState.idle, .idle)
        XCTAssertEqual(OpenIMError.ExpectedState.initialized, .initialized)
        XCTAssertEqual(OpenIMError.ExpectedState.loggedIn, .loggedIn)
        XCTAssertNotEqual(OpenIMError.ExpectedState.idle, .initialized)
    }

    func testErrorDescriptions() {
        let invalidState = OpenIMError.invalidState(expected: .initialized, actual: .idle)
        XCTAssertEqual(
            invalidState.errorDescription,
            "Invalid client state. Expected initialized, got idle."
        )

        let cancelled = OpenIMError.cancelled
        XCTAssertEqual(
            cancelled.errorDescription,
            "The OpenIMCore operation was cancelled."
        )

        let coreUnavailable = OpenIMError.coreUnavailable
        XCTAssertEqual(
            coreUnavailable.errorDescription,
            "The OpenIMCore adapter has not been configured."
        )

        let coreWithMsg = OpenIMError.core(code: 1001, message: "Network timed out")
        XCTAssertEqual(
            coreWithMsg.errorDescription,
            "OpenIMCore error 1001: Network timed out"
        )

        let coreWithoutMsg = OpenIMError.core(code: 1002, message: nil)
        XCTAssertEqual(
            coreWithoutMsg.errorDescription,
            "OpenIMCore error 1002."
        )

        let decodingFailed = OpenIMError.decodingFailed(message: "Corrupt JSON")
        XCTAssertEqual(
            decodingFailed.errorDescription,
            "Failed to decode response: Corrupt JSON"
        )

        let encodingFailed = OpenIMError.encodingFailed(message: "Cannot encode")
        XCTAssertEqual(
            encodingFailed.errorDescription,
            "Failed to encode parameter: Cannot encode"
        )

        let invalidParameter = OpenIMError.invalidParameter(message: "userID empty")
        XCTAssertEqual(
            invalidParameter.errorDescription,
            "Invalid parameter: userID empty"
        )
    }

    func testErrorEquality() {
        XCTAssertEqual(OpenIMError.cancelled, OpenIMError.cancelled)
        XCTAssertEqual(OpenIMError.coreUnavailable, OpenIMError.coreUnavailable)
        XCTAssertEqual(
            OpenIMError.core(code: 1, message: "a"),
            OpenIMError.core(code: 1, message: "a")
        )
        XCTAssertNotEqual(
            OpenIMError.core(code: 1, message: "a"),
            OpenIMError.core(code: 2, message: "a")
        )
    }
}
