//
//  TemplateGeneratorTests.swift
//
//
//  Created by Manuel Sánchez on 3/3/20.
//

@testable import MaGusKit
import XCTest
import PathKit

final class TemplateGeneratorTests: XCTestCase {
    func testGenerateJson() throws {
        // Given
        let information = ProjectTemplateInformation(name: "TestName",
                                                     platform: "iOS",
                                                     bundleId: "com.example.bundle",
                                                     deploymentTarget: "13.0")
        let generator = TemplateGenerator(outputPath: .current)
        
        // When
        let renderedTemplate = try generator.generate(information: information)
        
        // Then
        XCTAssertEqual(Mock.generatedJSON, renderedTemplate)
    }

    func testGenerateFastFile() throws {
        // Given
        let information = FastfileTemplate(name: "TestName",
                                           bundleId:  "com.example.bundle",
                                           username: "test@test.com",
                                           teamId: "teamTest")
        let generator = TemplateGenerator(outputPath: .current)

        // When
        let renderedTemplate = try generator.generate(information: information)

        // Then
        XCTAssertEqual(Mock.fastFileGenerated, renderedTemplate)
    }

    func testGenerateMatchFile() throws {
        // Given
        let information = MatchFileTemplate(bundleId: "com.example.bundle",
                                            username: "test@test.com",
                                            matchRepo: "")
        let generator = TemplateGenerator(outputPath: .current)

        // When
        let renderedTemplate = try generator.generate(information: information)

        // Then
        XCTAssertEqual(Mock.matchFileGenerated, renderedTemplate)
    }
}
