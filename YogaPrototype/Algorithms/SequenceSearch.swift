//
//  SequenceSearch.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 23.12.2021.
//

import Foundation
import CloudKit

func bestMatchIndex<Element, Scalar: Comparable>(in sequence: [Element],
                             using matchFunc: (Element) -> Scalar) -> Int {
    guard
        !sequence.isEmpty
    else {
        return -1
    }
    
    var bestScore = matchFunc(sequence[0])
    var bestIndex = 0
    for index in 1..<sequence.count {
        let matchScore = matchFunc(sequence[index])
        if matchScore > bestScore {
            bestIndex = index
            bestScore = matchScore
        }
    }
    
    return bestIndex
}

func occurrencies<Element, Scalar: Comparable>(of sequence: [Element],
                               in input: [Element], using matchFunc: (Element, Element) -> Scalar) -> [Range<Int>] {
    guard
        sequence.count > 1,
        input.count >= sequence.count
    else {
        return []
    }
    
    var phaseIndex = 0
    var isMatching = false
    var matchStart = 0
    var results = [Range<Int>]()
    for itemIndex in 0..<input.count {
        let currentItem = input[itemIndex]
        let fitIndex = bestMatchIndex(in: sequence) {
            element in
            return matchFunc(currentItem, element)
        }
                        
        guard
            isMatching
        else {
            if fitIndex == phaseIndex {
                matchStart = itemIndex
                isMatching = true
            }
            
            continue
        }
        
        if fitIndex == phaseIndex {
            continue
        }
        
        let nextPhaseIndex = (phaseIndex + 1) % sequence.count
        
        if nextPhaseIndex == 0 {
            results.append(matchStart..<itemIndex)
            
            if fitIndex == 0 {
                matchStart = itemIndex
                phaseIndex = 0
                continue
            }
        }

        if fitIndex == nextPhaseIndex {
            phaseIndex = nextPhaseIndex
            continue
        }
        
        isMatching = false
        phaseIndex = 0
    }
    
    if isMatching && (phaseIndex == sequence.count - 1) {
        results.append(matchStart..<input.count)
    }
    
    return results
}

func occurrencies(of sequence: [Int], in input: [Int]) -> [Range<Int>] {
    guard
        sequence.count > 1,
        input.count >= sequence.count
    else {
        return []
    }
    
    var phaseIndex = 0
    var isMatching = false
    var matchStart = 0
    var results = [Range<Int>]()
    for itemIndex in 0..<input.count {
        let item = input[itemIndex]
                        
        guard
            isMatching
        else {
            if item == sequence[phaseIndex] {
                matchStart = itemIndex
                isMatching = true
            }
            
            continue
        }
        
        if item == sequence[phaseIndex] {
            continue
        }
        
        let nextPhaseIndex = (phaseIndex + 1) % sequence.count
        
        if nextPhaseIndex == 0 {
            results.append(matchStart..<itemIndex)
            
            if item == sequence[0] {
                matchStart = itemIndex
                phaseIndex = 0
                continue
            }
        }

        if item == sequence[nextPhaseIndex] {
            phaseIndex = nextPhaseIndex
            continue
        }
        
        isMatching = false
        phaseIndex = 0
    }
    
    if isMatching && (phaseIndex == (sequence.count - 1)) {
        results.append(matchStart..<input.count)
    }
    
    return results
}
