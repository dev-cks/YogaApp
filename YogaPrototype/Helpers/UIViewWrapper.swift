//
//  UIViewWrapper.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 20.09.2021.
//

import SwiftUI

struct UIViewWrapper<WrappedView: UIView> : UIViewRepresentable {
    
    let wrappedView: WrappedView
    
    init(_ wrappedView: WrappedView) {
        self.wrappedView = wrappedView
    }
    
    func makeUIView(context: Self.Context) -> WrappedView {
        return wrappedView
    }

    func updateUIView(_ uiView: WrappedView, context: Self.Context) {
        
    }

}
