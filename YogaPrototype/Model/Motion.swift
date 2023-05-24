//
//  VideoReference.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 25.10.2021.
//

import Foundation
import AVFoundation
import PoseSDK

enum MotionError: Error {
    case invalidArgument
}

class Motion {
    
    struct Frame {
        var time: CMTime
        var pose: VMPose
    }

    var duration: CMTime = CMTime(value: 0, timescale: 1)
    var frames: [Frame] = []
    
    func findFrame(matching pose: VMPose, match: (VMPose, VMPose) -> Float) -> Int {
        var bestScore = -Float.greatestFiniteMagnitude
        var bestIndex = -1
        for index in 0..<frames.count {
            let frame = frames[index]
            let score = match(frame.pose, pose)
            if (score > bestScore) {
                bestIndex = index
                bestScore = score
            }
        }
        
        return bestIndex
    }
    
    func indexOfFrame(closestTo time: CMTime, within range: Range<Int>) -> Int? {
        guard
            !range.isEmpty
        else {
            return nil
        }
        
        let maxRange = 0..<frames.count
        let actualRange = range.clamped(to: maxRange)
        guard
            !actualRange.isEmpty,
            let minIndex = actualRange.first,
            let maxIndex = actualRange.last
        else {
            return nil
        }
        
        if (minIndex == maxIndex) {
            return minIndex
        }
        
        let minTime = frames[minIndex].time
        let maxTime = frames[maxIndex].time
        if (CMTimeCompare(time, minTime) < 0) {
            return minIndex
        } else if (CMTimeCompare(maxTime, time) < 0) {
            return maxIndex
        }
        
        if ((maxIndex - minIndex) == 1) {
            let maxDiff = CMTimeSubtract(maxTime, time)
            let minDiff = CMTimeSubtract(time, minTime)
            if (CMTimeCompare(minDiff, maxDiff) < 0) {
                return minIndex
            } else {
                return maxIndex
            }
        }
        
        let midIndex = (minIndex + maxIndex) / 2
        let midTime = frames[midIndex].time
        
        if (CMTimeCompare(time, midTime) < 0) {
            return indexOfFrame(closestTo: time, within: minIndex..<midIndex)
        } else {
            return indexOfFrame(closestTo: time, within: midIndex..<actualRange.upperBound)
        }
    }
    
    func indexOfFrame(closestTo time: CMTime) -> Int? {
        let zero = CMTime(value: 0, timescale: 600)
        if ((CMTimeCompare(duration, time) < 0) || (CMTimeCompare(time, zero) < 0)) {
            return nil
        }
        
        return indexOfFrame(closestTo: time, within: 0..<frames.count)
    }
    
    func deviations(from otherMotion: Motion, offsetIndex: Int) -> [VMDeviation] {
        var results = [VMDeviation]()
        let minOffset = -frames.count + 1
        let maxOffset = otherMotion.frames.count - 1
        if (frames.isEmpty || otherMotion.frames.isEmpty || (offsetIndex < minOffset) || (offsetIndex > maxOffset)) {
            return results
        }
        
        var offsetTime = CMTime(value: 0, timescale: 600)
        if (offsetIndex > 0) {
            offsetTime = CMTimeAdd(offsetTime, otherMotion.frames[offsetIndex].time)
        } else if (offsetIndex < 0) {
            offsetTime = CMTimeSubtract(offsetTime, frames[frames.count + offsetIndex].time)
        }

        for frame in frames {
            let currentTime = CMTimeAdd(frame.time, offsetTime)
            guard
                let matchIndex = otherMotion.indexOfFrame(closestTo: currentTime)
            else {
                break
            }
            
            let otherFrame = otherMotion.frames[matchIndex]
            results.append(frame.pose.deviation(from: otherFrame.pose))
        }
        
        return results
    }
    
    func holdDuration(_ matching: (Frame) -> Bool) -> CMTime {
        var wasMatching: Bool = false
        var startTime = CMTime(value: 0, timescale: 600)
        var maxDuration = CMTime(value: 0, timescale: 600)
        
        for index in 0..<frames.count {
            let frame = frames[index]
            let isMatching = matching(frame)
            let lastIndex =  frames.count - 1
            
            if isMatching && !wasMatching {
                startTime = frame.time
                wasMatching = true
            } else if wasMatching && (!isMatching || (index == lastIndex)) {
                wasMatching = false
                let duration = CMTimeSubtract(frame.time, startTime)
                if (CMTimeCompare(maxDuration, duration) < 0) {
                    maxDuration = duration
                }
            }
        }
        
        return maxDuration
    }
}
