//
//  DefaultSessionResult.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 11.12.2021.
//

import Foundation

class DefaultSessionResult: SessionResult {
    var score: Float
    var timestamp: Date

    init(score: Float, timestamp: Date) {
        self.score = score
        self.timestamp = timestamp
    }
    
    class Keys {
        private init() {}
        
        static let score = "score"
        static let timestamp = "timestamp"
    }
    
    var json: [String: Any] {
        return [
            Keys.score: score,
            Keys.timestamp: timestamp.timeIntervalSince1970
        ]
    }
    
    required init?(json: [String: Any]) {
        guard
            let scoreValue = json[Keys.score] as? Float,
            let timestampValue = json[Keys.timestamp] as? TimeInterval
        else {
            return nil
        }
        
        score = scoreValue
        timestamp = Date(timeIntervalSince1970: timestampValue)
    }
}
