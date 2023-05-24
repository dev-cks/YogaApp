//
//  ComparisonView.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 14.10.2021.
//

import SwiftUI
import PoseSDK

struct ComparisonView: View {
    @ObservedObject var viewModel: ComparisonViewModel
    
    func sceneTransform(for geometry: GeometryProxy) -> CGAffineTransform? {
        guard
            let sceneSize = viewModel.sceneSize,
            sceneSize.width > 0,
            sceneSize.height > 0
        else {
            return nil
        }
        
        let scale = min(geometry.size.width / CGFloat(sceneSize.width),
                        geometry.size.height / CGFloat(sceneSize.height))
        
        let xOffset = 0.5 * (geometry.size.width - scale * CGFloat(sceneSize.width))
        let yOffset = 0.5 * (geometry.size.height - scale * CGFloat(sceneSize.height))
        
        let sceneToView = CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: xOffset, ty: yOffset)
        return sceneToView
    }
    
    func refTransform(for geometry: GeometryProxy) -> CGAffineTransform? {
        guard
            let poseMapping = viewModel.poseMapping,
            let sceneMapping = sceneTransform(for: geometry)
        else {
            return nil
        }
        
        return poseMapping.concatenating(sceneMapping)
    }
    
    var lineStyle: StrokeStyle {
        var style = StrokeStyle()
        style.lineWidth = 3.0
        return style
    }
    
    var poseColor: CGColor {
        guard
            viewModel.comparison.actual != nil,
            viewModel.comparison.reference != nil
        else {
            return CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }

        return  viewModel.matchSucceeds ?
            CGColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0) :
            CGColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
    }
    
    var suggestionColor: CGColor {
        return CGColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    }
    
    var body: some View {
        GeometryReader {
            geometry in
            
            ZStack {
                if  let refTransform = refTransform(for: geometry),
                    let reference = viewModel.comparison.reference {
                    PoseView(pose: reference)
                        .withLineStyle(lineStyle)
                        .withTransform(refTransform)
                        .withPointRadius(7.0)
                        .withPointColor {
                            _ in
                            return suggestionColor
                        }
                        .wuthBoneColor {
                            _, _ in
                            return suggestionColor
                        }
                } else {
                    EmptyView()
                }

                if let pose = viewModel.comparison.actual,
                   let userTransform = sceneTransform(for: geometry) {
                    PoseView(pose: pose)
                        .withLineStyle(lineStyle)
                        .withTransform(userTransform)
                        .withPointRadius(7.0)
                        .withPointColor {
                            _ in
                            return poseColor
                        }
                        .wuthBoneColor {
                            _, _ in
                            return poseColor
                        }

                } else {
                    EmptyView()
                }
            }
        }
    }
}
