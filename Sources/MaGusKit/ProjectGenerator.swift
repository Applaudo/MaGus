//
//  ProjectGenerator.swift
//  
//
//  Created by Gustavo Campos on 3/25/20.
//

import Foundation
import PathKit
import Stencil

/// Represents the project information and it's used to feed information
/// for templates
public struct ProjectInformation: Decodable {
    public let name: String
    public let platform: Platform
    public let bundleId: String
    public let deploymentTarget: Double
    public let username: String
    public let teamId: String
    public let matchRepo: String
}

/// Provides options you could use when you want to generate
/// the project
public enum TemplateOption {
    /// Generate all base templates
    case all
    ///  Generate all base templates adding customs
    case allWith(customs: [TemplateInformation])
    /// Generate just custom templates
    case custom(templates: [TemplateInformation])
}

/// Here is where project is generated. This is intended to be used as
/// the entry point to the template generation
public struct ProjectGenerator {
    /// Path where project will be generated
    private let outputPath: Path
    /// Project information
    private let information: ProjectInformation
    private let templateGenerator: TemplateGenerator

    public init(outputPath: Path,
                projectInformation information: ProjectInformation) throws {
        self.outputPath = outputPath
        self.information = information
        self.templateGenerator = TemplateGenerator(outputPath: outputPath)

        try generateBaseFolders()
    }

    /**
        This method generate all project files.
        - Parameters:
        - option: Select what files you want to create.
        - Throws:
        - Any error related to templates or folder generation.
     */
    public func generate(for option: TemplateOption, loader: Loader) throws {
        var templates: [TemplateInformation]
        switch option {
        case .all:
            templates = allTemplates()
        case .allWith(let customs):
            templates = allTemplates() + customs
        case .custom(let customs):
            templates = customs
        }

        try templateGenerator.generate(templates, loader: loader)
    }

    private func allTemplates() -> [TemplateInformation] {
        let xcodeGenTemplate = ProjectTemplateInformation(name: information.name,
                                                          platform: information.platform.name,
                                                          bundleId: information.bundleId,
                                                          deploymentTarget: "\(information.deploymentTarget)" )

        let fastFile = FastfileTemplate(name: information.name,
                                        bundleId: information.bundleId,
                                        username: information.username,
                                        teamId: information.teamId)

        let matchFile = MatchFileTemplate(bundleId: information.bundleId,
                                          username: information.username,
                                          matchRepo: information.matchRepo)

        let gemFile = GemFileTemplate()

        let unitTest = UnitTestTemplate(testPath: outputPath + "\(information.name)Tests")

        return [xcodeGenTemplate, fastFile, matchFile, gemFile, unitTest]
    }

    /// Method that generates all base folders if they don't exist
    private func generateBaseFolders() throws {
        if !outputPath.exists {
            let current =  outputPath
            try current.makeFolders(at: outputPath, projectFiles: information.name)
            let supportingFilesPath = try current.generateBaseProjectDirs(at: outputPath)
            let testPath = outputPath

            let plistGenerated = try PlistGenerator(platform: information.platform).generate()

            let (appDelegate, sceneDelegate) = AppDelegateGenerator(minimumAppVersion: information.deploymentTarget)
                .generate()

            let plistPath = current + outputPath + "info.plist"

            let appDelegatePath = supportingFilesPath + "AppDelegate.swift"

            if let sceneDelegate = sceneDelegate {
                let sceneDelegatePath = supportingFilesPath + "SceneDelegate.swift"
                try sceneDelegatePath.write(sceneDelegate)
            }

            try appDelegatePath.write(appDelegate)
            try plistPath.write(plistGenerated)

            try testPath.generateTestFolder(folderName: "\(information.name)Tests")
        }
    }
}
