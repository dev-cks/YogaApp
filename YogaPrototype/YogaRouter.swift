//
//  YogaRouter.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 13.10.2021.
//

import SwiftUI
import PoseSDK

typealias ViewExerciseAction = (ExerciseViewModel) -> Void
typealias CloseAction = () -> Void
typealias SettingsAction = () -> Void
typealias MotionExportAction = (Motion) -> Void

class YogaRouter {
    var appViewModel: YogaAppViewModel
    var isLoadSplash: Bool = false
    
    init(viewModel: YogaAppViewModel) {
        appViewModel = viewModel
    }
    
    lazy var mainView : RoutingView = {
        return RoutingView(rootView: splashView)
//        if appViewModel.userViewModel.userName.isEmpty {
//            return RoutingView(rootView: userView)
//        } else {
//            return RoutingView(rootView: samplesView)
//        }
    } ()
    
    lazy var samplesView: ExerciseListView = {
        [unowned self] in
        var view =
            ExerciseListView(viewModel: appViewModel.samplesViewModel)
                .withItemAction {
                    [unowned self] sample in
                    let exercise = sample.exercise
                    instructionSession(exercise)
                    //startNewSession(exercise)
                }
        
        view.openSettings = {
            [unowned self] in
            self.openSettings()
        }
        
        return view
    } ()

    lazy var userView: UserView = {
        [unowned self] in
        var view = UserView(viewModel: appViewModel.userViewModel)
        view.close = {
            [unowned self] in
            //self.openList()
        }
        
        return view
    } ()
    
    lazy var splashView: SplashView = {
        [unowned self] in
        var view = SplashView()
        view.load = {
            [unowned self] in
            if(!self.isLoadSplash) {
                self.isLoadSplash = true
                self.openList()
            }
            
        }
        
        return view
    } ()
    
    func setOnlyPortrait() {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        AppDelegate.orientationLock = .portrait
    }
    
    func disableOnlyPortrait() {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        AppDelegate.orientationLock = .all
    }
    
    
    func openList() {
        setOnlyPortrait()
        let listVC = UIHostingController(rootView: samplesView)
        mainView.navigator.setViewControllers([listVC], animated: true)
    }
    
    func countDown(_ exercise: Exercise) {
        let view = CountDownView(exercise: exercise)
            .withStartAction {
                [unowned self] in
                self.mainView.popView(animated: false)
                self.disableOnlyPortrait()
                self.startNewSession(exercise)
            }
        
        mainView.push(view, animated: true)
    }
    
    func showCameraAccessPermission() {
        let view = CameraAccessPermissionView().withCloseAction {
            self.mainView.popView(animated: false)
        }
        mainView.push(view, animated: true)
    }
    
    func instructionSession(_ exercise: Exercise) {
        
        let view = InstructionView(exercise: exercise)
            .withCloseAction {
                [unowned self] in
                self.mainView.popView(animated: true)
            }
            .withStartAction {
                [unowned self] in
                self.countDown(exercise)
            }
            .withPermissionAction {
                self.showCameraAccessPermission()
            }
        
        mainView.push(view, animated: true)
    }
    
    func showSessionView<ViewModel: SessionViewModel>(_ view: SessionCaptureView<ViewModel>) {
        mainView.push(view.withCloseAction {
            [unowned self] in
            self.setOnlyPortrait()
            self.mainView.popView(animated: true)
        },
        animated: true)
    }
    
    func startNewSession(_ exercise: Exercise) {
        switch(exercise.type) {
        case .holder:
            let holderSessionVM: SessionViewModelImpl<VMCameraView, HolderResultViewModel> =
                appViewModel.newHolderSessionViewModel(with: exercise)
            
            let view = SessionCaptureView(viewModel: holderSessionVM).withCompletion({
                [unowned self] sessionVM in
                completeHolderSession(sessionVM.resultProvider)
            })
            
            showSessionView(view)
        
            
        case .repeater:
            let repeaterSessionVM: SessionViewModelImpl<VMCameraView, RepeaterResultViewModel> = appViewModel.newRepeaterSessionViewModel(with: exercise)
            
            let view = SessionCaptureView(viewModel: repeaterSessionVM).withCompletion({
                [unowned self] sessionVM in
                completeRepeaterSession(sessionVM.resultProvider)
            })
            
            showSessionView(view)
        }
    }
    
    func openSettings() {
        var settingsView = SettingsView(viewModel: appViewModel)
        settingsView.close = {
            [unowned self] in
            self.mainView.navigator.dismiss(animated: true, completion: nil)
        }
        let wrapper = UIHostingController(rootView: settingsView)
        wrapper.modalTransitionStyle = .coverVertical
        mainView.navigator.present(wrapper, animated: true)
    }
    
    func viewHolderStats(forExercise exercise: Exercise) {
        let viewModel = appViewModel.holderStatsViewModel(forExercise: exercise)
        let view = ExerciseStatsView<HolderSessionResult, HolderResultCell>(model: viewModel).withCloseAction {
            self.mainView.popView(animated: true)
        }
        
                                                                                    
        // let wrapper = UIHostingController(rootView: view)
        // let rootVC = mainView.navigator.viewControllers[0]
        mainView.push(view, animated: true)
    }
    
    func viewRepeaterStats(forExercise exercise: Exercise) {
        let viewModel = appViewModel.repeaterStatsViewModel(forExercise: exercise)
        let view = ExerciseStatsView<RepeaterSessionResult, RepeaterResultCell>(model: viewModel).withCloseAction {
            self.mainView.popView(animated: true)
        }
        
        // let wrapper = UIHostingController(rootView: view)
        // let rootVC = mainView.navigator.viewControllers[0]
        mainView.push(view, animated: true)
    }

    func completeHolderSession(_ resultVM: HolderResultViewModel) {
        var resultView = HolderResultView(viewModel: resultVM).withCloseAction {
            self.openList()
        }
        resultView.viewStats = {
            [unowned self, resultVM] in
            viewHolderStats(forExercise: resultVM.reference)
        }
        
        resultView.exportMotion = {
            [unowned self] motion in
            export(motion: motion, reference: resultVM.reference)
        }

        let rootVC = mainView.navigator.viewControllers[0]
        let resultVC = UIHostingController(rootView: resultView)
        mainView.navigator.setViewControllers([rootVC, resultVC], animated: true)
    }
    
    func completeRepeaterSession(_ resultVM: RepeaterResultViewModel) {
        var resultView = RepeaterResultView(viewModel: resultVM).withCloseAction {
            self.openList()
        }
        resultView.viewStats = {
            [unowned self, resultVM] in
            viewRepeaterStats(forExercise: resultVM.reference)
        }
        
        resultView.exportMotion = {
            [unowned self] motion in
            export(motion: motion, reference: resultVM.reference)
        }

        let rootVC = mainView.navigator.viewControllers[0]
        let resultVC = UIHostingController(rootView: resultView)
        mainView.navigator.setViewControllers([rootVC, resultVC], animated: true)
    }
    
    func export(motion: Motion, reference: Exercise) {
        guard
            let file = appViewModel.export(motion: motion, namePrefix: reference.name)
        else {
            return
        }
        
        shareFile(file)
    }
    
    func shareFile(_ url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        guard
            let topView = mainView.navigator.view
        else {
            return
        }

        activityVC.popoverPresentationController?.sourceView = topView
        let topFrame = topView.frame
        activityVC.popoverPresentationController?.sourceRect =
            CGRect(x: topFrame.origin.x + 0.5 * topFrame.width, y: topFrame.origin.y, width: 0, height: 0)
        mainView.navigator.present(activityVC, animated: true, completion: nil)
    }
}

