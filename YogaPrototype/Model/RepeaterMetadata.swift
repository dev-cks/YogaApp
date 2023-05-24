//
//  RepeaterMetadata.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 15.12.2021.
//

import Foundation
import CoreMedia

class RepeaterMetadata: Serializable {
    var pattern: MotionPattern
    var requiredCount: Int
    
    init(pattern: MotionPattern, requiredCount: Int) {
        self.pattern = pattern
        self.requiredCount = requiredCount
    }
    
    class Keys {
        private init() {}
        
        static let pattern = "pattern"
        static let requiredCount = "requiredCount"
    }
    
    required init?(json: [String: Any]) {
        guard
            let patternData = json[Keys.pattern] as? [String: Any],
            let storedPattern = MotionPattern(json: patternData),
            let countRequirement = json[Keys.requiredCount] as? Int
        else {
            return nil
        }

        pattern = storedPattern
        requiredCount = countRequirement
    }
    
    var json: [String: Any] {
        return [
            Keys.pattern: pattern.json,
            Keys.requiredCount: requiredCount
        ]
    }
}
