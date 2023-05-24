//
//  RepeaterSessionResult.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 17.12.2021.
//

import Foundation

class RepeaterSessionResult: SessionResult {
    var score: Float
    var repeatCount: Int
    var timestamp: Date
    
    init(score: Float, repeatCount: Int, timestamp: Date) {
        self.score = score
        self.repeatCount = repeatCount
        self.timestamp = timestamp
    }
    
    class Keys {
        private init() {}
        static let score = "score"
        static let timestamp = "timestamp"
        static let repeatCount = "repeatCount"
    }
    
    required init?(json: [String : Any]) {
        guard
            let timestampSeconds = json[Keys.timestamp] as? TimeInterval,
            let count = json[Keys.repeatCount] as? Int,
            let mark = json[Keys.score] as? Float
        else {
            return nil
        }
        score = mark
        repeatCount = count
        timestamp = Date(timeIntervalSince1970: timestampSeconds)
    }
    
    var json: [String : Any] {
        return [
            Keys.score: score,
            Keys.timestamp: timestamp.timeIntervalSince1970,
            Keys.repeatCount: repeatCount
        ]
    }
}
