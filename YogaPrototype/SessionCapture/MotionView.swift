//
//  MotionView.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 03.12.2021.
//

import SwiftUI
import PoseSDK

struct MotionView: View {
    var motion: Motion
    var caption: String
        
    var export: MotionExportAction?

    init(motion: Motion, caption: String) {
        self.motion = motion
        self.caption = caption
    }
    
    var poseCellSize = CGSize(width: 120, height: 120)
    var pointRadius = CGFloat(5.0)
    var inset = CGFloat(7.0)

    func poseTransform(_ pose: VMPose) -> CGAffineTransform? {
        guard
            let bounds = pose.keypointsBoundingBox,
            bounds.size.width > 0,
            bounds.size.height > 0
        else {
            return nil
        }
        
        let width = poseCellSize.width - 2 * inset
        let height = poseCellSize.height - 2 * inset
        let translation = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: -bounds.origin.x, ty: -bounds.origin.y)
        let scaleFactor = min(width / bounds.size.width, height / bounds.size.height)
        let tx = inset + 0.5 * (width - scaleFactor * bounds.size.width)
        let ty = inset + 0.5 * (height -  scaleFactor * bounds.size.height)
        let aspectFit = CGAffineTransform(a: scaleFactor, b: 0.0, c: 0.0, d: scaleFactor, tx: tx, ty: ty)
        return translation.concatenating(aspectFit)
    }
    
    func withExportAction(_ action: @escaping MotionExportAction) -> MotionView {
        var clone = self
        clone.export = action
        return clone
    }
    
    var yellowColor: CGColor {
        return CGColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
    }
    
    var greenColor: CGColor {
        return CGColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
    }
    
    var redColor: CGColor {
        return CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
    func pointColor(_ bodyPart: VMBodyPart) -> CGColor {
        switch(bodyPart) {
        case .leftHip, .leftAnkle, .leftKnee:
            return redColor
        case .rightHip, .rightKnee, .rightAnkle:
            return greenColor
        default:
            return yellowColor
        }
    }
    
    func boneColor(_ bodyPart1: VMBodyPart, _ bodyPart2: VMBodyPart) -> CGColor {
        let leftLegParts: [VMBodyPart] = [.leftHip, .leftAnkle, .leftKnee]
        let rightLegParts: [VMBodyPart] = [.rightHip, .rightKnee, .rightAnkle]
        
        if (leftLegParts.contains(bodyPart1) && leftLegParts.contains(bodyPart2)) {
            return redColor
        }
                                                 
        if (rightLegParts.contains(bodyPart1) && rightLegParts.contains(bodyPart2)) {
            return greenColor
        }

        return yellowColor
    }

    var body: some View {
        
        
        ScrollView([.horizontal], showsIndicators: true) {
            HStack {
                ForEach(0..<motion.frames.count, id: \.self) {
                    frameIndex in
                    let pose = motion.frames[frameIndex].pose
                    if let transform = poseTransform(pose) {
                        VStack {
                            PoseView(pose: pose)
                                .withTransform(transform)
                                .withPointRadius(pointRadius)
                                .withPointColor({
                                    bodyPart in
                                    return pointColor(bodyPart)
                                })
                                .wuthBoneColor({
                                    part1, part2 in
                                    return boneColor(part1, part2)
                                })
                                .frame(width: poseCellSize.width, height: poseCellSize.height)
                        }
                        .frame(width: 140, height:  140)
                        .padding(10)
                        .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
                        .cornerRadius(20)
                            
                            
                    }
                }
            }
            
        }
        .padding(.bottom, 20)
        
        HStack {
            Button(action: {
                export?(motion)
            }) {
                HStack(alignment: .center, spacing: 8) {
                    Text("EXPORT")
                        .font(.system(size: 14).bold())
                        .foregroundColor(Color.white)
                    
                    if let union = UIImage(named: "Union") {
                        Image(uiImage: union)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                    }
                
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
                .cornerRadius(12)
            }
            
            Spacer()
            
        }.frame(maxWidth: .infinity)

    }
}

