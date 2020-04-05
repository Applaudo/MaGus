//
//  TemplateGenerator.swift
//  
//
//  Created by Manuel Sánchez on 3/3/20.
//

import Stencil
import Foundation
import PathKit
import AnyCodable

/// Alias used to dictionary type that applies values to a template
public typealias TemplateContext = [String: Any]

/**
 Abstract template information.

 ###  Note

 If you want to create and use your custom template, you must implement this
 protocol in your template representation type.
 */
public protocol TemplateInformation {
    /// Represents all of the variables that will be applied to the template
    var context: TemplateContext { get }
    /// This is the name of the template registered in **Templates**
    var templateName: String { get }
    /**
     Path where file generated will be saved to.
     ### Note
     File will be written always on the output path defined on the *output* argument
     */
    var outputFilePath: Path { get }
    /// the name of the file. If you want a file with a custom extension
    /// write it like: "myFile.swift"
    var fileName: String { get }
}

/// Generate all of the templates and write them in the defined path
public struct TemplateGenerator {
    /// Root path where templates will be written to.
    private let outputPath: Path

    /**
     Initializer for Template Generator.

     - Parameters:
     - outputPath: path where templates will be saved to.
     - template: Type where all templates are registered to,
     By Default accepts a global template store.
     */
    public init(outputPath: Path) {
        self.outputPath = outputPath
    }

    /**
     Generates all of the templates passed as parameter, also generates
     folders where templates will be stored to, if needed.

     - Parameters:
     - templates: Array of *TemplateInformation* with all of templates to be generated

     - Throws: Throws an error if folder iss not able to be created
     Template doesn't exist or there was a problem writing the template itself
     */
    public func generate(_ templates: [TemplateInformation],
                         loader: Loader) throws {
        for template in templates {
            let environment = Environment(loader: loader)

            let renderedTemplate = try environment.renderTemplate(name: template.templateName,
                                                                  context: template.context)

            let outputPath = self.outputPath + template.outputFilePath
            if !outputPath.exists && !template.outputFilePath.url.absoluteString.isEmpty {
                try outputPath.mkdir()
            }
            
            try write(template: renderedTemplate, outputPath: outputPath + template.fileName)
        }
    }

    /**
     Generates a render template and returns as String

     - Throws: Throws an error if template doesn't exist or there was problem generating
     the template
     */
    public func generate(information: TemplateInformation,
                         loader: Loader) throws -> String {
        let environment = Environment(loader: loader)
        
        let renderedTemplate = try environment.renderTemplate(name: information.templateName, context: information.context)
        
        return renderedTemplate
    }

    func write(template: String, outputPath path: Path) throws {
        try path.write(template)
    }
}

/// Template representation for xcodegen configuration
public struct ProjectTemplateInformation: TemplateInformation {
    /// Name of the application
    public let name: String
    /// App's platform
    public let platform: String
    public let bundleId: String
    /// Minimum deployment Target
    public let deploymentTarget: String
    
    public var templateName: String {
        Constants.xcodeGenFile
    }

    public var outputFilePath: Path {
        ""
    }

    public var fileName: String {
        "project.json"
    }
    
    public var context: TemplateContext {
        [
            "projectName": name,
            "targetName": name,
            "platform": platform,
            "bundleId": bundleId,
            "deploymentTarget": deploymentTarget
        ]
    }
}

/// Template representation for Fastfile
public struct FastfileTemplate: TemplateInformation {
    /// Name of the app
    public let name: String
    public let bundleId: String
    /// username to be used to Code Sign the app
    public let username: String
    /// Team app where belongs to
    public let teamId: String

    public var context: TemplateContext {
        [
            "name": name,
            "bundleId": bundleId,
            "username": username,
            "teamId": teamId
        ]
    }

    public var templateName: String {
        Constants.fastfile
    }

    public var outputFilePath: Path {
        .fastfile
    }

    public var fileName: String {
        "Fastfile"
    }
}

/// Template representation of match file
public struct MatchFileTemplate: TemplateInformation {
    public let bundleId: String
    /// Username to be used to Code Sign the app
    public let username: String
    /// Url to repo where certificates are stored
    public let matchRepo: String

    public var context: TemplateContext {
        [
            "bundleId": bundleId,
            "matchRepo": matchRepo,
            "username": username
        ]
    }

    public var templateName: String {
        Constants.matchFile
    }

    public var outputFilePath: Path {
        .matchFile
    }

    public var fileName: String {
        "MatchFile"
    }
}
