//
//  CountDownView.swift
//  YogaPrototype
//
//  Created by Ameya on 2022/4/5.
//

import Foundation
import SwiftUI

struct CountDownView: View {
    
    var exercise: Exercise
    
    init(exercise: Exercise) {
        self.exercise = exercise
    }
    
    typealias StartAction = () -> Void
    var start: StartAction?
    
    @State var time: Int = 3
    @State var title: String = "READY"
    @State var timeStr: String = "00:03"
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack(alignment: .bottom) {
            if let backgroundImage = UIImage(named: "ellipses") {
                Image(uiImage: backgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
            }
            
            VStack {
                Text(title)
                    .font(.system(size: 44).bold())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .gradientForeground(colors: [
                        Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                        Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                    ], startPoint: .top, endPoint: .bottom)
                
                Text(timeStr)
                    .font(.system(size: 48))
                    .foregroundColor(Color.white.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 0)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(timer) { _ in
                if time >= 0 {
                    time -= 1
                }
                switch time {
                case 2:
                    title = "STEADY"
                    timeStr = "00:02"
                    break
                case 1:
                    title = "GO!"
                    timeStr = "00:01"
                    break
                case 0:
                    timeStr = "00:00"
                    start?()
                    break
                default:
                    break
                }
            }
        }
        .background(Color.black)
    }
    
    func withStartAction(_ action: @escaping StartAction) -> Self {
        var clone = self
        clone.start = action
        return clone
    }
}
