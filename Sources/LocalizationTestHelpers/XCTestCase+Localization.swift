//
//  XCTestCase+Localization.swift
//  LocalizationTestHelpers
//
//  Created by Ellen Shapiro on 11/6/22.
//

import Foundation
import XCTest

extension XCTestCase {
    enum LocalizationTestingError {
        case couldNotGetCurrentPreferredLanguage
    }

    func currentDeviceOrSimLanguage(file: StaticString = #file,
                                    line: UInt = #line) throws -> String {
        let language = try XCTUnwrap(Locale.preferredLanguages.first,
                                     "Could not get preferred language information",
                                     file: file,
                                     line: line)
        return language
    }
    
    func developerLanguage(for bundle: Bundle,
                           file: StaticString = #file,
                           line: UInt = #line) throws -> String {
        let developerLanguage = try XCTUnwrap(bundle.object(forInfoDictionaryKey: kCFBundleDevelopmentRegionKey as String) as? String,
        
                                              "Could not get development region key",
                                              file: file,
                                              line: line)
        
        return developerLanguage
    }
    
    func bundleForDeveloperLanguage(in bundle: Bundle,
                                    file: StaticString = #file,
                                    line: UInt = #line) throws -> Bundle {
        let devLanguage = try self.developerLanguage(for: bundle)
        
        if let devLanguageBundle = try? bundle.bundleForLanguage(devLanguage) {
            return devLanguageBundle
        } else {
            return try bundle.bundleForBaseLanguage()
        }
    }
    
    func bundleForCurrentDeviceOrSimLanguage(in bundle: Bundle,
                                             file: StaticString = #file,
                                             line: UInt = #line) throws -> Bundle {
        let currentLanguage = try self.currentDeviceOrSimLanguage(file: file,
                                                              line: line)
        let developerLanguage = try self.developerLanguage(for: bundle)
        if currentLanguage == developerLanguage {
            return try self.bundleForDeveloperLanguage(in: bundle)
        } else {
            return try bundle.bundleForLanguage(currentLanguage)
        }
    }

    //Inspired by http://learning-ios.blogspot.com/2011/04/advance-localization-in-ios-apps.html
    func validateCurrentLocaleString(in bundle: Bundle,
                                     for key: String,
                                     in table: String? = nil,
                                     knownIdenticalValues: [String] = [],
                                     file: StaticString = #file,
                                     line: UInt = #line) throws {
        
        let currentLanguage = try self.currentDeviceOrSimLanguage()
        let currentLanguageBundle = try self.bundleForDeveloperLanguage(in: bundle)
        let developerLanguageBundle = try self.bundleForCurrentDeviceOrSimLanguage(in: bundle)
        
        guard developerLanguageBundle != currentLanguageBundle else {
            XCTFail("Developer language bundle and current bundle are identical, so they will always have identical contents!",
                    file: file,
                    line: line)
            return
        }
        
        
        let currentLanguageStringForKey = currentLanguageBundle.localizedString(forKey: key,
                                                                                value: nil,
                                                                                table: table)
        
        XCTAssertFalse(currentLanguageStringForKey.isEmpty,
                       "String in (\(currentLanguage)) for key '\(key)' is empty",
                       file: file,
                       line: line)
        XCTAssertNotEqual(currentLanguageStringForKey,
                          key,
                          "String in (\(currentLanguage)) is the same as key '\(key)', indicating an untranslated string.",
                          file: file,
                          line: line)
        
        let devLanguageStringForKey = developerLanguageBundle.localizedString(forKey: key,
                                                                              value: nil,
                                                                              table: table)
        XCTAssertFalse(devLanguageStringForKey.isEmpty,
                       "String in developer language for key '\(key)' is empty",
                       file: file,
                       line: line)
        XCTAssertNotEqual(devLanguageStringForKey,
                          key,
                          "String in developer language is the same as key '\(key)', indicating an untranslated string.",
                          file: file,
                          line: line)
        
        // From here, we also need to check the current language string is either identical across languages or not depending on whether it's a known identical value
        if knownIdenticalValues.contains(devLanguageStringForKey) {
            // If it is a known identical value, make sure it is in fact identical
            XCTAssertEqual(currentLanguageStringForKey,
                           devLanguageStringForKey,
                           "Value for \(key) should be the same in both languages but is '\(devLanguageStringForKey)' in the developer language and '\(currentLanguageStringForKey)' in \(currentLanguage).",
                           file: file,
                           line: line)
        } else {
            // If it's not a known identical value, make sure it's not identical.
            XCTAssertNotEqual(currentLanguageStringForKey,
                              devLanguageStringForKey,
                              "Value in both languages should differ for \(key), but is \(devLanguageStringForKey) in both.",
                              file: file,
                              line: line)
        }
    }
    
    /**
     * This test assumes you have added -AppleLanguages and (`[two-letter language code]`) as
     * the first two arguments in your build scheme's Test Arguments Passed On Launch to force
     * the sim to launch in a specific language.
     * Further details about this technique: https://coderwall.com/p/te63dg
     */
    func checkSimOrDeviceIsRunningPassedInLanguage(file: StaticString = #file,
                                                   line: UInt = #line) throws {
        // Get the arguments passed from the scheme
        let arguments = ProcessInfo.processInfo.arguments
        guard arguments.count >= 3 else {
            XCTFail("Not enough arguments!",
                    file: file,
                    line: line)
            return
        }
        
        let expectedLanguageArgument = arguments[2]
        
        // Should be 4 characters including parens
        guard expectedLanguageArgument.count == 4 else {
            XCTFail("Double check your language argument. Position 2 returning \(expectedLanguageArgument)",
                    file: file,
                    line: line)
            return
        }
        
        // Strip the parentheses
        let argumentWithoutParens = expectedLanguageArgument.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        // should be 2 characters stripped of parens
        guard argumentWithoutParens.count == 2 else {
            XCTFail("Double check your language argument. Position 2 stripped of parentheses returning \(argumentWithoutParens)",
                    file: file,
                    line: line)
            return
        }
       
        let deviceOrSimLanguage = try currentDeviceOrSimLanguage(file: file,
                                                                 line: line)
        
        // OK, is this actually the requested language?
        XCTAssertEqual(deviceOrSimLanguage,
                       argumentWithoutParens,
                       "Sim language \(deviceOrSimLanguage), not expected language \(argumentWithoutParens).",
                       file: file,
                       line: line)
    }
    
    func value(for infoPlistKey: String,
               in bundle: Bundle,
               file: StaticString = #file,
               line: UInt = #line) -> String {
        bundle.localizedString(forKey: infoPlistKey,
                               value: "",
                               table: "InfoPlist")
    }
    
    func checkValueLocalized(for infoPlistKey: String,
                             languageCode: String,
                             in bundle: Bundle,
                             file: StaticString = #file,
                             line: UInt = #line) throws {
        let baseBundle = try bundle.bundleForBaseLanguage()
        let languageBundle = try bundle.bundleForLanguage(languageCode)
        
        let baseValue = self.value(for: infoPlistKey, in: baseBundle)
        let languageValue = self.value(for: infoPlistKey, in: languageBundle)

        XCTAssertNotEqual(baseValue,
                          languageValue,
                          "Base value for plist key \(infoPlistKey) is \(baseValue) in both Base and \(languageCode) localizations!",
                          file: file,
                          line: line)
    }
}
