//
//  LineByLineComparisonTests.swift
//  
//
//  Created by Ellen Shapiro on 11/9/22.
//

import XCTest
import LocalizationTestHelpers

class LineByLineComparisonTests: XCTestCase {
    
    func testOnlyWhitespaceDifferentSingleLines() {
        let expected = "I am a carbon copy"
        let actual = "I am a carbon copy "
        
        let comparison = LineByLineComparison(expected: expected,
                                                    actual: actual)
        
        XCTAssertThrowsError(try comparison.compare()) { error in
            switch error {
            case LineByLineComparison.ComparisonError.mismatchedLines(let mismatches):
                XCTAssertEqual(mismatches.count, 1)
                XCTAssertEqual(mismatches.first, LineMismatch(expected: expected,
                                                              actual: actual,
                                                              line: 1))
            default:
                XCTFail("Error was not expected error, it was \(error)")
            }
        }
    }
    
    func testDifferentSingleLines() {
        let expected = "I am a carbon copy"
        let actual = "I am a Carbon copy"
        
        let comparison = LineByLineComparison(expected: expected,
                                                    actual: actual)
        
        XCTAssertThrowsError(try comparison.compare()) { error in
            switch error {
            case LineByLineComparison.ComparisonError.mismatchedLines(let mismatches):
                XCTAssertEqual(mismatches.count, 1)
                XCTAssertEqual(mismatches.first, LineMismatch(expected: expected,
                                                              actual: actual,
                                                              line: 1))
            default:
                XCTFail("Error was not expected error, it was \(error)")
            }
        }
    }
    
    func testMutlipleIdenticalLines() {
        let expected = """
I am a carbon copy
of a boron copy
"""
        let actual = """
I am a carbon copy
of a boron copy
"""
        
        let comparison = LineByLineComparison(expected: expected,
                                                    actual: actual)
        
        XCTAssertNoThrow(try comparison.compare())
    }
    
    func testLineByLineComparisonWithMutlipleLinesAndOneMismatch() {
        let expected = """
I am a carbon copy
of a Boron copy
"""
        let actual = """
I am a carbon copy
of a boron copy
"""
        
        let comparison = LineByLineComparison(expected: expected,
                                                    actual: actual)
        
        XCTAssertThrowsError(try comparison.compare()) { error in
            switch error {
            case LineByLineComparison.ComparisonError.mismatchedLines(let mismatches):
                XCTAssertEqual(mismatches.count, 1)
                XCTAssertEqual(mismatches.first, LineMismatch(expected: "of a Boron copy",
                                                              actual: "of a boron copy",
                                                              line: 2))
            default:
                XCTFail("Error was not expected error, it was \(error)")
            }
        }
    }
    
    
    func testMutlipleLinesAndMultipleMismatches() {
        let expected = """
I am a carbon copy
of a boron copy
"""
        let actual = """
I am a Carbon copy
of a Boron copy
"""
        
        let comparison = LineByLineComparison(expected: expected,
                                                    actual: actual)
        
        XCTAssertThrowsError(try comparison.compare()) { error in
            switch error {
            case LineByLineComparison.ComparisonError.mismatchedLines(let mismatches):
                XCTAssertEqual(mismatches.count, 2)
                XCTAssertEqual(mismatches[0], LineMismatch(expected:
                                                            "I am a carbon copy",
                                                           actual: "I am a Carbon copy",
                                                           line: 1))
                XCTAssertEqual(mismatches[1], LineMismatch(expected: "of a boron copy", actual: "of a Boron copy", line: 2))
            default:
                XCTFail("Error was not expected error, it was \(error)")
            }
        }
    }
    
    func testDifferentLineLengths() {
        let expected = """
I am a carbon copy
"""
        let actual = """
I am a carbon copy

"""
        
        let comparison = LineByLineComparison(expected: expected,
                                                    actual: actual)
        
        XCTAssertThrowsError(try comparison.compare()) { error in
            switch error {
            case LineByLineComparison.ComparisonError.mismatchedLineCount(let expected, let actual):
                XCTAssertEqual(expected, 1)
                XCTAssertEqual(actual, 2)
            default:
                XCTFail("Error was not expected error, it was \(error)")
            }
        }
    }
}
