//
//  StoredResult.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 11.12.2021.
//

import Foundation

protocol Serializable {
    init?(json: [String: Any])
    var json: [String: Any] { get }
}
