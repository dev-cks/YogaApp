//
//  SessionResult.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 11.12.2021.
//

import Foundation

protocol SessionResult: Serializable {
    var timestamp: Date { get }
    var score: Float { get }
}
