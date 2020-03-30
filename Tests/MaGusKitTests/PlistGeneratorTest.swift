//
//  PlistGeneratorTest.swift
//  
//
//  Created by Gustavo Campos on 3/21/20.
//

@testable import MaGusKit
import XCTest
import PathKit

final class PlistGeneratorTest: XCTestCase {
    func testGeneratePlistForiOS() throws {
        // Given
        let generator = PlistGenerator(platform: .ios)

        let informationExpected: [String: Any] = [
            "CFBundleDevelopmentRegion": "$(DEVELOPMENT_LANGUAGE)",
            "CFBundleExecutable": "$(EXECUTABLE_NAME)",
            "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
            "CFBundleInfoDictionaryVersion": "6.0",
            "CFBundleName": "$(PRODUCT_NAME)",
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "CFBundlePackageType": "APPL",
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

        // When
        let plistGenerated = try generator.generate()

        // Then
        let dataExpected = try PropertyListSerialization.data(fromPropertyList: informationExpected,
        format: .xml,
        options: .zero)

       XCTAssertEqual(plistGenerated, dataExpected)
    }

    func testGeneratePlistForMacOS() throws {
        // Given
         let generator = PlistGenerator(platform: .macos)

         let informationExpected: [String: Any] = [
            "CFBundleDevelopmentRegion": "$(DEVELOPMENT_LANGUAGE)",
            "CFBundleExecutable": "$(EXECUTABLE_NAME)",
            "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
            "CFBundleInfoDictionaryVersion": "6.0",
            "CFBundleName": "$(PRODUCT_NAME)",
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "CFBundlePackageType": "APPL",
            "CFBundleIconFile": "",
            "LSMinimumSystemVersion": "$(MACOSX_DEPLOYMENT_TARGET)",
            "NSMainStoryboardFile": "Main",
            "NSPrincipalClass": "NSApplication",
            "NSHumanReadableCopyright": "Copyright ©. All rights reserved."
         ]

         // When
         let plistGenerated = try generator.generate()

         // Then
         let dataExpected = try PropertyListSerialization.data(fromPropertyList: informationExpected,
         format: .xml,
         options: .zero)

        XCTAssertEqual(plistGenerated, dataExpected)
    }
}
