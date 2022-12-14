import Foundation

public struct LocalizedKeyGenerator {
    public enum Error: Swift.Error, CustomStringConvertible {
        case keyHasSpaces(_ key: String)
        case couldntGetStringsDictPath(_ fileName: String)
        case couldntLoadStringsDict(_ url: URL)
        
        public var description: String {
            switch self {
            case .keyHasSpaces(let key):
                return "The key '\(key)' contains spaces, which won't work for creating an enum. Please replace spaces with underscores."
            case .couldntGetStringsDictPath(let fileName):
                return "Couldn't get the path to \(fileName).strings, please check your configuration file (or create one)."
            case .couldntLoadStringsDict(let url):
                return "Couldn't load the strings dictionary at \(url)"
            }
        }
    }
    
    private let options: LocalizedKeyOptions
    public init(options: LocalizedKeyOptions) {
        self.options = options
    }
    
    public func generateFileContents(from bundle: Bundle) throws -> String {
        let enumName = self.enumName(from: self.options)
        let accessString = self.publicOrEmpty(from: self.options)
        let fileName = self.fileName(from: self.options)
        
        var fileContents = """
/// This file is automatically generated. Any changes will be overwritten.

import Foundation

\(accessString)enum \(enumName): String, CaseIterable {
"""
        
        guard let localizedStringsDictURL = bundle.url(forResource: fileName, withExtension: "strings") else {
            throw Error.couldntGetStringsDictPath(fileName)
        }
        guard let localizedStringsDict = NSDictionary(contentsOf: localizedStringsDictURL) as? [String: String] else {
            throw Error.couldntLoadStringsDict(localizedStringsDictURL)
        }
        
        
        let alphabetizedKeys = localizedStringsDict.map { $0.key }.sorted()
        
        for key in alphabetizedKeys {
            guard !key.contains(" ") else {
                throw Error.keyHasSpaces(key)
            }
            
            let value = localizedStringsDict[key]!
            
            fileContents.append("\n\n  // Base localization: \"\(value)\"")
            fileContents.append("\n  case \(key)")
        }
        
        fileContents.append("""


  \(accessString)var localizedValue: String {
""")
        switch self.options.location {
        case .frameworkBundle:
            fileContents.append("""

    NSLocalizedString(self.rawValue,
                      bundle: Bundle(for: ClassForBundleLocation.self),
                      comment: "")
  }
}

// A class to facilitate finding the current framework bundle
private class ClassForBundleLocation {}
""")
        case .mainBundle,
                .none: // assumes main bundle by default
            fileContents.append("""

    NSLocalizedString(self.rawValue,
                      bundle: .main,
                      comment: "")
  }
}
""")
        case .swiftModule:
            fileContents.append("""

    NSLocalizedString(self.rawValue,
                      bundle: .module,
                      comment: "")
  }
}
""")
        }
        
        fileContents.append("\n")
        
        return fileContents
    }
    
    private func fileName(from options: LocalizedKeyOptions) -> String {
        guard let passedInName = options.fileName else {
            return "Localizable"
        }
        
        return passedInName
    }
    
    
    private func enumName(from options: LocalizedKeyOptions) -> String {
        guard let enumName = options.enumName else {
            return "LocalizedKey"
        }
        
        return enumName
    }
    
    
    private func publicOrEmpty(from options: LocalizedKeyOptions) -> String {
        guard
            let publicOption = options.isPublic,
            publicOption == true else {
            return ""
        }
        
        return "public "
    }
}
