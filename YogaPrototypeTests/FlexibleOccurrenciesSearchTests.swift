//
//  FlexibleOccurrenciesSearchTests.swift
//  YogaPrototypeTests
//
//  Created by Sergii Kutnii on 25.12.2021.
//

import XCTest
@testable import YogaPrototype

class FlexibleOccurrenciesSearchTests: XCTestCase {

    func testSimpleMatch() throws {
        let pattern = [0, 10, 100]
        let array = [0, 0, 0, 0, 0, 0, 10, 10, 100, 100, 100]
        let result = occurrencies(of: pattern, in: array)
        
        XCTAssertEqual(result, [0..<11], "Invalid result")
    }
    
    func testNoMatch() throws {
        let pattern = [0, 10, 100]
        let array = [100, 100, 100, 10, 10, 0, 0, 0, 0, 0, 0]
        
        let result = occurrencies(of: pattern, in: array)

        XCTAssertTrue(result.isEmpty, "Result must be empty")
    }
    
    func testNonMatchingTail() throws {
        let pattern = [0, 10, 100]
        let array = [0, 0, 0, 0, 0, 0, 10, 10, 100, 100, 100, 10, 10, 10, 10, 10]
        let result = occurrencies(of: pattern, in: array)
        
        XCTAssertEqual(result, [0..<11], "Invalid result")
    }
    
    func testNonMatchingHead() throws {
        let pattern = [0, 10, 100]
        let array = [100, 100, 100, 0, 0, 0, 0, 0, 0, 10, 10, 100, 100, 100]
        let result = occurrencies(of: pattern, in: array)
        
        XCTAssertEqual(result, [3..<14], "Invalid result")
    }
    
    func testTwoOccurrencies() throws {
        let pattern = [0, 10, 100]
        let array = [0, 0, 0, 0, 0, 0, 10, 10, 100, 100, 100, 10, 10, 10, 0, 10, 10, 100]
        let result = occurrencies(of: pattern, in: array)
        
        XCTAssertEqual(result, [0..<11, 14..<18], "Must be two occurrencies")
    }
    
    func testAdjacentOccurrencies() throws {
        let pattern = [0, 10, 100]
        let array = [0, 0, 0, 0, 0, 0, 10, 10, 100, 100, 100, 0, 10, 10, 100]
        let result = occurrencies(of: pattern, in: array)
        
        XCTAssertEqual(result, [0..<11, 11..<15], "Invalid result")
    }
    
    func testIncompletePattern() throws {
        let pattern = [0, 10, 100]
        let array = [0, 0, 0, 0, 0, 0, 10, 10, 0, 0]
        let result = occurrencies(of: pattern, in: array)
        
        XCTAssertTrue(result.isEmpty, "Result must be empty")
    }
    
    func testNonMonotonicPattern() throws {
        let pattern = [0, 1, 2, 1]
        let array = [0, 1, 2, 1, 0, 1, 2, 1]

        let result = occurrencies(of: pattern, in: array)
        XCTAssertEqual(result, [0..<4, 4..<8], "Invalid result")
    }

}
