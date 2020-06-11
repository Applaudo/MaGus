import Foundation

enum ValidationError: LocalizedError {
    case emptyValue
    case invalidDeploymentTarget
    case invalidPlatform

    var errorDescription: String? {
        switch self {
          case .emptyValue:
             return "Value shouldn't be empty"
          case .invalidDeploymentTarget:
            return "Deployment target is invalid (it should be greather than 10.0)"
           case .invalidPlatform:
            return "Selected platform is invalid (write ios or macos)"     
        }
    }

    var localizedDescription: String {
        errorDescription ?? ""
    }
}

func checkForEmpty(_ value: String) throws {
    if value.trimmingCharacters(in: .whitespaces).isEmpty {
        throw ValidationError.emptyValue
    }
}

func validateDeploymentTarget(_ target: String) throws {
    guard let target = Double(target) else {
        throw ValidationError.invalidDeploymentTarget
    }

    if target < 10.0 {
        throw  ValidationError.invalidDeploymentTarget
    }
}

func validatePlatform(_ platform: String) throws {
    let platform = Platform(rawValue: platform)
    
    if platform == nil {
        throw ValidationError.invalidPlatform
    }
}