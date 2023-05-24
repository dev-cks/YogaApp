//
//  InstructionStepViewModel.swift
//  YogaPrototype
//
//  Created by Ameya on 2022/4/3.
//

import Foundation

class InstructionStepViewModel {
    var step: Int
    var title: String
    var description: String
    
    init(step: Int, title: String, description: String) {
        self.step = step
        self.title = title
        self.description = description
    }
}
