//
//  PoseListViewModel.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 11.10.2021.
//

import Foundation
import Combine
import CoreData

class ExerciseListViewModel: ObservableObject {
    var objectStore: ExerciseStore
    
    private var objectObserver: AnyCancellable?
    
    init(objectStore: ExerciseStore) {
        self.objectStore = objectStore
        
        objectObserver = objectStore.$items.sink {
            [unowned self] exercises in
            var tmpItems = [ExerciseViewModel]()
            for exercise in exercises {
                let itemVM = ExerciseViewModel(exercise)
                tmpItems.append(itemVM)
            }
            
            items = tmpItems
        }
    }

    @Published var items: [ExerciseViewModel] = []
    @Published var isLoading: Bool = false
}
