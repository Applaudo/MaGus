//
//  Path+Extensions.swift
//  
//
//  Created by Manuel Sánchez on 3/3/20.
//

import PathKit

extension Path {

    static var fastfile: Path {
        "fastlane"
    }

    static var matchFile: Path {
        "fastlane"
    }

    @discardableResult
    func makeFolders(at rootPath: Path, projectFiles filesPath: String) throws -> Path {
         let rootPath = self + rootPath
         try rootPath.mkdir()

         let projectFilesFolder = rootPath + Path(filesPath)

         try projectFilesFolder.mkdir()

         return projectFilesFolder
     }

    @discardableResult
    func generateBaseProjectDirs(at rootPath: Path) throws  -> Path {
        let supportingFiles = self + rootPath + "SupportingFiles"

        try supportingFiles.mkdir()
        return supportingFiles
    }

    @discardableResult
    func generateTestFolder(folderName name: String) throws -> Path {
         let supportingFiles = self + name

        try supportingFiles.mkdir()
        return supportingFiles
    }
}
