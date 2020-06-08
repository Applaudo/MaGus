enum ValidationError: Error {
    case emptyValue
    case invalidDeploymentTarget
    case invalidPlatform
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