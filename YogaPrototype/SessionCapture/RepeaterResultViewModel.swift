//
//  RepeaterResultViewModel.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 15.12.2021.
//

import Foundation
import PoseSDK
import AVFoundation
import CoreData

class RepeaterResultViewModel: ResultViewModel {
    @Published var score: Float = 0.0
    @Published var detection: Motion?
    @Published var repeatCount: Int = 0
    @Published var isProcessing: Bool = false
    @Published var progress: Float = 0.0
    
    var reference: Exercise
    var metadata: RepeaterMetadata?
    var resultStore: ResultStore<RepeaterSessionResult>
    var motionExtractor: MotionExtractor
    
    typealias Matcher =  (VMPose, VMPose) -> Float
    var match: Matcher
    
    init(reference: Exercise,
         motionExtractor: MotionExtractor,
         objectContext: NSManagedObjectContext,
         match: @escaping Matcher) {
        self.reference = reference
        self.motionExtractor = motionExtractor
        self.match = match
        resultStore = ResultStore<RepeaterSessionResult>(exercise: reference, objectContext: objectContext)
        
        guard
            reference.type == .repeater
        else {
            return
        }
        
        for object in self.reference.metadata {
            if let meta = object as? RepeaterMetadata {
                metadata = meta
            }
        }
    }
    
    func update(withDetection maybeDetection: Motion?) {
        self.detection = maybeDetection
        
        guard
            let motion = maybeDetection
        else {
            return
        }
        
        guard
            let repetitions = metadata?.pattern.occurrencies(in: motion, matchFunc: match)
        else {
            return
        }
        
        repeatCount = repetitions.count
        if let requiredCount = metadata?.requiredCount,
           requiredCount > 0 {
            score = min(Float(repeatCount) / Float(requiredCount), 1.0)
        }
    }
    
    func saveResult() {
        let result = RepeaterSessionResult(score: score, repeatCount: repeatCount, timestamp: Date())
        resultStore.save(result: result)
    }
    
    var recording: VMVideoRecording?
    var processingThread: Thread?
    
    private func processRecording() {
        guard
            let contentLocation = recording?.location
        else {
            DispatchQueue.main.async {
                [weak self] in
                self?.saveResult()
                self?.isProcessing = false
            }
            
            return
        }

        processingThread = Thread {
            [weak self] in
            guard
                let this = self
            else {
                return
            }
            
            let motion = this.motionExtractor.motion(from: contentLocation) {
                [weak self] progressValue in
                DispatchQueue.main.async {
                    [weak self] in
                    guard
                        let this = self
                    else {
                        return
                    }
                    
                    this.progress = max(this.progress, progressValue)
                }
            }
            
            DispatchQueue.main.async {
                [weak self] in
                self?.update(withDetection: motion)
                self?.saveResult()
                self?.isProcessing = false
            }
        }
        
        processingThread?.qualityOfService = .userInteractive
        processingThread?.start()
    }
    
    func commit(recording: VMVideoRecording) {
        isProcessing = true
        self.recording = recording
        
        recording.finish {
            [unowned self] in
            processRecording()
        }
    }
}
