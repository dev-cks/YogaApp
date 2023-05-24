//
//  OptimalDeviation.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 01.11.2021.
//

import Foundation
import PoseSDK

struct MotionFitResult {
    var deviation = VMDeviation(value: .nan, accuracy: 0.0)
    var frameOffset: Int = -1
    var score: Float = -Float.greatestFiniteMagnitude
}

func rootMeanSquareFit(test testMotion: Motion,
                       reference referenceMotion: Motion,
                       scoreFunction: (VMDeviation) -> Float) -> MotionFitResult {
    var result = MotionFitResult()
    let minOffset = 1 - testMotion.frames.count
    for offset in minOffset..<referenceMotion.frames.count {
        let deviations = testMotion.deviations(from: referenceMotion, offsetIndex: offset)
        
        if deviations.isEmpty {
            continue
        }
        
        var squaredValuesSum: Float = 0.0
        var squaredAccuraciesSum: Float = 0.0
        
        var actualCount: Float = 0.0
        for item in deviations {
            if item.value.isNaN {
                continue
            }
            
            squaredValuesSum += item.value * item.value
            squaredAccuraciesSum += item.accuracy * item.accuracy
            actualCount += 1
        }
        
        let meanDeviation = actualCount > 0 ? VMDeviation(value: sqrt(squaredValuesSum / actualCount),
                                            accuracy: sqrt(squaredAccuraciesSum / actualCount)) : VMDeviation(value: .nan, accuracy: 0.0)
        
        let score = scoreFunction(meanDeviation)
        if (score > result.score)  {
            result.frameOffset = offset
            result.deviation = meanDeviation
            result.score = score
        }
    }
    
    return result
}
