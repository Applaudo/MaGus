import Foundation

final class PartialUpdate<T> {
    enum PartialUpdateError: Error {
        case noValue(for: String)
    }

    private var storage: [PartialKeyPath<T>: Any] = [:]

    func update<U>(_ path: KeyPath<T, U>, value: U) {
        storage[path] = value
    }

    func value<U>(for path: KeyPath<T, U>) throws -> U {
        guard let value = storage[path] as? U else {
            throw PartialUpdateError.noValue(for: "\(path)")
        }
        return value
    }
}

enum Fields: String, CaseIterable {
    case name
    case platform
    case bundleId
    case deploymentTarget
    case teamId
    case username

   var message: String {
       switch self {
       case .name:
           return "📛 What is your project's name?"
       case .platform:
           return "📖 What platform will you support? (ios/macos)"  
       case .bundleId: 
            return "🎒 What is your Bundle ID?"
       case .deploymentTarget: 
            return "🎹 What is your deployment target?"
       case .teamId: 
            return "👨‍👩‍👧‍👦 What is your team id? (Optional: leave empty if any)"
        case .username:
            return "👔 What is your username for upload to AppStore? (Optional: leave empty if any)"
        }
    } 

    func validate(_ value: String) throws {
        switch self {
        case .name:
            try checkForEmpty(value)
        case .bundleId: 
            try checkForEmpty(value)
        case .deploymentTarget: 
            try validateDeploymentTarget(value)
        case .platform:
            try validatePlatform(value)
        default:
             break
        }
    } 

    func update(partial: PartialUpdate<ProjectInformation>, value: String) throws {
        try validate(value)
        switch self { 
        case .bundleId: 
           partial.update(\.bundleId, value: value)
         case .deploymentTarget: 
           partial.update(\.deploymentTarget, value: Double(value) ?? 0)
        case .name:
           partial.update(\.name, value: value)
        case .platform:
           partial.update(\.platform, value: Platform(rawValue: value) ?? .ios )
        case .teamId: 
           partial.update(\.teamId, value: value)
        case .username:
            partial.update(\.username, value: value)   
        }
    }
}

final class CommandQueue {
    private var fields: [Fields] = Fields.allCases
    private var partial: PartialUpdate<ProjectInformation> = .init()
    
    func process() throws -> ProjectInformation {
       try checkInEnvironment()
       return try ProjectInformation(from: partial)
    }

    private func checkInEnvironment() throws {
        guard let field = fields.first else {
            return
        }
        if let value = ProcessInfo.processInfo.environment[field.rawValue] {
            fields.removeFirst()
            try field.update(partial: partial, value: value)
            if !fields.isEmpty {
                try checkInEnvironment()
            }
        } else {
            processQueue(partial: partial)
        }
    }

    private func processQueue(partial: PartialUpdate<ProjectInformation>)  {
        let field = fields.removeFirst()
        print("\n" + field.message)
        let input = readLine()
        do {
            try field.update(partial: partial, value: input ?? "")
            if !fields.isEmpty {
                processQueue(partial: partial)
            }
        } catch {
            print(error.localizedDescription)
            fields.insert(field, at: 0)
            processQueue(partial: partial)
        }
    }
}
