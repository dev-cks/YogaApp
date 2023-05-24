//
//  MotionSerialization.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 26.10.2021.
//

import Foundation
import AVFoundation
import PoseSDK

class MotionSerialization {
    private init() {}
    
    class Keys {
        private init() {}
        
        static let duration = "duration"
        static let value = "value"
        static let timeScale = "timeScale"
        static let frames = "frames"
        static let time = "time"
        static let pose = "pose"
    }
    
    static func json(withMotion motion: Motion) -> [String: Any] {
        var values = [String: Any]()
        values[Keys.duration] = json(withTime: motion.duration)
        
        var framesJSON = [[String: Any]]()
        for frame in motion.frames {
            var frameJSON = [String: Any]()
            frameJSON[Keys.time] = json(withTime: frame.time)
            frameJSON[Keys.pose] = frame.pose.serialize()
            framesJSON.append(frameJSON)
        }
        
        values[Keys.frames] = framesJSON
        return values
    }

    static func json(withTime time: CMTime) -> [String: Any] {
        return [Keys.value: time.value,  Keys.timeScale: time.timescale]
    }
    
    static func motion(withJSON data: [String: Any]) -> Motion? {
        guard
            let durationData = data[Keys.duration] as? [String: Any],
            let framesData = data[Keys.frames] as? [[String: Any]],
            let duration = time(withJSON: durationData)
        else {
            return nil
        }
        
        let motion = Motion()
        motion.duration = duration
        
        for frameData in framesData {
            guard
                let timeData = frameData[Keys.time] as? [String: Any],
                let time = time(withJSON: timeData),
                let poseData = frameData[Keys.pose] as? [String: Any]
            else {
                continue
            }
            
            let pose = VMPose(serializedData: poseData)
            let frame = Motion.Frame(time: time, pose: pose)
            motion.frames.append(frame)
        }
        
        return motion
    }
    
    static func time(withJSON data: [String: Any]) -> CMTime? {
        guard
            let value = data[Keys.value] as? CMTimeValue,
            let timeScale = data[Keys.timeScale] as? CMTimeScale
        else {
            return nil
        }
        
        return CMTime(value: value, timescale: timeScale)
    }
}
