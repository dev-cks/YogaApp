//
//  ContentView.swift
//  VideoParser
//
//  Created by Sergii Kutnii on 25.10.2021.
//

import SwiftUI

struct ParserView: View {
    @ObservedObject var viewModel: ParserViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.isRunning ? "Generating JSON" : "Done")
            
            if viewModel.isRunning  {
                ProgressView()
            } else {
                EmptyView()
            }
        }
        .onAppear {
            viewModel.run()
        }
    }
}
