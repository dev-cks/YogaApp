//
//  Score.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 14.10.2021.
//

import Foundation
import PoseSDK

class YogaScore {
    var characteristicValue: Float
    
    init(characteristicValue: Float) {
        self.characteristicValue = characteristicValue
    }
    
    func compute(_ deviation: VMDeviation) -> Float {
        if deviation.accuracy <= 0 {
            return 0.0
        }
        
        if (deviation.value == 0) {
            return deviation.accuracy
        } else if (deviation.value <= 0) {
            return 0.0
        }
        
        return deviation.accuracy * tanh(characteristicValue / deviation.value)
    }
}
