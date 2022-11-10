import XCTest
@testable import LocalizedKeyGenerator

final class LocalizedKeyGeneratorTests: XCTestCase {
    func testEverythingDefault() throws {
        let generator = LocalizedKeyGenerator(options: .empty)
        
        let generated = try generator.generateFileContents(from: .module)
        
        let expected = """
/// This file is automatically generated. Any changes will be overwritten.

import Foundation

enum LocalizedKey: String, CaseIterable {

  // Base localization: "This is a library to generate enums for your localized keys."
  case what_is_this

  // Base localization: "I'm Ellen, nice to meet you."
  case who_are_you

  // Base localization: "Because spelling is hard."
  case why_use_this

  var localizedValue: String {
    NSLocalizedString(self.rawValue,
                      bundle: .main,
                      comment: "")
  }
}
"""
        XCTAssertEqual(generated, expected)
    }
    
    func testOnlyEnumNameProvided() throws {
        let options = LocalizedKeyOptions(enumName: "AnEnum",
                                          isPublic: nil,
                                          fileName: nil,
                                          location: nil)
        
        let generator = LocalizedKeyGenerator(options: options)
        let generated = try generator.generateFileContents(from: .module)
        
        let expected = """
/// This file is automatically generated. Any changes will be overwritten.

import Foundation

enum AnEnum: String, CaseIterable {

  // Base localization: "This is a library to generate enums for your localized keys."
  case what_is_this

  // Base localization: "I'm Ellen, nice to meet you."
  case who_are_you

  // Base localization: "Because spelling is hard."
  case why_use_this

  var localizedValue: String {
    NSLocalizedString(self.rawValue,
                      bundle: .main,
                      comment: "")
  }
}
"""
        XCTAssertEqual(generated, expected)
    }
    
    func testOnlyPublicProvided() throws {
        let options = LocalizedKeyOptions(enumName: nil,
                                          isPublic: true,
                                          fileName: nil,
                                          location: nil)
        
        let generator = LocalizedKeyGenerator(options: options)
        let generated = try generator.generateFileContents(from: .module)
        
        let expected = """
/// This file is automatically generated. Any changes will be overwritten.

import Foundation

public enum LocalizedKey: String, CaseIterable {

  // Base localization: "This is a library to generate enums for your localized keys."
  case what_is_this

  // Base localization: "I'm Ellen, nice to meet you."
  case who_are_you

  // Base localization: "Because spelling is hard."
  case why_use_this

  public var localizedValue: String {
    NSLocalizedString(self.rawValue,
                      bundle: .main,
                      comment: "")
  }
}
"""
        XCTAssertEqual(generated, expected)
    }
    
    func testOnlyFileNameProvided() throws {
        let options = LocalizedKeyOptions(enumName: nil,
                                          isPublic: nil,
                                          fileName: "MoarStrings",
                                          location: nil)
        
        let generator = LocalizedKeyGenerator(options: options)
        let generated = try generator.generateFileContents(from: .module)
        
        let expected = """
/// This file is automatically generated. Any changes will be overwritten.

import Foundation

enum LocalizedKey: String, CaseIterable {

  // Base localization: "Well, that's why we have tests."
  case does_this_work

  // Base localization: "Oh stop being so sanctimonious."
  case o_rly

  var localizedValue: String {
    NSLocalizedString(self.rawValue,
                      bundle: .main,
                      comment: "")
  }
}
"""
        XCTAssertEqual(generated, expected)
    }
    
    func testOnlyLocationProvidedAsFramework() throws {
        let options = LocalizedKeyOptions(enumName: nil,
                                          isPublic: nil,
                                          fileName: nil,
                                          location: .frameworkBundle)
        
        let generator = LocalizedKeyGenerator(options: options)
        let generated = try generator.generateFileContents(from: .module)
        
        let expected = """
/// This file is automatically generated. Any changes will be overwritten.

import Foundation

enum LocalizedKey: String, CaseIterable {

  // Base localization: "This is a library to generate enums for your localized keys."
  case what_is_this

  // Base localization: "I'm Ellen, nice to meet you."
  case who_are_you

  // Base localization: "Because spelling is hard."
  case why_use_this

  var localizedValue: String {
    NSLocalizedString(self.rawValue,
                      bundle: Bundle(for: ClassForBundleLocation.self),
                      comment: "")
  }
}

// A class to facilitate finding the current framework bundle
private class ClassForBundleLocation {}
"""
        XCTAssertEqual(generated, expected)
    }
    
    func testCustomEnumNamePublicInModule() throws {
        let options = LocalizedKeyOptions(enumName: "TestKeys",
                                          isPublic: true,
                                          fileName: nil,
                                          location: .swiftModule)
        
        let generator = LocalizedKeyGenerator(options: options)
        
        let generated = try generator.generateFileContents(from: .module)
        
        let expected = """
/// This file is automatically generated. Any changes will be overwritten.

import Foundation

public enum TestKeys: String, CaseIterable {

  // Base localization: "This is a library to generate enums for your localized keys."
  case what_is_this

  // Base localization: "I'm Ellen, nice to meet you."
  case who_are_you

  // Base localization: "Because spelling is hard."
  case why_use_this

  public var localizedValue: String {
    NSLocalizedString(self.rawValue,
                      bundle: .module,
                      comment: "")
  }
}
"""
        XCTAssertEqual(generated, expected)
    }
    
    func testCustomFileNamePublicInModule() throws {
        
        let options = LocalizedKeyOptions(enumName: nil,
                                          isPublic: true,
                                          fileName: "MoarStrings",
                                          location: .swiftModule)
        
        let generator = LocalizedKeyGenerator(options: options)
        
        let generated = try generator.generateFileContents(from: .module)
        
        let expected = """
/// This file is automatically generated. Any changes will be overwritten.

import Foundation

public enum LocalizedKey: String, CaseIterable {

  // Base localization: "Well, that's why we have tests."
  case does_this_work

  // Base localization: "Oh stop being so sanctimonious."
  case o_rly

  public var localizedValue: String {
    NSLocalizedString(self.rawValue,
                      bundle: .module,
                      comment: "")
  }
}
"""
        XCTAssertEqual(generated, expected)
    }
}
