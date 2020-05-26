@testable import MaGusKit
import XCTest
import PathKit
import AnyCodable

final class ConfigurationFileParserTest: XCTestCase { 
    func testParseFromJSON() throws {
        // Given
        let path =  Path.current + Path("templates/ProjectJSONInformation.json")
        let parser = try ConfigurationFileParser(path: path)  
        let projectInformation = try ProjectInformation(name: "MyApp", 
                                                    platform: .ios, 
                                                    bundleId: "com.mycompany.app", 
                                                    deploymentTarget: 13,
                                                    username: "test", 
                                                    teamId: "test")

        // When
        let projectConfiguration = try parser.decode()

         // Then
        let template = try XCTUnwrap(projectConfiguration.templates.first)

        let anyDecodable = try XCTUnwrap(template.context["text"] as? AnyDecodable)
        XCTAssertEqual(projectConfiguration.projectInformation, projectInformation)
        XCTAssertEqual(anyDecodable.value as? String, "Hello World")
        XCTAssertEqual(template.fileName, "MyCustomTemplate")
        XCTAssertEqual(template.outputFilePath, "./output/JenkinsFile")
        XCTAssertEqual(template.templatePath, "/Tests/TestTemplates")
    }

    func testParseFromYML() throws {
        // Given
        let path =  Path.current + Path("templates/ProjectYMLInformation.yml")
        let parser = try ConfigurationFileParser(path: path)  
        let projectInformation = try ProjectInformation(name: "MyApp", 
                                                    platform: .ios, 
                                                    bundleId: "com.mycompany.app", 
                                                    deploymentTarget: 13,
                                                    username: "test", 
                                                    teamId: "test")

        // When
        let projectConfiguration = try parser.decode()

         // Then
        let template = try XCTUnwrap(projectConfiguration.templates.first)

        let anyDecodable = try XCTUnwrap(template.context["text"] as? AnyDecodable)
        XCTAssertEqual(projectConfiguration.projectInformation, projectInformation)
        XCTAssertEqual(anyDecodable.value as? String, "Hello World")
        XCTAssertEqual(template.fileName, "MyCustomTemplate")
        XCTAssertEqual(template.outputFilePath, "./output/JenkinsFile")
        XCTAssertEqual(template.templatePath, "/Tests/TestTemplates")
    }

     func testParseFromTOML() throws {
        // Given
        let path =  Path.current + Path("templates/ProjectTOMLInformation.toml")
        let parser = try ConfigurationFileParser(path: path)  
        let projectInformation = try ProjectInformation(name: "MyApp", 
                                                    platform: .ios, 
                                                    bundleId: "com.mycompany.myapp", 
                                                    deploymentTarget: 13,
                                                    username: "test", 
                                                    teamId: "test")

        // When
        let projectConfiguration = try parser.decode()

         // Then
        let template = try XCTUnwrap(projectConfiguration.templates.first)

        let anyDecodable = try XCTUnwrap(template.context["text"] as? AnyDecodable)
        XCTAssertEqual(projectConfiguration.projectInformation, projectInformation)
        XCTAssertEqual(anyDecodable.value as? String, "ApplaudoTest")
        XCTAssertEqual(template.fileName, "JenkinsFile")
        XCTAssertEqual(template.outputFilePath, "./output/JenkinsFile")
        XCTAssertEqual(template.templatePath, "./MyTemplates")
    }
}