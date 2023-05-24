//
//  PoseView.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 14.10.2021.
//

import SwiftUI
import PoseSDK

struct PoseView: UIViewRepresentable {
    var pose: VMPose
//    var color: CGColor
    var transform = CGAffineTransform.identity
    var lineStyle = StrokeStyle()
    var pointRadius = 0.0
    
    var pointColor: (VMBodyPart) -> CGColor = {
        _ in
        return UIColor.clear.cgColor
    }
    
    var boneColor: (VMBodyPart, VMBodyPart) -> CGColor = {
        _, _ in
        return UIColor.clear.cgColor
    }
    
    init(pose: VMPose) {
        self.pose = pose
    }
    
    func withLineStyle(_ style: StrokeStyle) -> PoseView {
        var clone = self
        clone.lineStyle = style
        return clone
    }
    
    func withPointRadius(_ radius: CGFloat) -> PoseView {
        var clone = self
        clone.pointRadius = radius
        return clone
    }
    
    func withTransform(_ transform: CGAffineTransform) -> PoseView {
        var clone = self
        clone.transform = transform
        return clone
    }
    
    func withPointColor(_ colorProvider: @escaping (VMBodyPart) -> CGColor) -> PoseView {
        var clone = self
        clone.pointColor = colorProvider
        return clone
    }
    
    func wuthBoneColor(_ colorProvider: @escaping (VMBodyPart, VMBodyPart) -> CGColor) -> PoseView {
        var clone = self
        clone.boneColor = colorProvider
        return clone
    }
    
    func makeUIView(context: Context) -> Painter {
        return Painter(frame: .zero) {
            ctx, rect in
            draw(inContext: ctx, rect: rect)
        }
    }
    
    func updateUIView(_ uiView: Painter, context: Context) {
        uiView.body = {
            ctx, rect in
            draw(inContext: ctx, rect: rect)
        }
        
        uiView.setNeedsDisplay()
    }
    
    func draw(inContext ctx: CGContext, rect: CGRect) {
        ctx.clear(rect)
           
        ctx.setLineWidth(lineStyle.lineWidth)
        ctx.setLineCap(lineStyle.lineCap)
        ctx.setLineJoin(lineStyle.lineJoin)
        ctx.setMiterLimit(lineStyle.miterLimit)
        ctx.setLineDash(phase: lineStyle.dashPhase, lengths: lineStyle.dash)
        
        for (joint1, joint2) in VMPose.skeleton {
            guard
                let point1 = pose.keypoints[joint1]?.location.applying(transform),
                let point2 = pose.keypoints[joint2]?.location.applying(transform)
            else {
                continue
            }
            
            let color = boneColor(joint1, joint2)
            ctx.setStrokeColor(color)

            ctx.beginPath()
            ctx.move(to: point1)
            ctx.addLine(to: point2)
            ctx.strokePath()
        }

        for (bodyPart, point) in pose.keypoints {
            let center = point.location.applying(transform)
            let bounds = CGRect(x: center.x - pointRadius, y: center.y - pointRadius, width: 2 * pointRadius, height: 2 * pointRadius)

            let color = pointColor(bodyPart)
            ctx.setFillColor(color)
            ctx.fillEllipse(in: bounds)
        }
        
    }
}
