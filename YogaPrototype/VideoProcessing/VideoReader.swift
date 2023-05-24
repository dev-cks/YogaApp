//
//  VideoParser.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 21.10.2021.
//

import Foundation
import AVFoundation
import PoseSDK

class VideoReader {
    private(set) var asset: AVURLAsset
    private(set) var generator: AVAssetImageGenerator
    
    init(url: URL) {
        asset = AVURLAsset(url: url)
        generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceBefore = .zero
        generator.requestedTimeToleranceAfter = .zero
    }
    
    func frame(at time: CMTime) throws -> CGImage {
        let content = try generator.copyCGImage(at: time, actualTime: nil)
        return content
    }
    
    func motion(withFrameDuration frameDuration: CMTime,
                startOffset: CMTime,
                detector: VMBodyDetector,
                confidenceThreshold: Float,
                progressCallback: ((Float) -> Void)? = nil) -> Motion {
        let motion = Motion()
        motion.duration = asset.duration
        var currentTime = startOffset
        var timestamps = [CMTime]()
        while (CMTimeCompare(currentTime, motion.duration) == -1) {
            timestamps.append(currentTime)
            currentTime = CMTimeAdd(currentTime, frameDuration)
        }
        
        var count = 0
        for timestamp in timestamps {
            count += 1
            progressCallback?(Float(count) / Float(timestamps.count))
            
            guard
                let frame = try? frame(at: timestamp)
            else {
                continue
            }
            
            let scene = detector.detectBody(in: frame, at: timestamp)
            guard
                let pose = VMPose(scene: scene, minKeypointConfidence: confidenceThreshold)
            else {
                continue
            }
            
            let motionFrame = Motion.Frame(time: timestamp, pose: pose)
            motion.frames.append(motionFrame)
        }
        
        return motion
    }
}
