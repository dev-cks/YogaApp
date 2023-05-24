//
//  File.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 11.12.2021.
//

import SwiftUI

protocol ResultCell: View {
    associatedtype ContentType
    
    init(_ content: ContentType)
    
    static var dateFormatter: DateFormatter { get }
}

extension ResultCell {

    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }

}
