//
//  GemFileTemplate.swift
//  
//
//  Created by Gustavo Campos on 3/23/20.
//

import Foundation
import PathKit

struct GemFileTemplate: TemplateInformation {
    var context: TemplateContext {
        [:]
    }

    var templateName: String {
        "Gemfile"
    }

    var outputFilePath: Path {
        ""
    }

    var fileName: String {
        "Gemfile"
    }
}
