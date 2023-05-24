//
//  KeypointDetectorModelType.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 03.11.2021.
//

import Foundation

enum KeypointDetectorModelType: Int, CaseIterable {
    typealias RawValue = Int
    
    case modelII = 0,
    RTModel,
    RTLiteModel
}
