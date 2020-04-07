//
//  TemplateGeneratorTests.swift
//
//
//  Created by Manuel Sánchez on 3/3/20.
//

@testable import MaGusKit
import XCTest
import PathKit
import Stencil
import TOMLDecoder
import AnyCodable

final class ScalffoldingTest: XCTestCase {

    let path = Path.current + Path("outputScalffold")

    override func tearDown() {
        super.tearDown()
        try? path.delete()
    }

    func testParseTOMLFileWithVariables() throws {
        // Given
        let tomlFile = """
        [projectInformation]
        name = "MyApp"
        platform = "ios"
        bundleId = "com.mycompany.myapp"
        deploymentTarget = 13.0
        username = "test"
        teamId = "test"
        matchRepo = "test"

            [[templates]]
            templateName = "Jenkinsfile"
            outputFilePath = "./output/JenkinsFile"
            fileName = "JenkinsFile"
            templatePath = "./MyTemplates"

            [templates.context]
             projectId = "ApplaudoTest"
        """
        let projectInformation = ProjectInformation(name: "MyApp", 
                                                    platform: .ios, 
                                                    bundleId: "com.mycompany.myapp", 
                                                    deploymentTarget: 13.0,
                                                    username: "test", 
                                                    teamId: "test",
                                                    matchRepo: "test")
        // When
        let projectConfiguration = try TOMLDecoder().decode(ProjectConfiguration.self, from: tomlFile)

        // Then
        let template = try XCTUnwrap(projectConfiguration.templates.first)

        let anyDecodable = try XCTUnwrap(template.context["projectId"] as? AnyDecodable)
        XCTAssertEqual(projectConfiguration.projectInformation, projectInformation)
        XCTAssertEqual(anyDecodable.value as? String, "ApplaudoTest")
        XCTAssertEqual(template.fileName, "JenkinsFile")
        XCTAssertEqual(template.outputFilePath, "./output/JenkinsFile")
        XCTAssertEqual(template.templatePath, "./MyTemplates")
    }

    func testParseTOMLWhenThereAreNoContextVariables() throws {
        // Given
        let tomlFile = """
        [projectInformation]
        name = "MyApp"
        platform = "ios"
        bundleId = "com.mycompany.myapp"
        deploymentTarget = 13.0
        username = "test"
        teamId = "test"
        matchRepo = "test"

            [[templates]]
            templateName = "Jenkinsfile"
            outputFilePath = "./output/JenkinsFile"
            fileName = "JenkinsFile"
            templatePath = "./MyTemplates"
        """
        let projectInformation = ProjectInformation(name: "MyApp", 
                                                    platform: .ios, 
                                                    bundleId: "com.mycompany.myapp", 
                                                    deploymentTarget: 13.0,
                                                    username: "test", 
                                                    teamId: "test",
                                                    matchRepo: "test")
        // When
        let projectConfiguration = try TOMLDecoder().decode(ProjectConfiguration.self, from: tomlFile)

        // Then
        let template = try XCTUnwrap(projectConfiguration.templates.first)

        XCTAssertEqual(projectConfiguration.projectInformation, projectInformation)
        XCTAssertEqual(template.context.isEmpty, true)
        XCTAssertEqual(template.fileName, "JenkinsFile")
        XCTAssertEqual(template.outputFilePath, "./output/JenkinsFile")
        XCTAssertEqual(template.templatePath, "./MyTemplates")
    }

     func testGenerateFilesFromConfigurationFile() throws {
           // Given
        let tomlFile = """
        [projectInformation]
        name = "MyApp"
        platform = "ios"
        bundleId = "com.mycompany.myapp"
        deploymentTarget = 13.0
        username = "test"
        teamId = "test"
        matchRepo = "test"

            [[templates]]
            templateName = "CustomTemplate.stencil"
            outputFilePath = "./"
            fileName = "MyCustomTemplate"
            templatePath = "./Tests/TestTemplates"

            [templates.context]
             text = "Hello World"
        """

        // When
        let projectConfiguration = try TOMLDecoder().decode(ProjectConfiguration.self, from: tomlFile)
        let scalffolder = try Scalffolder(outputPath: path,
                                         projectInformation: projectConfiguration)

        try scalffolder.generate()

        let expectedTemplate = """
        My Custom Template
        Hello World
        """

        // Then
        let path = self.path + Path("MyCustomTemplate")
        let generatedTemplate: String = try path.read()

        XCTAssertEqual(path.exists, true)
        XCTAssertEqual(generatedTemplate, expectedTemplate)
     }
}