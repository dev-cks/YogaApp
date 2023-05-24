//
//  MotionPattern.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 20.01.2022.
//

import Foundation
import PoseSDK

class MotionPattern: Serializable {
    var reference: [VMPose] = []
    var sequence: [Int] = []
    
    func occurrencies(in motion: Motion,
                      matchFunc: (VMPose, VMPose) -> Float) -> [Range<Int>] {
        let matches = motion.frames.map {
            frame in
            return bestMatchIndex(in: reference) {
                pose in
                return matchFunc(pose, frame.pose)
            }
        }
        
        return YogaPrototype.occurrencies(of: sequence, in: matches)
    }
    
    class Keys {
        private init() {}
        
        static let reference = "reference"
        static let sequence = "sequence"
    }
    
    init() {}
    
    //Serializable implementation
    required init?(json: [String : Any]) {
        guard
            let referenceData = json[Keys.reference] as? [[String: Any]],
            let sequenceData = json[Keys.sequence] as? [Int]
        else {
            return nil
        }
        
        for item in referenceData {
            let pose = VMPose(serializedData: item)
            reference.append(pose)
        }
        
        sequence = sequenceData
    }
    
    var json: [String : Any] {
        let referenceData = reference.map {
            item in
            return item.serialize()
        }
        
        return [
            Keys.reference: referenceData,
            Keys.sequence: sequence
        ]
    }

}
