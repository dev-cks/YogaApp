//
//  ExerciseViewModel.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 13.10.2021.
//

import Foundation
import Combine
import CoreData
import UIKit
import AVFoundation

class ExerciseViewModel: NSObject,
                            ObservableObject,
                            NSFetchedResultsControllerDelegate {
    @Published var exercise: Exercise
    @Published var preview: UIImage?
    
    init(_ exercise: Exercise) {
        self.exercise = exercise
        preview = previewImage(for: exercise)
    }
}
