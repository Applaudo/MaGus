import Foundation
import Yams
import PathKit
import TOMLDecoder

public enum SupportedFile: String {
    case json
    case yml
    case toml
}

enum ConfigurationParserError: Error {
    case unsupportedFile
    case missingFile
}

public struct ConfigurationFileParser {
    private let fileType: SupportedFile
    private let path: Path
    
    init(fileType: SupportedFile, path: Path) {
        self.fileType = fileType
        self.path = path
    }

    init(path: Path) throws {
        let fileExtension = path.extension ?? ""
        guard let fileType = SupportedFile(rawValue: fileExtension) else {
            throw ConfigurationParserError.unsupportedFile
        }

        self.fileType = fileType
        self.path = path
    }

    public func decode() throws -> ProjectConfiguration {
        let value: String = try path.read()
        switch fileType {
            case .toml:
                return try TOMLDecoder().decode(ProjectConfiguration.self, from: value)
            case .yml:
                return try YAMLDecoder().decode(ProjectConfiguration.self, from: value)
            case .json:
                return try JSONDecoder().decode(ProjectConfiguration.self, from: value.data(using: .utf8) ?? Data())
        }
    }
}