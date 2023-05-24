//
//  SplashView.swift
//  YogaPrototype
//
//  Created by Ameya on 2022/4/1.
//

import SwiftUI

struct SplashView: View {
    
    typealias LoadAction = () -> Void
    
    var load: LoadAction?
    @State var isLoaded: Bool = false
    @State var textAlpha = 0.0
    var animationDuration: Double = 2.0
    var delayAnimationDuration: Double = 1.0
    var finalDuration: Double = 1.0
    @State var navBarHidden: Bool = false
    
    
    var body: some View {
        
        VStack {
            Spacer()
            
            HStack(alignment: .center, spacing: 0){
                Spacer()
                
                Text("VividMotion.")
                    .font(Font.largeTitle.bold())
                    .opacity(textAlpha)
                    .foregroundColor(Color.white)
                    .background(Color.red.opacity(0))
                    
                
                Text("AI")
                    .font(Font.largeTitle.bold())
                    .opacity(textAlpha)
                    .foregroundColor(Color.yellow)
                    .background(Color.red.opacity(0))
                Spacer()
                    
            }
            
            .onAppear {
                self.navBarHidden = true
                let deadline: DispatchTime = .now() + animationDuration + delayAnimationDuration + finalDuration
                withAnimation(Animation.easeIn(duration: animationDuration).delay(delayAnimationDuration)) {
                    self.textAlpha = 1.0
                    
                }
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    self.load?()
                }
                
            }
            
            Spacer()
        }
        .background(Color.HexToColor(hexString: Constant.Color.mainBackGround))
        
    }
}
    
