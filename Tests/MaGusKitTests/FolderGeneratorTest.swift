//
//  FolderGeneratorTest.swift
//  
//
//  Created by Gustavo Campos on 3/17/20.
//

@testable import MaGusKit
import XCTest
import PathKit

final class FolderGeneratorTest: XCTestCase {

    let rootPath = "outputTest"
    let projectFilesPath = "TestProject"

    override func tearDown() {
        super.tearDown()
        let path = Path.current + Path(rootPath)
        try? path.delete()
    }

    func testGenerateRootFolders() throws {
        // Given
        let root = Path(rootPath)
        let projectFiles = root + Path(projectFilesPath)

        // When
        try Path.current.makeFolders(at: root, projectFiles: projectFilesPath)

        // Then
        XCTAssertTrue(root.exists)
        XCTAssertTrue(projectFiles.exists)
    }
}
