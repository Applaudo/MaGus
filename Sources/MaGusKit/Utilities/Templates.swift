//
//  Templates.swift
//  
//
//  Created by Gustavo Campos on 3/18/20.
//

import Foundation

let matchFile =
"""
git_url("{{ matchRepo }}")

type("adhoc")
username("{{ username }}")
app_identifier(["{{ bundleId }}"])
git_branch("master")
"""

let xcodeGen =
"""
{
  "name": "{{ projectName }}",
  "targets": {
    "{{ targetName }}": {
      "type": "application",
      "platform": "{{ platform }}",
      "deploymentTarget": "{{ deploymentTarget }}",
      "sources": [
        {
          "path": "{{ projectName }}"
        },
        {
          "path": "SupportingFiles"
        }
      ],
      "scheme": {
          "gatherCoverageData": true,
          "testTargets": [
              {
                  "name": "{{ targetName }}-Test"
              }
          ]
      },
      "settings": {
        "INFOPLIST_FILE": "info.plist",
        "PRODUCT_BUNDLE_IDENTIFIER": "{{ bundleId }}"
      },
    },
    "{{ targetName }}-Test": {
      "type": "bundle.unit-test",
      "platform": "{{ platform }}",
      "sources": [
        {
          "path": "{{ projectName }}Tests"
        }
      ],
      "scheme": {
          "testTargets": [
              {
                  "name": "{{ targetName }}-Test"
              }
          ]
      },
    "settings": {
       "PRODUCT_BUNDLE_IDENTIFIER": "{{ bundleId }}"
    },
    "info": {
        "path": "Testinfo.plist"
      },
      "dependencies": [{
          "target": "{{ targetName }}"
      }]
     }
  }
}
"""

private let gemFile =
"""
source "https://rubygems.org"

gem "cocoapods"
gem "fastlane"
gem "xcov"
gem "slather"
gem "xcode-install"
"""

let unitTest =
"""
import XCTest

final class AppDelegateGeneratorTest: XCTestCase {

    func testYourCode() {

    }
}
"""

/// Store all of the templates available to use.
public final class Templates {
    public static let shared = Templates()

    /// Dictionary with all of the templates
    public var templates: [String: String]

    private init() {
        templates = [
            "Fastfile": fastFile,
            "Matchfile": matchFile,
            "xcodegen-template.json": xcodeGen,
            "Gemfile": gemFile,
            "unitTest": unitTest
        ]
    }

    /**
     You are able to set a new template or a existing one identified by its key
     - Parameters:
        - key: template identification
        - template: string representation of the template to be used.
     */
    public static func set(key: String, template: String) {
        Self.shared.templates[key] = template
    }
}
