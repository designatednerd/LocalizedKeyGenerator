//
//  LocalizationTestHelperTests.swift
//  LocalizedKeyGeneratorTests
//
//  Created by Ellen Shapiro on 11/9/22.
//

import XCTest
@testable import LocalizationTestHelpers

class LocalizationTestHelperTests: XCTestCase {
    
    func testGettingDeveloperLanguage() throws {
        let devLanguage = try self.developerLanguage(for: Bundle.module)
        XCTAssertEqual(devLanguage, "en")
    }
    
    func testGrabbingBaseLanguageBundle() throws {
        let testBundle = Bundle.module
        let baseBundle = try testBundle.bundleForBaseLanguage()
        
        let defaultTableValue = baseBundle.localizedString(forKey: "what_is_this",
                                                           value: nil,
                                                           table: nil)
        XCTAssertEqual(defaultTableValue, "This is a library to generate enums for your localized keys.")
        
        let customTableValue = baseBundle.localizedString(forKey: "does_this_work",
                                                          value: nil,
                                                          table: "MoarStrings")
        XCTAssertEqual(customTableValue, "Well, that's why we have tests.")
    }
    
    func testTryingToDirectlyGrabEnglishBundleDirectlyDoesntWorkWithBaseLocalization() {
        let testBundle = Bundle.module
        XCTAssertThrowsError(try testBundle.bundleForLanguage("en"))
    }
    
    func testGrabbingSpanishLanguageBundle() throws {
        let testBundle = Bundle.module
        let spanishBundle = try testBundle.bundleForLanguage("es")
        
        let defaultTableValue = spanishBundle.localizedString(forKey: "what_is_this",
                                                              value: nil,
                                                              table: nil)
        XCTAssertEqual(defaultTableValue, "Esta es una biblioteca para generar enumeraciones para sus claves localizadas.")
        
        let customTableValue = spanishBundle.localizedString(forKey: "does_this_work",
                                                             value: nil,
                                                             table: "MoarStrings")
        XCTAssertEqual(customTableValue, "Bueno, es por eso que tenemos pruebas.")
    }
    
    func testLineByLineComparisonWithIdenticalSingleLines() {
        let expected = "I am a carbon copy"
        let actual = "I am a carbon copy"
        
        let comparison = LineByLineComparison(expected: expected,
                                                    actual: actual)
        
        XCTAssertNoThrow(try comparison.compare())
    }
    
}


