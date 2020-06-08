import XCTest
@testable import MaGusKit

class FieldsTests: XCTestCase {
    func testNameField() throws {
        // Given
        let field = Fields.name
        let partial = PartialUpdate<ProjectInformation>()

        // When
        XCTAssertNoThrow(try field.update(partial: partial, 
                                              value: "Play"))
        XCTAssertThrowsError(try field.update(partial: partial, 
                                              value: "  ")) 
        // Then
        let name = try partial.value(for: \.name)    
        XCTAssertEqual(name, "Play")                                                                      
    }

    func testPlatformField() throws {
        // Given
        let field = Fields.platform
        let partial = PartialUpdate<ProjectInformation>()

        // When
        XCTAssertNoThrow(try field.update(partial: partial, 
                                              value: "ios"))
        XCTAssertThrowsError(try field.update(partial: partial, 
                                              value: "  ")) 
        // Then
        let platform = try partial.value(for: \.platform)    
        XCTAssertEqual(platform, .ios)                                                                      
    }

    func testBundleIdField() throws {
        // Given
        let field = Fields.bundleId
        let partial = PartialUpdate<ProjectInformation>()

        // When
        XCTAssertNoThrow(try field.update(partial: partial, 
                                              value: "bundle"))
        XCTAssertThrowsError(try field.update(partial: partial, 
                                              value: "  ")) 
        // Then
        let bundle = try partial.value(for: \.bundleId)    
        XCTAssertEqual(bundle, "bundle")                                                                      
    }

     func testDeploymentTarget() throws {
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
