import Foundation
import PathKit
import AnyCodable
import Stencil

/// Represents a template information from a configuration file
public struct CustomTemplate: TemplateInformation, Decodable {
    public var context: TemplateContext 

    public var templateName: String

    public var outputFilePath: Path

    public var fileName: String

    public let templatePath: Path

    enum CodingKeys: String, CodingKey {
        case context
        case templateName
        case outputFilePath
        case fileName
        case templatePath
    }

    init(context: TemplateContext, 
        templateName: String, 
        outputFilePath: Path, 
        fileName: String, 
        templatePath: Path) {
        self.context = context
        self.templateName = templateName
        self.outputFilePath = outputFilePath
        self.fileName = fileName
        self.templatePath = templatePath
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        context = try values.decodeIfPresent([String: AnyDecodable].self, forKey: .context) ?? [:]
        templateName = try values.decode(String.self, forKey: .templateName)
        let outputFile = try values.decode(String.self, forKey: .outputFilePath)
        outputFilePath = Path(outputFile)
        fileName = try values.decode(String.self, forKey: .fileName)
        let templatePath = try values.decode(String.self, forKey: .templatePath)
        self.templatePath = Path(templatePath)
    }
}

public struct ProjectConfiguration: Decodable {
    public let projectInformation: ProjectInformation
    public let templates: [CustomTemplate]
}

public struct Scaffolder {
    private let projectConfiguration: ProjectConfiguration

    private let projectGenerator: ProjectGenerator

    private let outputPath: Path

    init(outputPath: Path, 
        projectInformation: ProjectConfiguration) throws {
        self.outputPath = outputPath
        self.projectConfiguration = projectInformation
        self.projectGenerator = try ProjectGenerator(outputPath: outputPath, 
                                                 projectInformation: projectConfiguration.projectInformation)
    }

    public func generate() throws {
        let paths = projectConfiguration.templates
                    .map { Path.current + $0.templatePath }
                    .filter { $0.exists }

        try projectGenerator.generate(for: .all, 
                                      loader: DictionaryLoader(templates: Templates.shared.templates))
        try projectGenerator.generate(for: .custom(templates: projectConfiguration.templates),
                                      loader: FileSystemLoader(paths: paths))
    }
}