//
//  HolderResult.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 10.12.2021.
//

import Foundation
import CoreMedia

class HolderSessionResult: SessionResult{
    var duration: CMTime
    var score: Float
    var timestamp: Date

    init(duration: CMTime, score: Float, timestamp: Date) {
        self.duration = duration
        self.score = score
        self.timestamp = timestamp
    }
    
    class Keys {
        private init() {}
        
        static let duration = "duration"
        static let score = "score"
        static let timestamp = "timestamp"
    }
    
    var json: [String: Any] {
        return [
            Keys.duration: MotionSerialization.json(withTime: duration),
            Keys.score: score,
            Keys.timestamp: timestamp.timeIntervalSince1970
        ]
    }
    
    required init?(json: [String: Any]) {
        guard
            let durationDict = json[Keys.duration] as? [String: Any],
            let durationValue = MotionSerialization.time(withJSON: durationDict),
            let scoreValue = json[Keys.score] as? Float,
            let timestampValue = json[Keys.timestamp] as? TimeInterval
        else {
            return nil
        }
        
        duration = durationValue
        score = scoreValue
        timestamp = Date(timeIntervalSince1970: timestampValue)
    }
}
