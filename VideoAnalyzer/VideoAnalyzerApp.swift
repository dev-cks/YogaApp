//
//  VideoAnalyzerApp.swift
//  VideoAnalyzer
//
//  Created by Sergii Kutnii on 04.11.2021.
//

import SwiftUI

@main
struct VideoAnalyzerApp: App {
    let viewModel = VideoAnalyzerViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    viewModel.run()
                }
        }
    }
}
