//
//  UnitTestTemplate.swift
//  
//
//  Created by Gustavo Campos on 3/24/20.
//

import Foundation
import PathKit

/// Template representation  of a unit test file.
struct UnitTestTemplate: TemplateInformation {

    /// Path to test folder
    let testPath: Path

    var context: TemplateContext {
        [:]
    }

    var templateName: String {
        "unitTest"
    }

    var outputFilePath: Path {
        testPath
    }

    var fileName: String {
        "ExampleUnitTest.swift"
    }
}
