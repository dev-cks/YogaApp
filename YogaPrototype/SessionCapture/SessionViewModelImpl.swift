//
//  MainViewModel.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 06.10.2021.
//

import UIKit
import Combine
import PoseSDK
import CoreData
import CoreMedia

class SessionViewModelImpl<InputDevice: VMCaptureDevice, ConcreteResultProvider: ResultViewModel>: SessionViewModel {
    var deviceObserver: VMCaptureDeviceObserver<InputDevice>
    
    private(set) var comparator: ComparisonViewModel
    
    lazy var guideVM: VideoGuideViewModel = {
        [unowned self] in
        
        let videoParts = exercise.video.split(separator: ".")
        let videoURL = Bundle.main.url(forResource: String(videoParts[0]), withExtension: String(videoParts[1]))!
        return VideoGuideViewModel(videoURL)
    } ()
    
    var frameStore: FrameStore

    var exercise: Exercise {
        return comparator.reference
    }
        
    private var sceneObserver: Cancellable?
    private var detectionObserver: Cancellable?
    private var frameObserver: Cancellable?
    
    private var cache: VMVideoRecording?
    
    var resultProvider: ConcreteResultProvider
    
    private func receive(frame: VMRawFrame) {
        cache?.append(frame.content)
    }
    
    func startSession(with device: InputDevice) {
        let cacheName = "\(UUID().uuidString).mov"
        let cacheLocation = FileManager.default.temporaryDirectory.appendingPathComponent(cacheName)
        cache = try? VMVideoRecording(location: cacheLocation, type: .mov, timeScale: 600)
        
        frameObserver = deviceObserver.frameSubject.sink {
            [unowned self] maybeFrame  in
            guard
                let frame = maybeFrame
            else {
                return
            }
            
            receive(frame: frame)
        }
        
        deviceObserver.observe(captureDevice: device)
    }
    
    func completeSession() {
        deviceObserver.stopObserving()
        frameObserver = nil
        
        if let recording = cache {
            resultProvider.commit(recording: recording)
        }
    }
    
    init(deviceObserver: VMCaptureDeviceObserver<InputDevice>,
         comparator: ComparisonViewModel,
         resultProvider: ConcreteResultProvider) {
        self.deviceObserver = deviceObserver
        self.comparator = comparator
        self.resultProvider = resultProvider
        
        frameStore = try! FrameStore()
        
        detectionObserver = comparator.$detectedMotion.sink {
            [unowned self] detection in
            self.resultProvider.update(withDetection: detection)
        }
        
        sceneObserver = deviceObserver.$scene.sink {
            [unowned self] newScene in
            self.comparator.pushScene(newScene)
        }
    }
}
