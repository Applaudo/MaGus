import XCTest
@testable import MaGusKit

class ProjectInformationTest: XCTestCase {
  func testProjectInformationWhenAFieldIsEmpty() throws {
        // Given
        let name = "My Project"
        let platform = Platform.ios
        let bundleId = "test"
        let deploymentTarget = 13.0
        let username = ""
        let teamId = ""

        // When
         XCTAssertThrowsError(try ProjectInformation(name: name, 
                                                    platform: platform,
                                                    bundleId: bundleId,
                                                    deploymentTarget: deploymentTarget, 
                                                    username: username,
                                                    teamId: teamId))
    }

    func testProjectInformationNotEmptyFields() throws {
        // Given
        let name = "My Project"
        let platform = Platform.ios
        let bundleId = "test"
        let deploymentTarget = 13.0
        let username = "test"
        let teamId = "test"

        // When
         XCTAssertNoThrow(try ProjectInformation(name: name, 
                                                    platform: platform,
                                                    bundleId: bundleId,
                                                    deploymentTarget: deploymentTarget, 
                                                    username: username,
                                                    teamId: teamId))
    }
}