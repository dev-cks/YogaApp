//
//  SampleCell.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 13.10.2021.
//

import SwiftUI

struct ExerciseCell: View {
    var viewModel: ExerciseViewModel
    
    var detailAction:(() -> Void)?
    var titleView: some View {
        Text(viewModel.exercise.name)
            .font(.system(size: 18).bold())
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.top, 20)
            .padding(.leading, 20)
    }
    
    var rightCircleView: some View {
        HStack {
            Spacer()
            Circle()
                .fill(
                    
                    LinearGradient(gradient: Gradient(colors:
                                                        [
                                                            Color.white.opacity(Constant.Color.poseCircleGradientStartAlpah),
                                                            Color.black.opacity(Constant.Color.poseCircleGradientEndAlpha)
                                                        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(maxHeight: .infinity, alignment: .topTrailing)
                .aspectRatio(1.0, contentMode: .fit)
                .padding(.trailing, -60)
                .padding(.top, 0)
            
        }
    }
    var arrowRightButton: some View {
        Button(action: {
            detailAction?()
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(gradient: Gradient(colors:
                                                            [
                                                                Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                                                                Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                                                            ]), startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: 40, height: 40)
                if let arrowRight = UIImage(named: "arrow_right") {
                    Image(uiImage: arrowRight)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        
                }
                
            }
        }
        .padding(.leading, 20)
        .padding(.bottom, 20)
    }
    var body: some View {
        ZStack {
            VStack {
                titleView
                Spacer()
            }
            
            rightCircleView
            
            
            if let thumnail = viewModel.exercise.thumnail {
                if let preview = UIImage(named: thumnail) {
                    HStack {
                        Spacer()
                        Image(uiImage: preview)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: .infinity, alignment: .topTrailing)
                            .padding(.trailing, 0)
                            .padding(.top, 0)
                    }
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    arrowRightButton
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

extension ExerciseCell {
    func setDetailEvent(_ detailAction: @escaping () -> Void) -> Self {
        var copy = self
        copy.detailAction = detailAction
        return copy
    }
}
