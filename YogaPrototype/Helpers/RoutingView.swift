//
//  Routing.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 13.10.2021.
//

import Foundation
import UIKit
import SwiftUI

struct RoutingView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController
    
    var navigator = UINavigationController()

    func makeUIViewController(context: Context) -> UINavigationController {
        return navigator
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
    
    func push<Content: View>(_ content: Content, animated: Bool) {
        let wrapper = UIHostingController(rootView: content)
        navigator.pushViewController(wrapper, animated: true)
        
    }

    func popView(animated: Bool) {
        navigator.popViewController(animated: animated)
    }

    
    init<RootView: View>(rootView: RootView) {
        let wrapper = UIHostingController(rootView: rootView)
        navigator.navigationBar.isHidden = true
        
        navigator.viewControllers = [wrapper]
    }
}

