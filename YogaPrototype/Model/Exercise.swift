//
//  Sample.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 12.10.2021.
//

import Foundation
import PoseSDK

class Exercise {
    var uid: UUID
    var name: String
    var video: String
    var thumnail: String
    var previewOffset: TimeInterval
    var motion: Motion
    var type: ExerciseType
    var metadata: [Any] = []
    
    init?(data: ExerciseData) {
        guard
            let theId = data.uid,
            let storedName = data.name,
            let storedVideoName = data.videoName,
            let storedThumnailName = data.thumnailName,
            let motionData = data.motionData,
            let motionJSON = try? JSONSerialization.jsonObject(with: motionData, options: []) as? [String: Any],
            let storedMotion = MotionSerialization.motion(withJSON: motionJSON),
            let storedType = ExerciseType(rawValue: Int(data.type))
        else {
            return nil
        }
        
        uid = theId
        name = storedName
        video = storedVideoName
        thumnail = storedThumnailName
        previewOffset = data.previewOffset
        motion = storedMotion
        type = storedType
    }
}
