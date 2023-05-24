//
//  MainView.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 06.10.2021.
//

import SwiftUI
import PoseSDK

struct SessionCaptureView<ViewModel: SessionViewModel>: View where ViewModel.InputDevice == VMCameraView {
    @ObservedObject var viewModel: ViewModel
    
    @State var isFullScreen: Bool = true
    typealias CloseAction = () -> Void
    var close: CloseAction?
    
    typealias Completion = (ViewModel) -> Void
    var onComplete: Completion?
    
    @State var navBarHidden: Bool = true
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var suggestionView: some View {
        VideoGuideView(viewModel: viewModel.guideVM)
            
            .onAppear {
                viewModel.guideVM.player.play()
            }
    }
    
    var poseView: some View {
        let frameSource = VMCameraView.shared
        return ZStack {
            UIViewWrapper(frameSource)
                .onAppear {
                    frameSource.startCapture()
                    viewModel.startSession(with: frameSource)
                }

            ComparisonView(viewModel: viewModel.comparator)
        }
    }
    
    var scoreButton: some View {
        Text("Score")
            .underline()
            .onTapGesture {
                viewModel.completeSession()
                onComplete?(viewModel)
            }
    }
    
    var cancelButton: some View {
        Text("Cancel")
            .underline()
            .onTapGesture {
                close?()
            }
    }
    
    var landscapeStatusBar: some View {
        return HStack(alignment: .center) {
            Spacer()
            cancelButton
            Spacer()
            scoreButton
            Spacer()
        }
    }
    
    var portraitStatusBar: some View {
        return VStack(alignment: .center) {
            Spacer()
            cancelButton
            Spacer()
            scoreButton
            Spacer()
        }
    }
    
    var topView: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    close?()
                }) {
                    ZStack {
                        Circle()
                            .fill(
                                Color.white.opacity(0.4)
                            )
                            .frame(width: 40, height: 40)
                        
                            Image(systemName: "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                                .foregroundColor(Color.HexToColor(hexString: Constant.FontColor.gray))
                                
                        
                        
                    }
                }
                .padding(.leading, 20)
                .padding(.top, 20)
                Spacer()
            }
            Spacer()
        }
    }
    
    var splitInactiveButton: some View {
        Button(action: {
            isFullScreen = false
        }) {
            ZStack {
                Circle()
                    .fill(
                        Color.clear
                    )
                    .frame(width: 40, height: 40)
                if let splitScreen = UIImage(named: "split_screen_inactive") {
                    Image(uiImage: splitScreen)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minHeight: 24, maxHeight: 24)
                        
                }
            }
            
        }
    }
    
    var splitActiveButton: some View {
        Button(action: {
            isFullScreen = false
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
                if let splitScreen = UIImage(named: "split_screen_active") {
                    Image(uiImage: splitScreen)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minHeight: 24, maxHeight: 24)
                        
                }
            }
            
        }
    }
    
    var fullInactiveButton: some View {
        Button(action: {
            isFullScreen = true
        }) {
            ZStack {
                Circle()
                    .fill(
                        Color.clear
                    )
                    .frame(width: 40, height: 40)
                if let splitScreen = UIImage(named: "fullscreen_inactive") {
                    Image(uiImage: splitScreen)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minHeight: 24, maxHeight: 24)
                        
                }
            }
            
        }
    }
    
    var fullActiveButton: some View {
        Button(action: {
            isFullScreen = true
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
                if let splitScreen = UIImage(named: "fullscreen_active") {
                    Image(uiImage: splitScreen)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minHeight: 24, maxHeight: 24)
                        
                }
            }
            
        }
    }
    
    var callButton: some View {
        Button(action: {
            viewModel.completeSession()
            onComplete?(viewModel)
        }) {
            if let call = UIImage(named: "calls") {
                Image(uiImage: call)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minHeight: 60, maxHeight: 60)
                    
            }
        }
    }
    
    
        
    var body: some View {
        GeometryReader {
            geometry in
            if UIDevice.current.orientation.isLandscape {
                ZStack {
                    HStack(alignment: .center, spacing: 0) {
                        if !isFullScreen {
                            suggestionView.frame(maxWidth: .infinity, alignment: .bottom)
                            
                            Rectangle()
                                .fill(Color.black)
                                .frame(minWidth: 20, maxWidth: 20)
                        }
                        
                        poseView.frame(maxWidth: .infinity, alignment: .bottom)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    topView
                    
                    VStack {
                        Spacer()
                        ZStack {
                            
                            HStack {
                                Spacer()
                                HStack {
                                    if isFullScreen {
                                        splitInactiveButton
                                        fullActiveButton
                                    } else {
                                        splitActiveButton
                                        fullInactiveButton
                                    }
                                }
                                .background(Color.white.opacity(0.4))
                                .cornerRadius(20)
                            }.padding(.trailing, 20)
                            
                            callButton
                            
                            
                            
                        }.padding(.bottom, 20)
                    }
                }
                .background(LinearGradient(gradient: Gradient(colors:
                                                                    [
                                                                        Color.HexToColor(hexString: Constant.Color.instructionImageGradientStartColor).opacity(Constant.Color.instructionImageGradientStartAlpah),
                                                                        Color.HexToColor(hexString: Constant.Color.instructionImageGradientEndColor).opacity(Constant.Color.instructionImageGradientEndAlpah)
                                                                    ]), startPoint: .bottom, endPoint: .top))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                ZStack {
                    VStack(alignment: .center, spacing: 0) {
                        if !isFullScreen {
                            suggestionView.frame(maxWidth: .infinity, alignment: .bottom)
                            
                            Rectangle()
                                .fill(Color.black)
                                .frame(minHeight: 20, maxHeight: 20)
                        }
                        
                        poseView.frame(maxWidth: .infinity, alignment: .bottom)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    topView
                    
                    
                    VStack {
                        Spacer()
                        ZStack {
                            
                            HStack {
                                Spacer()
                                HStack {
                                    if isFullScreen {
                                        splitInactiveButton
                                        fullActiveButton
                                    } else {
                                        splitActiveButton
                                        fullInactiveButton
                                    }
                                }
                                .background(Color.white.opacity(0.4))
                                .cornerRadius(20)
                            }.padding(.trailing, 20)
                            
                            callButton
                            
                            
                        }.padding(.bottom, 20)
                    }
                }
                .background(LinearGradient(gradient: Gradient(colors:
                                                                    [
                                                                        Color.HexToColor(hexString: Constant.Color.instructionImageGradientStartColor).opacity(Constant.Color.instructionImageGradientStartAlpah),
                                                                        Color.HexToColor(hexString: Constant.Color.instructionImageGradientEndColor).opacity(Constant.Color.instructionImageGradientEndAlpah)
                                                                    ]), startPoint: .bottom, endPoint: .top))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
                
        }
    }
    
    func withCompletion(_ completion: @escaping Completion) -> Self {
        var clone = self
        clone.onComplete = completion
        return clone
    }
    
    func withCloseAction(_ action: @escaping CloseAction) -> Self {
        var clone = self
        clone.close = action
        return clone
    }
}
