//
//  InstructionStepView.swift
//  YogaPrototype
//
//  Created by Ameya on 2022/4/3.
//

import Foundation
import SwiftUI
import AVFoundation
import PoseSDK

struct InstructionView: View {
    var stepModelList: [InstructionStepViewModel] = []
    var exercise: Exercise
    typealias CloseAction = () -> Void
    var close: CloseAction?
    
    typealias StartAction = () -> Void
    var start: StartAction?
    
    typealias PermissionAction = () -> Void
    var permission: PermissionAction?
    
    @State var isReady: Bool = false
    
    init(exercise: Exercise) {
        self.exercise = exercise
        
        
        let step1 = InstructionStepViewModel(step: 1, title: "Get into plank position".uppercased(), description: "Get into a plank position, making sure to distribute your weight evenly between your hands and your toes.")
        let step2 = InstructionStepViewModel(step: 2, title: "Check your form".uppercased(), description: "Your hands should be about shoulder-width apart, back flat, abs engaged, and head in alignment")
        let step3 = InstructionStepViewModel(step: 3, title: "pull your right  knee".uppercased(), description: "Pull your right knee into your chest as far as you can.")
         let step4 = InstructionStepViewModel(step: 4, title: "Switch legs".uppercased(), description: "Switch legs, pulling one knee out and bringing the other knee in.")
        let step5 = InstructionStepViewModel(step: 5, title: "repeat as fast as you can".uppercased(), description: "Keep your hips down and run your knees in and out as far and as fast as you can. Alternate inhaling and exhaling with each leg change.")
        
        self.stepModelList.append(step1)
        self.stepModelList.append(step2)
        self.stepModelList.append(step3)
        self.stepModelList.append(step4)
        self.stepModelList.append(step5)
    }
    
    var thumbnailView: some View {
        Group {
            if let thumnail = exercise.thumnail {
                if let preview = UIImage(named: thumnail) {
                    ZStack {
                        
                        Image(uiImage: preview)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .padding(0)
                                .background(LinearGradient(gradient: Gradient(colors:
                                                                                            [
                                                                                                Color.HexToColor(hexString: Constant.Color.instructionImageGradientStartColor).opacity(Constant.Color.instructionImageGradientStartAlpah),
                                                                                                Color.HexToColor(hexString: Constant.Color.instructionImageGradientEndColor).opacity(Constant.Color.instructionImageGradientEndAlpah)
                                                                                            ]), startPoint: .bottom, endPoint: .top))
                        
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    var topView: some View {
        ZStack(alignment: .leading) {
            VStack {
                Text("INSTRUCTIONS")
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
                            Color.white.opacity(0.3)
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
    
    var titleView: some View {
        Text(exercise.name.replacingOccurrences(of: "\n", with: " "))
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .font(.system(size: 24).bold())
            .foregroundColor(Color.white)
            .padding(.top, 8)
    }
    
    var descriptionView: some View {
        Text("It's a running plank performed by bringing the knees up toward the chest, one at a time, in rapid succession, for a short burst of one minute.")
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 14))
            .foregroundColor(Color.HexToColor(hexString: Constant.FontColor.gray))
            .padding(.top, 12)
            .padding(.bottom, 24)
    }
    
    var overallView: some View {
        ZStack(alignment: .trailing) {
            VStack {
                Text("VIEW OVERALL STATISTICS")
                    .font(.system(size: 14).bold())
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, alignment: .center)

            }
            Button(action: {
                
            }) {
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)
            }
            .padding(.trailing, 16)
            
            
        }
        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
        .background(Color.HexToColor(hexString: Constant.Color.instructionOverallColor))
        .cornerRadius(12)
    }
    
    var footerView: some View {
        ZStack {
            ZStack {
                Button(action: {
                    self.isReady = true
                }) {
                    Text("START WORKOUT")
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
    
    var instructionTitleView: some View {
        Text("INSTRUCTIONS")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 20).bold())
            .foregroundColor(Color.white)
            .padding(.top, 28)
            .padding(.bottom, 20)
    }
    
    var nextView: some View {
        ZStack {
            ZStack {
                Button(action: {
                    self.checkCameraPermission()
                }) {
                    Text("GOT IT")
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
        .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: -12)
    }
    
    var readyIconView: some View {
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
            
            if let mobile = UIImage(named: "mobile") {
                Image(uiImage: mobile)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minHeight: 24, maxHeight: 24)
                    
            }
        }
        .frame(minWidth: 48, maxWidth: 48, minHeight: 48, maxHeight: 48)
    }
    
    var readyTitleView: some View {
        Text("GET READY\n FOR EXERCISE")
            .lineLimit(nil)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 24).bold())
            .foregroundColor(Color.white)
            .padding(.top, 20)
            .padding(.bottom, 12)
    }
    
    var readyDescriptionView: some View {
        Text("Place your phone in vertical position\nand move away to let your camera\nsee you in full-view")
            .lineLimit(nil)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 14))
            .foregroundColor(Color.HexToColor(hexString: Constant.FontColor.gray))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                ZStack(alignment: .top){
                    thumbnailView
                    topView
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, -40)
                
                ZStack {
                    VStack {
                        titleView
                        descriptionView
                        overallView
                        instructionTitleView
                        
                        ForEach(stepModelList, id: \.step) {
                            stepModel in
                            InstructionStepView(stepViewModel: stepModel)
                                .frame(maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .padding(.top, 4)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                }
                .frame(maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .padding(.top, 0)
                .padding(.bottom, 100)
                .background(LinearGradient(gradient: Gradient(colors:
                                                                [
                                                                    Color.HexToColor(hexString: Constant.Color.instructionContentGradientStartColor),
                                                                    Color.HexToColor(hexString: Constant.Color.instructionContentGradientEndColor)
                                                                ]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
            .frame(maxWidth: .infinity)
            
            footerView
            
            if self.isReady {
                VStack {
                    Spacer()
                    VStack {
                        VStack {
                            readyIconView
                            readyTitleView
                            readyDescriptionView
                        }
                        .frame(maxWidth: .infinity)
                        .padding(24)
                        
                        nextView
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.4))
                .padding(.top, 0)
            }
        }
        

    }
    
    func withCloseAction(_ action: @escaping CloseAction) -> Self {
        var clone = self
        clone.close = action
        return clone
    }
    
    func withStartAction(_ action: @escaping StartAction) -> Self {
        var clone = self
        clone.start = action
        return clone
    }
    
    func withPermissionAction(_ action: @escaping PermissionAction) -> Self {
        var clone = self
        clone.permission = action
        return clone
    }
    
    func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            if accessGranted {
                DispatchQueue.main.async {
                    VMCameraView.shared.mirrored = true
                    self.isReady = false
                    self.start?()
                }
            } else {
                DispatchQueue.main.async {
                    self.permission?()
                }
                
            }
            
        })
    }
}
