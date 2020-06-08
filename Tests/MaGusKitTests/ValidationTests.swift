import XCTest
@testable import MaGusKit

class ValidationTests: XCTestCase {
    func testEmptyValidation() throws {
        // Given
        let emptyValue = " "
        let value = "people"

        // Then
        XCTAssertThrowsError(try checkForEmpty(emptyValue))
        XCTAssertNoThrow(try checkForEmpty(value))
    }

    func testValidateDeploymentTarget() throws {
        // Given
        let invalidNumber = "3fffgh"
        let invalidVersion = "9"
        let validVersion = "12"

        // Then
        XCTAssertThrowsError(try validateDeploymentTarget(invalidNumber))
        XCTAssertThrowsError(try validateDeploymentTarget(invalidVersion))
        XCTAssertNoThrow(try validateDeploymentTarget(validVersion))
    }

     func testValidatePlatform() throws {
        // Given
        let invalidPlatform = "iOxd"
        let iosPlatform = "ios"
        let macPlatform = "macos"

        // Then
        XCTAssertThrowsError(try validatePlatform(invalidPlatform))
        XCTAssertNoThrow(try validatePlatform(iosPlatform))
        XCTAssertNoThrow(try validatePlatform(macPlatform))
    }
}
