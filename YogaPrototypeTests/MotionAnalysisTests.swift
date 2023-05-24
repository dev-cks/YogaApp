//
//  MotionAnanlysisTests.swift
//  YogaPrototypeTests
//
//  Created by Sergii Kutnii on 11.11.2021.
//

import XCTest
@testable import YogaPrototype
import CoreMedia
import PoseSDK

class MotionAnalysisTests: XCTestCase {
    
    var localBundle = Bundle(for: MotionAnalysisTests.self)
    
    lazy var referenceURL: URL = {
        [unowned self] in
        return localBundle.url(forResource: "warrior", withExtension: "json")!
    } ()
    
    lazy var testURL: URL = {
        [unowned self] in
        return localBundle.url(forResource: "me_warrior", withExtension: "json")!
    } ()
    
    var referenceMotion: Motion!
    var testMotion: Motion!
    
    struct InitError: Error {
        
    }

    override func setUpWithError() throws {
        let referenceData = try Data(contentsOf: referenceURL)
        let testData = try Data(contentsOf: testURL)
        guard
            let referenceJSON = try JSONSerialization.jsonObject(with: referenceData, options: []) as? [String: Any],
            let testJSON = try JSONSerialization.jsonObject(with: testData, options: []) as? [String: Any]
        else {
            throw InitError()
        }
        
        referenceMotion = MotionSerialization.motion(withJSON: referenceJSON)
        testMotion = MotionSerialization.motion(withJSON: testJSON)
    }

    override func tearDownWithError() throws {
    }
    
    func testFrameMatching() throws {
        let testTime = CMTime(value: 6442, timescale: 600)
        guard
            let testFrameIndex = testMotion.indexOfFrame(closestTo: testTime)
        else {
            XCTFail("Could not find test frame")
            return
        }
        
        let score = YogaScore(characteristicValue: 0.05)
        let testFrame = testMotion.frames[testFrameIndex]
        
        let matchIndex = referenceMotion.findFrame(matching: testFrame.pose) {
            pose1, pose2 in
            let deviation = pose1.deviation(from: pose2)
            return score.compute(deviation)
        }
        
        let match = referenceMotion.frames[matchIndex]
        let deviation = testFrame.pose.deviation(from: match.pose)
        
        guard
            let testKeypoints = testFrame.pose.normalizedKeypoints(relativeTo: .pelvis),
            let refKeypoints = match.pose.normalizedKeypoints(relativeTo: .pelvis)
        else {
            XCTFail("Invalid test data")
            return
        }
        
        for bodyPart in VMBodyPart.allCases {
            guard
                let testPoint = testKeypoints[bodyPart],
                let refPoint = refKeypoints[bodyPart]
            else {
                XCTFail("Keypoint \(bodyPart.rawValue) not found")
                return
            }
            
            print("\(bodyPart.rawValue): [\(testPoint.location.x), \(testPoint.location.y)] - [\(refPoint.location.x), \(refPoint.location.y)]")
        }
        
        print("Deviation: {value: \(deviation.value), accuracy: \(deviation.accuracy)}")
        print("Score: \(score.compute(deviation))")
    }

    func testMotionFit() throws {
        let score = YogaScore(characteristicValue: 0.05)
        let fitResult = rootMeanSquareFit(test: testMotion,  reference: referenceMotion) {
            deviation in
            return score.compute(deviation)
        }

        XCTAssert(fitResult.score > 0, "Score must not be zero")
    }
    
    func testOccurrenciesSearch() throws {
        let climberURL = Bundle.main.url(forResource: "mountain_climber", withExtension: "json")!
        let climberData = try Data(contentsOf: climberURL)
        let climberJSON = try JSONSerialization.jsonObject(with: climberData, options: []) as! [String: Any]
        let climberReference = MotionSerialization.motion(withJSON: climberJSON)!
        let refTimes = [
            CMTime(value: 850, timescale: 600),
            CMTime(value: 960, timescale: 600),
            CMTime(value: 1070, timescale: 600)
        ]
        
        let pattern = MotionPattern()
        pattern.reference = refTimes.map {
            time -> VMPose in
            let index = climberReference.indexOfFrame(closestTo: time)!
            return climberReference.frames[index].pose
        }
        
        pattern.sequence = [0, 1, 2, 1]
        
        let testURL = localBundle.url(forResource: "mountain_climber_test_data", withExtension: "json")!
        let testData = try Data(contentsOf: testURL)
        let testJSON = try JSONSerialization.jsonObject(with: testData, options: []) as! [String: Any]
        let testMotion = MotionSerialization.motion(withJSON: testJSON)!
        
        let scoreProvider = YogaScore(characteristicValue: 0.05)
        
        let matches = pattern.occurrencies(in: testMotion) {
            pose1, pose2 in
            let deviation = pose1.deviation(from: pose2)
            return scoreProvider.compute(deviation)
        }
        
        let matchIndices = testMotion.frames.map {
            testFrame in
            return bestMatchIndex(in: pattern.reference) {
                refPose -> Float in
                let deviation = testFrame.pose.deviation(from: refPose)
                return scoreProvider.compute(deviation)
            }
        }
        
        print(matchIndices)
        
        XCTAssertFalse(matches.isEmpty, "Must be some matches")
    }
}

