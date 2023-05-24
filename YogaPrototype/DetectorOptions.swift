//
//  DetectorOptions.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 26.10.2021.
//

import Foundation
import PoseSDK

func createModelIIOptions() -> VMBodyDetectorOptionsRef {
    var cores = cpuCoreCount()
    if cores == 0 {
        cores = 1
    }

    let options = VMBodyDetectorOptionsCreate()!
    
    let hdOptions = VMBodyDetectorOptionsGetHumanDetectorOptions(options)
    
    VMHumanDetectorOptionsSetInputWidth(hdOptions, 320)
    VMHumanDetectorOptionsSetInputHeight(hdOptions, 320)
    VMHumanDetectorOptionsSetInputIndex(hdOptions, 0)
    VMHumanDetectorOptionsSetResultIndex(hdOptions, 0)
    VMHumanDetectorOptionsSetConfidenceIndex(hdOptions, 2)
    VMHumanDetectorOptionsSetConfidenceThreshold(hdOptions, 0.5)
    VMHumanDetectorOptionsSetEngineType(hdOptions, VMMetalEngine)
    
    let humanDetectorPath = (Bundle.main.path(forResource: "detector", ofType: "tflite") ?? "") as NSString
    VMHumanDetectorOptionsSetModelPath(hdOptions, humanDetectorPath as CFString)
    
    VMHumanDetectorOptionsSetNumThreads(hdOptions, cores)

    let kpOptions = VMBodyDetectorOptionsGetKeypointDetectorOptions(options)
    VMKeypointDetectorOptionsSetInputIndex(kpOptions, 0)
    VMKeypointDetectorOptionsSetResultIndex(kpOptions, 3)
    VMKeypointDetectorOptionsSetInputWidth(kpOptions, 368)
    VMKeypointDetectorOptionsSetInputHeight(kpOptions, 368)
    VMKeypointDetectorOptionsSetKeypointCount(kpOptions, 16)
    VMKeypointDetectorOptionsSetEngineType(kpOptions, VMMetalEngine)
    
    var colorStats = VMColorStats()
    colorStats.average.red = 0.485
    colorStats.average.green = 0.456
    colorStats.average.blue = 0.406

    colorStats.stdDev.red = 0.229
    colorStats.stdDev.green = 0.224
    colorStats.stdDev.blue = 0.225

    VMKeypointDetectorOptionsSetColorStats(kpOptions, &colorStats)
    
    let keypointDetectorPath = (Bundle.main.path(forResource: "EfficientPoseII", ofType: "tflite") ?? "") as NSString
    VMKeypointDetectorOptionsSetModelPath(kpOptions, keypointDetectorPath as CFString)
    VMKeypointDetectorOptionsSetNumThreads(kpOptions, cores)

    return options
}

