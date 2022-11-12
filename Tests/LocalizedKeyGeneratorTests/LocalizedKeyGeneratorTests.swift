import XCTest
@testable import LocalizedKeyGenerator
import LocalizationTestHelpers

final class LocalizedKeyGeneratorTests: XCTestCase {
    
    // MARK: - Things compared to raw text files in the bundle
    
    func testEverythingDefault() throws {
        let generator = LocalizedKeyGenerator(options: .empty)
        
        let generated = try generator.generateFileContents(from: .module)
        
        let expectedPath = try XCTUnwrap(Bundle.module.path(forResource: "ExpectedEverythingDefaultOutput", ofType: "txt"))
        try LineByLineComparison(expectedPath: expectedPath, actual: generated)
            .compareForTesting()
    }
    
    func testOnlyEnumNameProvided() throws {
        let options = LocalizedKeyOptions(enumName: "AnEnum",
                                          isPublic: nil,
                                          fileName: nil,
                                          location: nil)
        
        let generator = LocalizedKeyGenerator(options: options)
        let generated = try generator.generateFileContents(from: .module)
        
        let expectedPath = try XCTUnwrap(Bundle.module.path(forResource: "ExpectedOnlyEnumNameOutput", ofType: "txt"))
        try LineByLineComparison(expectedPath: expectedPath, actual: generated)
            .compareForTesting()
    }
    
    func testOnlyPublicProvided() throws {
        let options = LocalizedKeyOptions(enumName: nil,
                                          isPublic: true,
                                          fileName: nil,
                                          location: nil)
        
        let generator = LocalizedKeyGenerator(options: options)
        let generated = try generator.generateFileContents(from: .module)
        
        let expectedPath = try XCTUnwrap(Bundle.module.path(forResource: "ExpectedOnlyPublicOutput", ofType: "txt"))
        try LineByLineComparison(expectedPath: expectedPath, actual: generated)
            .compareForTesting()
    }
    
    func testOnlyFileNameProvided() throws {
        let options = LocalizedKeyOptions(enumName: nil,
                                          isPublic: nil,
                                          fileName: "MoarStrings",
                                          location: nil)
        
        let generator = LocalizedKeyGenerator(options: options)
        let generated = try generator.generateFileContents(from: .module)
        
        let expectedPath = try XCTUnwrap(Bundle.module.path(forResource: "ExpectedOnlyFileNameOutput", ofType: "txt"))
        try LineByLineComparison(expectedPath: expectedPath, actual: generated)
            .compareForTesting()
    }
    
    func testOnlyLocationProvidedAsFramework() throws {
        let options = LocalizedKeyOptions(enumName: nil,
                                          isPublic: nil,
                                          fileName: nil,
                                          location: .frameworkBundle)
        
        let generator = LocalizedKeyGenerator(options: options)
        let generated = try generator.generateFileContents(from: .module)
        
        let expectedPath = try XCTUnwrap(Bundle.module.path(forResource: "ExpectedOnlyLocationProvidedAsFrameworkOutput", ofType: "txt"))
        try LineByLineComparison(expectedPath: expectedPath, actual: generated)
            .compareForTesting()
    }
    
    // MARK: - Things that can be compiled locally so are swift files
    
    private func pathToSwiftFileInThisDirectory(_ fileName: String) -> String {
        // TODO: Figure out a better way to do this
        let currentPath = #filePath
        let parentPath = NSString(string: currentPath)
            .deletingLastPathComponent
        return NSString(string: parentPath)
            .appendingPathComponent("\(fileName).swift")
    }
    
    func testCustomEnumNamePublicInModule() throws {
        let options = LocalizedKeyOptions(enumName: "TestKeys",
                                          isPublic: true,
                                          fileName: nil,
                                          location: .swiftModule)
        
        let generator = LocalizedKeyGenerator(options: options)
        
        let generated = try generator.generateFileContents(from: .module)
        
        let expectedPath = self.pathToSwiftFileInThisDirectory("ExpectedCustomEnumNamePublicInModuleOutput")
        
        try LineByLineComparison(expectedPath: expectedPath, actual: generated)
            .compareForTesting()
    }
    
    func testCustomFileNamePublicInModule() throws {
        let options = LocalizedKeyOptions(enumName: nil,
                                          isPublic: true,
                                          fileName: "MoarStrings",
                                          location: .swiftModule)
        
        let generator = LocalizedKeyGenerator(options: options)
        
        let generated = try generator.generateFileContents(from: .module)
        
        let expectedPath = self.pathToSwiftFileInThisDirectory("ExpectedCustomFileNamePublicInModuleOutput")
        
        try LineByLineComparison(expectedPath: expectedPath, actual: generated)
            .compareForTesting()
    }
}
