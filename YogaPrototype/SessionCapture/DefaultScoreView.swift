//
//  ScoreView.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 20.10.2021.
//

import SwiftUI
import PoseSDK

typealias StatsAction = () -> Void

struct DefaultScoreView<ViewModel: SessionViewModel>: View {
    var viewModel: ViewModel
    
    var viewStats: StatsAction?
    
    var scoreString: String {
        return String(format: "Your score: %.2f", viewModel.resultProvider.score)
    }
    
    var body: some View {
        VStack {
            Text(scoreString)
                .font(Font.scoreFont)
                .lineLimit(2)
            
            if let motion = viewModel.comparator.detectedMotion {
                MotionView(motion: motion, caption: "Captured poses:")
            }
            
            Button("Stats") {
                viewStats?()
            }
        }
    }
}
