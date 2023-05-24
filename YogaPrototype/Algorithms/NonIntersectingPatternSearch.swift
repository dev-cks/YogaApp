//
//  NonIntersectingPatternSearch.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 16.12.2021.
//

import Foundation

/**
 Implements a modified version of Knuth Morris Pratt algorithm
 returning start indices of non-intersecting occurrencies of the pattern in the sequence, i.e.
 searching [A, A] in [A, A, A, A, B, B] will return [0, 2], not [0, 1, 2]
 */
func nonIntersectingOccurrencies<Element>(of pattern: [Element],
                                          in sequence: [Element], match: (Element, Element) -> Bool) -> [Int] {
    let patternSize = pattern.count
    let sequenceSize = sequence.count
    guard
        sequenceSize > 0,
        patternSize > 0
    else {
        return []
    }
    
    var lps = [Int]()
    lps.reserveCapacity(patternSize)
    
    for i in 0..<patternSize {
        let part = pattern[0...i]
        var suffixLength = i
        while (suffixLength > 0) {
            let suffix = pattern[(i - suffixLength + 1)...i]
            if part.starts(with: suffix, by: match) {
                break
            }
            
            suffixLength -= 1
        }
        
        lps.append(suffixLength)
    }
    
    var results = [Int]()
    results.reserveCapacity((sequenceSize / patternSize) + 1)
    
    var iPattern = 0
    var iSequence = 0
    while iSequence < sequenceSize {
        if match(pattern[iPattern], sequence[iSequence]) {
            iPattern += 1
            iSequence += 1
            
            if iPattern == patternSize {
                iPattern = 0
                results.append(iSequence - patternSize)
            }
        } else if iPattern == 0 {
            iSequence += 1
        } else {
            iPattern = lps[iPattern]
        }
    }
    
    return results
}

