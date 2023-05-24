//
//  PatternSearchTests.swift
//  YogaPrototypeTests
//
//  Created by Sergii Kutnii on 17.12.2021.
//

import XCTest
@testable import YogaPrototype

class NonIntersectingOccurrenciesSearchTests: XCTestCase {

    func testAllMatching() throws {
        let sequence = [1, 1, 1, 1, 1, 1, 1, 1, 1]
        let pattern = [1, 1, 1]
        
        let results = nonIntersectingOccurrencies(of: pattern, in: sequence) {
            a, b in
            return a == b
        }
        
        XCTAssertEqual(results, [0, 3, 6], "Wrong results")
    }
    
    func testSparseFragments() throws {
        let sequence = [3, 2, 1, 0, 0, 3, 2, 1, 0, 3, 2]
        let pattern = [3, 2, 1]
        
        let results = nonIntersectingOccurrencies(of: pattern, in: sequence) {
            a, b in
            return a == b
        }
        
        XCTAssertEqual(results, [0, 5], "Wrong results")
    }
    
    func testNoOccurrencies() throws {
        let sequence = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        let pattern = [1]
        
        let results = nonIntersectingOccurrencies(of: pattern, in: sequence) {
            a, b in
            return a == b
        }

        XCTAssertTrue(results.isEmpty, "False positive")
    }

}
