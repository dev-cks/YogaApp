//
//  PoseReader.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 10.01.2022.
//

import Foundation
import PoseSDK

class PoseReader {
    private(set) var confidenceThreshold: Float
    private(set) var bodyDetector: VMBodyDetector
    
    init(bodyDetector: VMBodyDetector, confidenceThreshold: Float) {
        self.confidenceThreshold = confidenceThreshold
        self.bodyDetector = bodyDetector
    }
    
    func pose(withScene scene: VMScene) -> VMPose? {
        return VMPose(scene: scene, minKeypointConfidence: confidenceThreshold)
    }
    
    func process(frame: VMRawFrame, completion: @escaping (VMPose?) -> Void) {
        bodyDetector.detectBody(in: frame) {
            [unowned self] scene in
            let pose = pose(withScene: scene)
            completion(pose)
        }
    }
    
}
