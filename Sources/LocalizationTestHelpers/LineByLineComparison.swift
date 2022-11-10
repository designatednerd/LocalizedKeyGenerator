//
//  LineByLineComparison.swift
//  LocalizationTestHelpers
//
//  Created by Ellen Shapiro on 11/9/22.
//

import Foundation

public struct LineMismatch: Equatable, CustomStringConvertible {
    public let expected: String
    public let actual: String
    public let line: Int
    
    public init(expected: String,
                actual: String,
                line: Int) {
        self.expected = expected
        self.actual = actual
        self.line = line
    }
    
    public var description: String {
        "Mismatch in line \(line): Expected \"\(expected)\", got \"\(actual)\""
    }
}

public struct LineByLineComparison {
    public enum ComparisonError: Error {
        case mismatchedLineCount(expected: Int, actual: Int)
        case mismatchedLines(_ mismatches: [LineMismatch])
    }
    
    private let expected: String
    private let actual: String
    
    public init(expected: String,
                actual: String) {
        self.expected = expected
        self.actual = actual
    }

    public func compare() throws {
        let expectedLines = expected.split(separator: "\n",
                                           omittingEmptySubsequences: false)
        let actualLines = actual.split(separator: "\n",
                                       omittingEmptySubsequences: false)
        
        guard expectedLines.count == actualLines.count else {
            throw ComparisonError.mismatchedLineCount(expected: expectedLines.count, actual: actualLines.count)
        }
        
        var mismatches = [LineMismatch]()
        for (index, expectedLine) in (expectedLines.enumerated()) {
            let actualLine = actualLines[index]
            if expectedLine != actualLine {
                let mismatch = LineMismatch(expected: String(expectedLine),
                                            actual: String(actualLine),
                                            line: index + 1) // lines are not zero-indexed
                mismatches.append(mismatch)
            } // else, it matches and we're good.
        }
        
        guard mismatches.isEmpty else {
            throw ComparisonError.mismatchedLines(mismatches)
        }
        
        // If we got here, all the lines match and we have succeeded!   
    }
    
}