//
//  InstructionStepView.swift
//  YogaPrototype
//
//  Created by Ameya on 2022/4/3.
//

import Foundation
import SwiftUI

struct InstructionStepView: View {
    var stepViewModel: InstructionStepViewModel
    init(stepViewModel: InstructionStepViewModel) {
        self.stepViewModel = stepViewModel
    }
    
    var stepNumberView: some View {
        VStack {
            ZStack {
                Circle()
                    
                    .fill(
                        LinearGradient(gradient: Gradient(colors:
                                                            [
                                                                Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart).opacity(0.1),
                                                                Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd).opacity(0.1)
                                                            ]), startPoint: .top, endPoint: .bottom)
                    )
                    
                Circle().strokeBorder(
                    LinearGradient(gradient: Gradient(colors:
                                                        [
                                                            Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                                                            Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                                                        ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
                Text(String(stepViewModel.step))
                    .font(.system(size: 14).bold())
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(1.0, contentMode: .fit)
            VLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(minWidth: 1, maxWidth: 1, maxHeight: .infinity)
                .foregroundColor(Color.white.opacity(0.2))
        }.frame(minWidth: 28, maxWidth: 28, maxHeight: .infinity)
    }
    
    var titleView: some View {
        Text(stepViewModel.title)
            .font(.system(size: 14).bold())
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var descriptionView: some View {
        Text(stepViewModel.description)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 14))
            .foregroundColor(Color.HexToColor(hexString: Constant.FontColor.gray))
            .padding(.top, 6)
            .padding(.bottom, 12)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 18) {
            stepNumberView
            VStack {
                
                titleView
                descriptionView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
