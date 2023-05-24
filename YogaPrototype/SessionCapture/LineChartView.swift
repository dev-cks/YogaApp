//
//  LineChartView.swift
//  YogaPrototype
//
//  Created by Ameya on 2022/4/11.
//

import Foundation
import SwiftUI

struct LineShape: Shape {
    var xValues: [Double]
    var yValues: [Double]
    

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0.0,
                              y: Double(rect.height)))
        for i in 0..<yValues.count {
            let pt = CGPoint(x: xValues[i] * Double(rect.width),
                             y: (1.0 - yValues[i]) * Double(rect.height))
            path.addLine(to: pt)
        }
        
        return path
    }
}

struct LineChartView: View {
    var chartXData: [Double]
    var chartYData: [Double]
    
    
    var body: some View {
        ZStack {
            LineShape(xValues: chartXData, yValues: chartYData)
                .fill(LinearGradient(gradient: Gradient(colors:
                                                                [
                                                                    Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                                                                    Color.HexToColor(hexString: Constant.Color.poseBackGround)
                                                                ]), startPoint: .top, endPoint: .bottom))
            LineShape(xValues: chartXData, yValues: chartYData)
                .stroke(LinearGradient(gradient: Gradient(colors:
                                                            [
                                                                Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                                                                Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                                                            ]), startPoint: .top, endPoint: .bottom), lineWidth: 2.0)
                
        }
    }
    
}
