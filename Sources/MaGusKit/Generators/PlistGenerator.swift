//
//  PlistGenerator.swift
//  
//
//  Created by Gustavo Campos on 3/20/20.
//

import Foundation

public enum Platform: String {
    case ios = "ios"
    case macos = "macos"

    var name: String {
        switch self {
        case .ios:
            return "iOS"
        default:
            return "MacOS"
        }
    }
}

/// Generate a formatted property list according to the kind of project to generate.
struct PlistGenerator {
    private var information: [String: Any] = [:]

    init(platform: Platform) {
        self.setupBaseContent()

        switch platform {
        case .ios:
            self.setupiOS()
        case .macos:
            self.setupMacOS()
        }
    }

    func generate() throws -> Data {
         try PropertyListSerialization.data(fromPropertyList: information,
                                                  format: .xml,
                                                  options: .zero)
    }

    private mutating func setupBaseContent() {
        self.information = [
            "CFBundleDevelopmentRegion": "$(DEVELOPMENT_LANGUAGE)",
            "CFBundleExecutable": "$(EXECUTABLE_NAME)",
            "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
            "CFBundleInfoDictionaryVersion": "6.0",
            "CFBundleName": "$(PRODUCT_NAME)",
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "CFBundlePackageType": "APPL"
        ]
    }

    private mutating func setupiOS() {
        let iosInformation: [String: Any] =  [
            "LSRequiresIPhoneOS": true,
            "UILaunchStoryboardName": "LaunchScreen",
            "UIRequiredDeviceCapabilities": [
                "armv7",
            ],
            "UISupportedInterfaceOrientations": [
                "UIInterfaceOrientationPortrait",
                "UIInterfaceOrientationLandscapeLeft",
                "UIInterfaceOrientationLandscapeRight",
            ],
            "UISupportedInterfaceOrientations~ipad": [
                "UIInterfaceOrientationPortrait",
                "UIInterfaceOrientationPortraitUpsideDown",
                "UIInterfaceOrientationLandscapeLeft",
                "UIInterfaceOrientationLandscapeRight",
            ],
        ]

        setupCustomValues(iosInformation)
    }

    private mutating func setupMacOS() {
        let macOS: [String: Any] = [
            "CFBundleIconFile": "",
            "LSMinimumSystemVersion": "$(MACOSX_DEPLOYMENT_TARGET)",
            "NSMainStoryboardFile": "Main",
            "NSPrincipalClass": "NSApplication",
            "NSHumanReadableCopyright": "Copyright ©. All rights reserved."
        ]

        setupCustomValues(macOS)
    }

    private mutating func setupCustomValues(_ values: [String: Any]) {
        values.forEach { (key, value) in
            self.information[key] = value
        }
    }
}
