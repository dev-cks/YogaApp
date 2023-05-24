//
//  VideoParserApp.swift
//  VideoParser
//
//  Created by Sergii Kutnii on 25.10.2021.
//

import SwiftUI

@main
struct VideoParserApp: App {
    
    var mainViewModel = ParserViewModel()
    
    var body: some Scene {
        WindowGroup {
            ParserView(viewModel: mainViewModel)
        }
    }
    
}
