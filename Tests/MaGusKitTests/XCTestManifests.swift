import XCTest

extension TemplateGeneratorTests {
    static let allTests = [
        ("testGenerateJson", testGenerateJson),
    ]
}

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testcase(TemplateGeneratorTests.allTests),
    ]
}
#endif
