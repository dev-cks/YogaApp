//
//  YogaAppContext.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 06.10.2021.
//

import UIKit
import PoseSDK
import CoreData
import CoreMedia

class YogaAppViewModel: ObservableObject {
    
    var scoreProvider = YogaScore(characteristicValue: 0.05)
    var matchThreshold: Float = 0.51
    var minKeypointConfidence: Float = 0.0
    var captureTimeScale: CMTimeScale = 600
    
    lazy var bodyDetector: VMBodyDetector = createBodyDetector(withModelType: modelType)
    
    private func createDetectorOptions(withModelType modelType: KeypointDetectorModelType) -> VMBodyDetectorOptionsRef {
        switch(modelType) {
        case .modelII:
            return createModelIIOptions()
        case .RTModel:
            return createRTModelOptions()
        case .RTLiteModel:
            return createRTLiteModelOptions()
        }
    }
    
    private func createBodyDetector(withModelType modelType: KeypointDetectorModelType) -> VMBodyDetector {
        let detectorOptions = createDetectorOptions(withModelType: modelType)
        defer {
            VMBodyDetectorOptionsDelete(detectorOptions)
        }
        
        return VMBodyDetector(options: detectorOptions)
    }

    let persistenceController = PersistenceController()
    
    var mainDataStore: NSManagedObjectContext {
        return persistenceController.container.viewContext
    }
    
    private lazy var loaderContext: NSManagedObjectContext = {
        [unowned self] in
        var context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainDataStore
        return context
    } ()
    
    lazy var exerciseStore = ExerciseStore(objectContext: mainDataStore)
    lazy var samplesViewModel = ExerciseListViewModel(objectStore: exerciseStore)
    
    static let samplesLoadedKey = "samplesLoaded"
    static let modelTypeKey = "modelType"
    
    @Published var modelType: KeypointDetectorModelType {
        didSet {
            UserDefaults.standard.set(modelType.rawValue, forKey: YogaAppViewModel.modelTypeKey)
            bodyDetector = createBodyDetector(withModelType: modelType)
        }
    }
    
