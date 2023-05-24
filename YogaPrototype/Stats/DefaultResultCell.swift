//
//  DefaultResultCell.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 11.12.2021.
//

import SwiftUI

struct DefaultResultCell: ResultCell {
    var content: DefaultSessionResult
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    } ()
    
    init(_ content: DefaultSessionResult) {
        self.content = content
    }
    
    var dateText: String {
        return HolderResultCell.dateFormatter.string(from: content.timestamp)
    }
    
    var scoreText: String {
        return String(format: "%.2f", content.score)
    }
    
    var body: some View {
        HStack {
            Text(dateText)
            Spacer()
                .frame(maxWidth: 100)
            Text("Score: \(scoreText)")
        }
        .frame(minHeight: 50)
    }
}
