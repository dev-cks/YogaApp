//
//  ResultViewModel.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 10.12.2021.
//

import Foundation
import PoseSDK

protocol ResultViewModel: ObservableObject {
    var score: Float { get }
    func update(withDetection: Motion?)
    func commit(recording: VMVideoRecording)
    func saveResult()
}