    var samplesLoaded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: YogaAppViewModel.samplesLoadedKey)
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: YogaAppViewModel.samplesLoadedKey)
        }
    }
    
    func loadSampleData() {
        samplesViewModel.isLoading = true
        
        loaderContext.perform {
            [unowned self] in
            let warriorReference = "warrior.mov"
            let warriorOffset = Double(10.0)
            
            let warriorData = ExerciseData(context: self.mainDataStore)
            let warriorURL = Bundle.main.url(forResource: "warrior", withExtension: "json")!
            warriorData.motionData = try! Data(contentsOf: warriorURL)
            warriorData.name = "WARRIOR II"
            warriorData.thumnailName = "thumb_warrior"
            warriorData.uid = UUID()
            warriorData.previewOffset = warriorOffset
            warriorData.videoName = warriorReference
            warriorData.type = Int32(ExerciseType.holder.rawValue)
            
            let warriorTime = CMTime(value: 7070, timescale: 600)
            let warriorDuration = CMTime(value: 6000, timescale: 600)
            let warriorMeta = HolderMetadata(referenceTime: warriorTime, requredDuration: warriorDuration)
            let warriorMetaItem = ["type": MetadataType.holderPose.rawValue, "value": warriorMeta.json] as [String: Any]
            warriorData.meta = try! JSONSerialization.data(withJSONObject: [warriorMetaItem], options: [])

            let squatReference = "ideal_squat.mp4"
            let squatOffset = Double(2.0)
                    
            let squatData = ExerciseData(context: self.mainDataStore)
            let squatURL = Bundle.main.url(forResource: "ideal_squat", withExtension: "json")!
            squatData.motionData = try! Data(contentsOf: squatURL)
            squatData.name = "SQUAT"
            squatData.thumnailName = "thumb_squat"
            squatData.uid = UUID()
            squatData.previewOffset = squatOffset
            squatData.videoName = squatReference
            squatData.type = Int32(ExerciseType.repeater.rawValue)
            
            let squatTimes = [
                CMTime(value: 500, timescale: 600),
                CMTime(value: 1000, timescale: 600)
            ]
            
            let squatJSON = try! JSONSerialization.jsonObject(with: squatData.motionData!, options: []) as! [String: Any]
            let squatMotion = MotionSerialization.motion(withJSON: squatJSON)!
            
            let squatPattern = MotionPattern()
            squatPattern.reference = squatTimes.compactMap({
                time in
                let index = squatMotion.indexOfFrame(closestTo: time)!
                return squatMotion.frames[index].pose
            })
            
            squatPattern.sequence = [0, 1]
            
            let squatMeta = RepeaterMetadata(pattern: squatPattern, requiredCount: 10)
            let squatMetaItem = ["type": MetadataType.repeaterPose.rawValue, "value": squatMeta.json] as [String: Any]
            squatData.meta = try! JSONSerialization.data(withJSONObject: [squatMetaItem], options: [])

            let climberReference = "mountain_climber.mov"
            let climberOffset = Double(0.1)
            
            let climberData = ExerciseData(context: self.mainDataStore)
            let climberURL = Bundle.main.url(forResource: "mountain_climber", withExtension: "json")!
            climberData.motionData = try! Data(contentsOf: climberURL)
            climberData.name = "MOUNTAIN\nCLIMBER"
            climberData.thumnailName = "thumb_climber"
            climberData.uid = UUID()
            climberData.previewOffset = climberOffset
            climberData.videoName = climberReference
            climberData.type = Int32(ExerciseType.repeater.rawValue)

            let climberTimes = [
                CMTime(value: 870, timescale: 600),
                CMTime(value: 960, timescale: 600),
                CMTime(value: 1070, timescale: 600)
            ]
            
            let climberJSON = try! JSONSerialization.jsonObject(with: climberData.motionData!, options: []) as! [String: Any]
            let climberMotion = MotionSerialization.motion(withJSON: climberJSON)!
            
            let climberPattern = MotionPattern()
            climberPattern.reference = climberTimes.compactMap {
                time -> VMPose in
                let index = climberMotion.indexOfFrame(closestTo: time)!
                return climberMotion.frames[index].pose
            }
            
            climberPattern.sequence = [0, 1, 2, 1]
            
            let climberMeta = RepeaterMetadata(pattern: climberPattern, requiredCount: 10)
            let climberMetaItem = ["type": MetadataType.repeaterPose.rawValue, "value": climberMeta.json] as [String: Any]
            climberData.meta = try! JSONSerialization.data(withJSONObject: [climberMetaItem], options: [])

            do {
                try self.loaderContext.save()
            } catch {
                print("Unable to save sample data")
            }
            
            self.mainDataStore.performAndWait {
                [unowned self] in
                do {
                    try self.mainDataStore.save()
                } catch {
                    print("Unable to save main object context")
                }
            }
            
            DispatchQueue.main.async {
                [weak self] in
                self?.samplesViewModel.isLoading = false
            }
        }
    }
    
    func newDeviceObserver<Input: VMCaptureDevice>() -> VMCaptureDeviceObserver<Input> {
        return VMCaptureDeviceObserver<Input>(detector: bodyDetector, timeScale: captureTimeScale)
    }
    
    func newPoseReader() -> PoseReader {
        return PoseReader(bodyDetector: bodyDetector, confidenceThreshold: minKeypointConfidence)
    }
    
    func newMotionExtractor() -> MotionExtractor {
        let extractor = MotionExtractor(detector: bodyDetector)
        extractor.frameDuration = CMTime(value: 60, timescale: 600)
        extractor.frameTolerance = .zero
        return extractor
    }
    
    func newExerciseViewModel(_ exercise: Exercise) -> ExerciseViewModel {
        return ExerciseViewModel(exercise)
    }
    
    func newHolderSessionViewModel<Input: VMCaptureDevice>(with exercise: Exercise)
        -> SessionViewModelImpl<Input, HolderResultViewModel> {
        let holderResultProvider = holderViewModel(withReference: exercise)
        return newSessionViewModel(with: exercise, resultProvider: holderResultProvider)
    }
    
    func newRepeaterSessionViewModel<Input: VMCaptureDevice>(with exercise: Exercise)
        -> SessionViewModelImpl<Input, RepeaterResultViewModel> {
        let repeaterResultProvider = repeaterViewModel(withReference: exercise)
        return newSessionViewModel(with: exercise, resultProvider: repeaterResultProvider)
    }
    
    func newSessionViewModel<Input: VMCaptureDevice, ResultProviderType: ResultViewModel>(with exercise: Exercise,
                                                                  resultProvider: ResultProviderType) -> SessionViewModelImpl<Input, ResultProviderType> {
        let comparator = ComparisonViewModel(reference: exercise, confidenceThreshold: minKeypointConfidence)
        
        let matchFunc = {
            [unowned self] deviation in
            return scoreProvider.compute(deviation)
        }
        
        comparator.scoreFunc = matchFunc

        comparator.scoreThreshold = 0.5
        
        let observer: VMCaptureDeviceObserver<Input> = newDeviceObserver()
        
        return SessionViewModelImpl(deviceObserver: observer,
                                    comparator: comparator,
                                    resultProvider: resultProvider)
    }
    
    func holderStatsViewModel(forExercise exercise: Exercise) -> ExerciseStatsViewModel<HolderSessionResult> {
        return ExerciseStatsViewModel<HolderSessionResult>(exercise, objectContext: mainDataStore)
    }
    
    func repeaterStatsViewModel(forExercise exercise: Exercise) -> ExerciseStatsViewModel<RepeaterSessionResult> {
        return ExerciseStatsViewModel<RepeaterSessionResult>(exercise, objectContext: mainDataStore)
    }

    func holderViewModel(withReference reference: Exercise) -> HolderResultViewModel {
        return HolderResultViewModel(reference: reference,
                                     objectContext: mainDataStore, matchThreshold: matchThreshold, matchScoreFunc: {
            [unowned self] deviation in
            return scoreProvider.compute(deviation)
        })
    }
    
    func repeaterViewModel(withReference reference: Exercise) -> RepeaterResultViewModel {
        let extractor = newMotionExtractor()
        return RepeaterResultViewModel(reference: reference,
                                       motionExtractor: extractor,
                                       objectContext: mainDataStore) {
            [unowned self] pose1, pose2 in
            let deviation = pose1.deviation(from: pose2)
            return scoreProvider.compute(deviation)
        }
    }
    
    var userViewModel = UserViewModel()
    
    func export(motion: Motion, namePrefix: String) -> URL? {
        let json = MotionSerialization.json(withMotion: motion)
        guard
            let data = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .withoutEscapingSlashes])
        else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH_mm"
        let dateString = formatter.string(from: Date())
        let fileName = "\(namePrefix)_\(dateString).json"
        
        let fileManager = FileManager.default
        let fileURL = fileManager.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
        } catch {
            return nil
        }
        
        return fileURL
    }
    
    init() {
        let storedValue = UserDefaults.standard.integer(forKey: YogaAppViewModel.modelTypeKey)
        modelType = KeypointDetectorModelType(rawValue: storedValue) ?? .modelII
    }
}