func createRTLiteModelOptions() -> VMBodyDetectorOptionsRef {
    var cores = cpuCoreCount()
    if cores == 0 {
        cores = 1
    }

    let options = VMBodyDetectorOptionsCreate()!
    
    let hdOptions = VMBodyDetectorOptionsGetHumanDetectorOptions(options)
    
    VMHumanDetectorOptionsSetInputWidth(hdOptions, 320)
    VMHumanDetectorOptionsSetInputHeight(hdOptions, 320)
    VMHumanDetectorOptionsSetInputIndex(hdOptions, 0)
    VMHumanDetectorOptionsSetResultIndex(hdOptions, 0)
    VMHumanDetectorOptionsSetConfidenceIndex(hdOptions, 2)
    VMHumanDetectorOptionsSetConfidenceThreshold(hdOptions, 0.5)
    VMHumanDetectorOptionsSetEngineType(hdOptions, VMMetalEngine)
    
    let humanDetectorPath = (Bundle.main.path(forResource: "detector", ofType: "tflite") ?? "") as NSString
    VMHumanDetectorOptionsSetModelPath(hdOptions, humanDetectorPath as CFString)
    
    VMHumanDetectorOptionsSetNumThreads(hdOptions, cores)

    let kpOptions = VMBodyDetectorOptionsGetKeypointDetectorOptions(options)
    VMKeypointDetectorOptionsSetInputIndex(kpOptions, 0)
    VMKeypointDetectorOptionsSetResultIndex(kpOptions, 0)
    VMKeypointDetectorOptionsSetInputWidth(kpOptions, 224)
    VMKeypointDetectorOptionsSetInputHeight(kpOptions, 224)
    VMKeypointDetectorOptionsSetKeypointCount(kpOptions, 16)
    VMKeypointDetectorOptionsSetEngineType(kpOptions, VMMetalEngine)
    
    var colorStats = VMColorStats()
    colorStats.average.red = 0.485
    colorStats.average.green = 0.456
    colorStats.average.blue = 0.406

    colorStats.stdDev.red = 0.229
    colorStats.stdDev.green = 0.224
    colorStats.stdDev.blue = 0.225

    VMKeypointDetectorOptionsSetColorStats(kpOptions, &colorStats)
    
    let keypointDetectorPath = (Bundle.main.path(forResource: "EfficientPoseRT_LITE", ofType: "tflite") ?? "") as NSString
    VMKeypointDetectorOptionsSetModelPath(kpOptions, keypointDetectorPath as CFString)
    VMKeypointDetectorOptionsSetNumThreads(kpOptions, cores)

    return options
}

func createRTModelOptions() -> VMBodyDetectorOptionsRef {
    var cores = cpuCoreCount()
    if cores == 0 {
        cores = 1
    }

    let options = VMBodyDetectorOptionsCreate()!
    
    let hdOptions = VMBodyDetectorOptionsGetHumanDetectorOptions(options)
    
    VMHumanDetectorOptionsSetInputWidth(hdOptions, 320)
    VMHumanDetectorOptionsSetInputHeight(hdOptions, 320)
    VMHumanDetectorOptionsSetInputIndex(hdOptions, 0)
    VMHumanDetectorOptionsSetResultIndex(hdOptions, 0)
    VMHumanDetectorOptionsSetConfidenceIndex(hdOptions, 2)
    VMHumanDetectorOptionsSetConfidenceThreshold(hdOptions, 0.5)
    VMHumanDetectorOptionsSetEngineType(hdOptions, VMMetalEngine)
    
    let humanDetectorPath = (Bundle.main.path(forResource: "detector", ofType: "tflite") ?? "") as NSString
    VMHumanDetectorOptionsSetModelPath(hdOptions, humanDetectorPath as CFString)
    
    VMHumanDetectorOptionsSetNumThreads(hdOptions, cores)

    let kpOptions = VMBodyDetectorOptionsGetKeypointDetectorOptions(options)
    VMKeypointDetectorOptionsSetInputIndex(kpOptions, 0)
    VMKeypointDetectorOptionsSetResultIndex(kpOptions, 3)
    VMKeypointDetectorOptionsSetInputWidth(kpOptions, 224)
    VMKeypointDetectorOptionsSetInputHeight(kpOptions, 224)
    VMKeypointDetectorOptionsSetKeypointCount(kpOptions, 16)
    VMKeypointDetectorOptionsSetEngineType(kpOptions, VMMetalEngine)
    
    var colorStats = VMColorStats()
    colorStats.average.red = 0.485
    colorStats.average.green = 0.456
    colorStats.average.blue = 0.406

    colorStats.stdDev.red = 0.229
    colorStats.stdDev.green = 0.224
    colorStats.stdDev.blue = 0.225

    VMKeypointDetectorOptionsSetColorStats(kpOptions, &colorStats)
    
    let keypointDetectorPath = (Bundle.main.path(forResource: "EfficientPoseRT", ofType: "tflite") ?? "") as NSString
    VMKeypointDetectorOptionsSetModelPath(kpOptions, keypointDetectorPath as CFString)
    VMKeypointDetectorOptionsSetNumThreads(kpOptions, cores)

    return options

}

