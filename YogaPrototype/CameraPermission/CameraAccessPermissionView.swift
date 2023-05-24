//
//  File.swift
//  YogaPrototype
//
//  Created by Ameya on 2022/4/6.
//

import Foundation
import SwiftUI

struct CameraAccessPermissionView: View {

    typealias CloseAction = () -> Void
    var close: CloseAction?
    
    var topView: some View {
        ZStack(alignment: .top) {
            VStack {
                HStack {
                    Button(action: {
                        close?()
                    }) {
                        ZStack {
                            Circle()
                                .fill(
                                    Color.white.opacity(0.4)
                                )
                                .frame(width: 28, height: 28)
                            
                                Image(systemName: "xmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(Color.white)
                                    
                            
                            
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.top, 20)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
        }
    }
    
    var settingView: some View {
        Button(action: {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }) {
            Text("GO TO SETTINGS")
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
    
    var titleView: some View {
        Text("Vividmotion\n needs access to\n your  camera")
            .lineLimit(nil)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 24).bold())
            .foregroundColor(Color.white)
            .padding(.bottom, 12)
    }
    
    var descriptionView: some View {
        Text("To continue, you’ll need to allow\n camera access in Settings")
            .lineLimit(nil)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 14))
            .foregroundColor(Color.HexToColor(hexString: Constant.FontColor.gray))
            .padding(.bottom, 28)
    }
    
    var body: some View {
        ZStack {
            
            
            if let backgroundImage = UIImage(named: "ellipses") {
                Image(uiImage: backgroundImage)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
            }
            
            VStack {
                titleView
                
                descriptionView
                
                settingView
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(42)
            
            topView
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
    
    func withCloseAction(_ action: @escaping CloseAction) -> Self {
        var clone = self
        clone.close = action
        return clone
    }
}
