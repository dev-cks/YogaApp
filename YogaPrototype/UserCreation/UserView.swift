//
//  UserView.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 18.10.2021.
//

import SwiftUI

struct UserView: View {
    @ObservedObject var viewModel: UserViewModel
    
    typealias CloseAction = () -> Void
    
    var close: CloseAction?
    
    var body: some View {
        VStack {
            HStack {
                Text("Your name: ")
                TextField("...", text: $viewModel.userName)
                    .frame(minWidth: 100)
            }
            
            Button("Close") {
                close?()
            }
            .disabled(viewModel.userName.isEmpty)
        }
    }
}

