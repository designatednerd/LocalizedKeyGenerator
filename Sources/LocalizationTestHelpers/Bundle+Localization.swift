//
//  Bundle+Localization.swift
//  
//
//  Created by Ellen Shapiro on 11/9/22.
//

import Foundation

public extension Bundle {
    
    enum LocalizationError: Error {
        case couldNotGetBundlePath(languageCode: String)
        case couldNotCreateBundle(languageCode: String)
        case localizationNotFound(languageCode: String)
    }

    func bundleForLanguage(_ languageCode: String) throws -> Bundle {
        guard let path = self.path(forResource: languageCode, ofType: "lproj") else {
            throw LocalizationError.couldNotGetBundlePath(languageCode: languageCode)
        }
        
        guard FileManager.default.fileExists(atPath: path) else {
            throw LocalizationError.localizationNotFound(languageCode: languageCode)
        }
        
        guard let bundle = Bundle(path: path) else {
            throw LocalizationError.couldNotCreateBundle(languageCode: languageCode)
        }
        
        return bundle
    }
    
    func bundleForBaseLanguage() throws -> Bundle {
        try self.bundleForLanguage("Base")
    }
}
