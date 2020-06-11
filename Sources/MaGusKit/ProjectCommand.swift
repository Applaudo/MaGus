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
import TOMLDecoder

public struct ProjectCommand: ParsableCommand {
    @Option(default: "", help: "Specify name of the project")
    var name: String
    
    @Option(default: "iOS", help: "Specify platform of the project")
    var platform: String
    
    @Option(default: "", help: "Specify Bundle ID for the project")
    var bundleId: String
    
    @Option(default: 13.0, help: "Specify desired deployment target for the project")
    var deploymentTarget: Double

    @Option(default: "output", help: "Specify path where you want to store generated project")
    var outputPath: String

    @Option(default: "", help: "Team Id you will use to sign in your app")
    var teamId: String

    @Option(default: "", help: "username you will use to sign in certificates and get from developer center")
    var username: String

    @Option(default: "", help: "Path to the Spec that you want use to generate project with custom templates")
    var spec: String

    @Flag(help: "Send flag if you want to use as interactive mode")
    var interactive: Bool

    public init() {}
    
    public func run() throws {
        let outputPath = Path.current + self.outputPath

        if spec.isEmpty && interactive == false {
           try  generateBasicProject()
        } else if spec.isEmpty && interactive {
            try generateProjectFromInteractive()
        } else {
            try generateProjectWithTemplates(outputPath: outputPath, 
                                             specPath: Path(spec))
        }
    }

    private func generateBasicProject() throws {
         let outputPath = Path.current + self.outputPath

        guard let platform = Platform(rawValue: platform.lowercased()) else {
            return
        }
        
        let information = try ProjectInformation(name: name,
                                             platform: platform,
                                             bundleId: bundleId,
                                             deploymentTarget: deploymentTarget,
                                             username: username,
                                             teamId: teamId)

        try generateBasicProject(outputPath: outputPath, information: information)
    }

    private func generateProjectFromInteractive() throws {
        let outputPath = Path.current + self.outputPath
        let commandQueue = CommandQueue()
        let projectInformation = try commandQueue.process()

        try generateBasicProject(outputPath: outputPath, information: projectInformation)
    }

    private func generateBasicProject(outputPath: Path, information: ProjectInformation) throws {
         let projectGenerator = try ProjectGenerator(outputPath: outputPath,
                                                    projectInformation: information)

         try projectGenerator.generate(for: .all, loader: DictionaryLoader(templates: Templates.shared.templates))
    }

    private func generateProjectWithTemplates(outputPath: Path, specPath: Path) throws {
        let commandQueue = CommandQueue()
        let projectInformation = try commandQueue.process()
        let parser = try ConfigurationFileParser(path: specPath)

        let projectConfiguration = try parser.decode()
        let scaffolder = try Scaffolder(outputPath: outputPath, 
                                        projectConfiguration: projectConfiguration,
                                        projectInformation: projectInformation)

        try scaffolder.generate()
    }
}
