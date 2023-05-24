//
//  HolderViewModel.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 03.12.2021.
//

import Foundation
import PoseSDK
import AVFoundation
import CoreData

class HolderResultViewModel: ResultViewModel {
    @Published var duration: CMTime = CMTime(value: 0, timescale: 600)
    
    @Published var motion: Motion? {
        didSet {
            duration = durationValue()
        }
    }
    
    var reference: Exercise
    var matchScoreFunc: (VMDeviation) -> Float
    var matchThreshold: Float
    var metadata: HolderMetadata?
    
    var requiredDuration: CMTime {
        return metadata?.requiredDuration ?? CMTime(value: 0, timescale: 600)
    }
    
    var score: Float {
        guard
            let refSeconds = metadata?.requiredDuration.seconds,
            refSeconds > 0
        else {
            return 0.0
        }
        
        if duration.seconds >= refSeconds {
            return 1.0
        }
        
        return Float(duration.seconds / refSeconds)
    }
    
    private var resultStore: ResultStore<HolderSessionResult>
        
    init(reference: Exercise,
         objectContext: NSManagedObjectContext,
         matchThreshold: Float,
         matchScoreFunc: @escaping (VMDeviation) -> Float) {
        self.reference = reference
        self.matchThreshold = matchThreshold
        self.matchScoreFunc = matchScoreFunc
        
        resultStore = ResultStore<HolderSessionResult>(exercise: reference, objectContext: objectContext)
        
        guard
            reference.type == .holder
        else {
            return
        }

        for value in reference.metadata {
            if let meta = value as? HolderMetadata {
                metadata = meta
                return
            }
        }
    }
    
    private func durationValue() -> CMTime {
        guard
            let refTime = metadata?.referenceTime,
            let refIndex = reference.motion.indexOfFrame(closestTo: refTime)
        else {
            return CMTime(value: 0, timescale: 600)
        }
        
        let refPose = reference.motion.frames[refIndex].pose
        return motion?.holdDuration {
            frame in
            let deviation = frame.pose.deviation(from: refPose)
            let score = matchScoreFunc(deviation)
            return (score >= matchThreshold)
        } ?? CMTime(value: 0, timescale: 600)
    }
    
    func update(withDetection detection: Motion?) {
        motion = detection
    }

    func saveResult() {
        let result = HolderSessionResult(duration: duration, score: score, timestamp: Date())
        resultStore.save(result: result)
    }
    
    func commit(recording: VMVideoRecording) {
        saveResult()
    }

}
