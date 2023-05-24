//
//  HolderView.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 03.12.2021.
//

import SwiftUI

struct HolderResultView: View {
    var viewModel: HolderResultViewModel
    
    typealias CloseAction = () -> Void
    var close: CloseAction?
    
    var viewStats: StatsAction? = nil
    
    var exportMotion: MotionExportAction?

    var timeString: String {
        return String(format: "%.2f S",
                      viewModel.duration.seconds)
    }
    
    var scoreString: String {
        return String(format: "%.2f", viewModel.score)
    }
    
    var topView: some View {
        ZStack(alignment: .leading) {
            VStack {
                Text("RESULTS")
                    .font(.system(size: 14).bold())
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
            }
            Button(action: {
                close?()
            }) {
                ZStack {
                    Circle()
                        .fill(
                            Color.HexToColor(hexString: Constant.Color.poseBackGround)
                        )
                        .frame(width: 28, height: 28)
                    
                        Image(systemName: "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)
                            
                    
                    
                }
            }
            .padding(.leading, 16)
            .padding(.top, 14)
            .padding(.bottom, 14)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    var scoreView: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let score = UIImage(named: "score") {
                Image(uiImage: score)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    
            }
            Text("VIVID SCORE")
                .font(.system(size: 14).bold())
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(scoreString)
                .font(.system(size: 32).bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .gradientForeground(colors: [
                    Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                    Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                ], startPoint: .top, endPoint: .bottom)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
        .cornerRadius(20)
    }
    
    var durationView: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let score = UIImage(named: "repeat") {
                Image(uiImage: score)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    
            }
            Text("DURATIONS")
                .font(.system(size: 14).bold())
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(timeString)
                .font(.system(size: 32).bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .gradientForeground(colors: [
                    Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                    Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                ], startPoint: .top, endPoint: .bottom)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
        .cornerRadius(20)
    }
    
    
    
    var footerView: some View {
        ZStack {
            ZStack {
                Button(action: {
                    viewStats?()
                }) {
                    Text("OVERALL PROGRESS")
                        .font(.system(size: 14).bold())
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                .background(LinearGradient(gradient: Gradient(colors:
                                                                [
                                                                    Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                                                                    Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                                                                ]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(12)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            
        }
        .frame(maxWidth: .infinity)
        .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .padding(.bottom, 0)
    }
    
    var posesCaption: String {
        let frameCount = viewModel.motion?.frames.count ?? 0
        return "Captured \(frameCount) poses:"
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                
                topView
                VStack {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top, spacing: 8) {
                            scoreView
                            durationView
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 32)
                        
                        
                        HStack {
                            Text("PROCESSED POSES:")
                                .font(.system(size: 20).bold())
                                .foregroundColor(Color.white)
                            
                            Text(String(viewModel.motion?.frames.count ?? 0))
                                .font(.system(size: 20).bold())
                                .foregroundColor(Color.HexToColor(hexString: Constant.FontColor.gray))
                            
                            Spacer()
                        }
                        .padding(.bottom, 20)
                        
                        if let motion = viewModel.motion {
                            MotionView(motion: motion, caption: posesCaption)
                                .withExportAction {
                                    motionValue in
                                    exportMotion?(motionValue)
                                }
                            
                            Spacer()
                        }
                    }
                    .padding(20)
                    
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            footerView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors:
                                                        [
                                                            Color.HexToColor(hexString: Constant.Color.instructionContentGradientStartColor),
                                                            Color.HexToColor(hexString: Constant.Color.instructionContentGradientEndColor)
                                                        ]), startPoint: .top, endPoint: .bottom))
    }
    
    func withCloseAction(_ action: @escaping CloseAction) -> Self {
        var clone = self
        clone.close = action
        return clone
    }
}
