//
//  YogaPrototypeApp.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 20.09.2021.
//

import SwiftUI
import PoseSDK

@main
struct YogaPrototypeApp: App {
    init() {
        //VMCameraView.shared.mirrored = true
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var router: YogaRouter = {
        var appVM = YogaAppViewModel()            
        if !appVM.samplesLoaded {
            appVM.loadSampleData()
            appVM.samplesLoaded = true
        }
        
        return YogaRouter(viewModel: appVM)
    } ()
    
    
    var body: some Scene {
        WindowGroup {
            router.mainView
        }
    }
}
