//
//  DefaultScoreProvider.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 10.12.2021.
//

import Foundation
import PoseSDK
import CoreData

class DefaultResultViewModel: ResultViewModel {
    @Published var score: Float = 0.0
    
    var reference: Exercise
    
    typealias MatchFunc = (VMDeviation) -> Float
    var matchFunc: MatchFunc
    
    private var dataStore: ResultStore<DefaultSessionResult>
    
    init(reference: Exercise, objectContext: NSManagedObjectContext, matchFunc: @escaping MatchFunc) {
        self.reference = reference
        self.matchFunc = matchFunc
        
        dataStore = ResultStore<DefaultSessionResult>(exercise: reference, objectContext: objectContext)
    }
    
    func update(withDetection detection: Motion?) {
        guard
            let motion = detection
        else {
            score = 0.0
            return
        }
        
        let fitResult = rootMeanSquareFit(test: motion,  reference: reference.motion) {
            deviation in
            return matchFunc(deviation)
        }
        
        score = fitResult.score
    }
    
    func saveResult() {
        let result = DefaultSessionResult(score: score, timestamp: Date())
        dataStore.save(result: result)
    }
    
    func commit(recording: VMVideoRecording) {
    }

}
