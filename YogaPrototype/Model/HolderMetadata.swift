//
//  HolderMetadata.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 02.12.2021.
//

import Foundation
import CoreMedia

class HolderMetadata {
    var referenceTime: CMTime
    var requiredDuration: CMTime
    
    init(referenceTime: CMTime, requredDuration: CMTime) {
        self.referenceTime = referenceTime
        self.requiredDuration = requredDuration
    }
    
    class Keys {
        private init() {}
        
        static let referenceTime = "referenceTime"
        static let requiredDuration = "requiredDuration"
    }
    
    init?(json: [String: Any]) {
        guard
            let refTimeJSON = json[Keys.referenceTime] as? [String: Any],
            let refTime = MotionSerialization.time(withJSON: refTimeJSON),
            let durationJSON = json[Keys.requiredDuration] as? [String: Any],
            let duration = MotionSerialization.time(withJSON: durationJSON)
        else {
            return nil
        }
        
        referenceTime = refTime
        requiredDuration = duration
    }
    
    var json: [String: Any] {
        return [
            Keys.referenceTime: MotionSerialization.json(withTime: referenceTime),
            Keys.requiredDuration: MotionSerialization.json(withTime: requiredDuration)
        ]
    }
}
