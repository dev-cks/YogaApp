//
//  SessionViewModel.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 10.12.2021.
//

import Foundation
import PoseSDK

protocol SessionViewModel: ObservableObject {
    associatedtype ResultProvider: ResultViewModel
    associatedtype InputDevice: VMCaptureDevice
    
    var deviceObserver: VMCaptureDeviceObserver<InputDevice> { get }
    var resultProvider: ResultProvider { get }
    var comparator: ComparisonViewModel { get }
    var guideVM: VideoGuideViewModel { get }
    var exercise: Exercise { get }
    
    func startSession(with device: InputDevice)
    func completeSession()
}
