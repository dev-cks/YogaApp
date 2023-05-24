//
//  MotionExtractor.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 18.01.2022.
//

import Foundation
import PoseSDK

class MotionExtractor {
    var detector: VMBodyDetector
    var minKeypointConfidence: Float = 0.0
    var offset: CMTime = .zero
    var frameDuration: CMTime = CMTime(value: 10, timescale: 600)
    var frameTolerance: CMTime = .zero
    
    func motion(from assetURL: URL, progressCallback: ((Float) -> Void)? = nil) -> Motion {
        let reader = VideoReader(url: assetURL)
        reader.generator.requestedTimeToleranceBefore = frameTolerance
        reader.generator.requestedTimeToleranceAfter = frameTolerance
        return reader.motion(withFrameDuration: frameDuration,
                             startOffset: offset,
                             detector: detector,
                             confidenceThreshold: minKeypointConfidence,
                             progressCallback: progressCallback)
    }
    
    init(detector: VMBodyDetector) {
        self.detector = detector
    }
}
