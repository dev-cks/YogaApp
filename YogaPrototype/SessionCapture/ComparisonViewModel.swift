//
//  ComparisonViewModel.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 14.10.2021.
//

import Foundation
import PoseSDK
import AVFoundation

class ComparisonViewModel: ObservableObject {
    @Published var reference: Exercise
    @Published var detectedMotion: Motion?
    @Published var comparison: PoseComparison = PoseComparison()

    var scenes: [VMScene] = []
    var scenePoses = [Int: VMPose]()

    var confidenceThreshold: Float
    
    var scoreThreshold: Float = 1.0
    
    var scoreFunc: (VMDeviation) -> Float = {
        _ in
        return 0.0
    }
    
    var sceneSize: CGSize? {
        guard
            let actualScene = scenes.last
        else {
            return nil
        }
        
        return CGSize(width: actualScene.width, height: actualScene.height)
    }
        
    init(reference: Exercise, confidenceThreshold: Float) {
        self.reference = reference
        self.confidenceThreshold = confidenceThreshold
    }
    
    func pushScene(_ scene: VMScene) {
        guard
            let pose = VMPose(scene: scene, minKeypointConfidence: confidenceThreshold),
            !pose.keypoints.isEmpty
        else {
            comparison = PoseComparison()
            return
        }
        
        let maxIndex = scenes.count
        scenes.append(scene)
        scenePoses[maxIndex] = pose
        
        let motion = Motion()
        motion.duration = scenesDuration
        for index in 0..<scenes.count {
            let currentScene = scenes[index]
            let currentTime = currentScene.timestamp
            let frame = Motion.Frame(time: currentTime, pose: scenePoses[index]!)
            motion.frames.append(frame)
        }
        
        detectedMotion = motion

        let bestFitIndex = reference.motion.findFrame(matching: pose) {
            (test, ref) -> Float in
            let deviation = ref.deviation(from: test)
            return scoreFunc(deviation)
        }
        
        let reference = reference.motion.frames[bestFitIndex].pose
        comparison = PoseComparison(reference: reference, actual: pose)
    }
    
    var scenesDuration: CMTime {
        guard
            scenes.count > 0
        else{
            return CMTime(value: 0, timescale: 1)
        }
        
        let startTimestamp = scenes.first!.timestamp
        let endTimestamp = scenes.last!.timestamp
        
        return CMTimeSubtract(endTimestamp, startTimestamp)
    }
    
    var poseMapping: CGAffineTransform? {
        guard
            let srcPose = comparison.reference,
            let destPose = comparison.actual,
            let srcRadius = srcPose.boundingRadius(relativeTo: .pelvis),
            let destRadius = destPose.boundingRadius(relativeTo: .pelvis),
            srcRadius > 0,
            destRadius > 0,
            let srcOrigin = srcPose.keypoints[.pelvis]?.location,
            let destOrigin = destPose.keypoints[.pelvis]?.location
        else {
            return nil
        }
                
        let scale = destRadius / srcRadius
        
        let srcTranslate = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: -srcOrigin.x, ty: -srcOrigin.y)
        let scaleRel = CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: 0, ty: 0)
        let destTranslate = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: destOrigin.x, ty: destOrigin.y)
        return srcTranslate.concatenating(scaleRel).concatenating(destTranslate)
    }
    
    var matchSucceeds: Bool {
        guard
            let actualPose = comparison.actual,
            let suggestion = comparison.reference
        else {
            return false
        }
        
        return (scoreFunc(actualPose.deviation(from: suggestion)) >= scoreThreshold)
    }
    
}
