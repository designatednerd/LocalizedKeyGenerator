//
//  LocalizedKeyOptions.swift
//  LocalizedKeyGenerator
//
//  Created by Ellen Shapiro on 11/6/22.
//

import Foundation

/// The location of both the enum and where the generated code will go.
public enum LocalizedKeyFileLocation: String, Codable {
    /// These will be in a swift module which has `Resources` declared in the Package.swift file.
    case swiftModule
    
    /// These will be in the main bundle of an application.
    case mainBundle
    
    /// These will be in a framework. 
    case frameworkBundle
}

public struct LocalizedKeyOptions: Codable {
    // The name you want the generated enum to have. If not provided, a default value of `LocalizedKey` will be used.
    public let enumName: String?
    
    // Whether or not you want the generated enum to be public. If not provided, a default value of `false` will be used.
    public let isPublic: Bool?
    
    // The name of the file to load strings from, *without* the `.strings` extension. If not provided, a default value of `Localizable` will be used.
    public let fileName: String?
    
    // The location of the localized keys. If not provided, a default value of `.mainBundle` will be used.
    public let location: LocalizedKeyFileLocation?
    
    static var empty: LocalizedKeyOptions {
        LocalizedKeyOptions(enumName: nil,
                            isPublic: nil,
                            fileName: nil,
                            location: nil)
    }
}
