//
//  ProjectCommand.swift
//  
//
//  Created by Manuel Sánchez on 3/2/20.
//

import ArgumentParser
import Foundation
import PathKit
import Stencil

public struct ProjectCommand: ParsableCommand {
    @Option(help: "Specify name of the project")
    var name: String
    
    @Option(default: "iOS", help: "Specify platform of the project")
    var platform: String
    
    @Option(help: "Specify Bundle ID for the project")
    var bundleId: String
    
    @Option(help: "Specify desired deployment target for the project")
    var deploymentTarget: Double

    @Option(default: "output", help: "Specify path where you want to store generated project")
    var outputPath: String

    @Option(help: "Team Id you will use to sign in your app")
    var teamId: String

    @Option(help: "username you will use to sign in certificates and get from developer center")
    var username: String

    @Option(default: "", help: "Repo where your certificates are stored")
    var matchRepo: String

    public init() {}
    
    public func run() throws {
        let outputPath = Path.current + self.outputPath

        guard let platform = Platform(rawValue: platform.lowercased()) else {
            return
        }

        let information = ProjectInformation(name: name,
                                             platform: platform,
                                             bundleId: bundleId,
                                             deploymentTarget: deploymentTarget,
                                             username: username,
                                             teamId: teamId,
                                             matchRepo: matchRepo)

        let projectGenerator = try ProjectGenerator(outputPath: outputPath,
                                                    projectInformation: information)

        try projectGenerator.generate(for: .all, loader: DictionaryLoader(templates: Templates.shared.templates))
        try projectGenerator.generate(for: .allWith(customs: []), 
                                      loader: DictionaryLoader(templates: Templates.shared.templates))
        try projectGenerator.generate(for: .custom(templates: []),
                                      loader: DictionaryLoader(templates: Templates.shared.templates))
    }
}
