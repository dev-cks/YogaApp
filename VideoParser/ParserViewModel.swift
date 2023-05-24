//
//  ParserVM.swift
//  VideoParser
//
//  Created by Sergii Kutnii on 26.10.2021.
//

import Foundation

class ParserViewModel: ObservableObject {
    @Published var isRunning: Bool = false
    
    func run() {
        let content: [String] = ["mountain_climber.mov", "warrior.mov", "ideal_squat.mp4"]
        isRunning = true
        parse(content: content)
        isRunning = false
    }
}
