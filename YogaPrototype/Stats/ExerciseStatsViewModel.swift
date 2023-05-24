//
//  StatsViewModel.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 12.11.2021.
//

import Foundation
import CoreData
import Combine

class ExerciseStatsViewModel<ResultType: SessionResult>: ObservableObject {
    let exercise: Exercise
    
    @Published var stats: [ResultType] = []
    
    private var dataStore: ResultStore<ResultType>
    
    private var observer: Cancellable?
    
    init(_ exercise: Exercise, objectContext: NSManagedObjectContext) {
        self.exercise = exercise
        dataStore = ResultStore<ResultType>(exercise: exercise, objectContext: objectContext)
        
        observer = dataStore.publisher.sink {
            [unowned self] values in
            stats = values
        }
        
        stats = dataStore.results
    }
}
