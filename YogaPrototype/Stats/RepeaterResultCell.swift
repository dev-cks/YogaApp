//
//  RepeaterResultCell.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 17.12.2021.
//

import SwiftUI

struct RepeaterResultCell: ResultCell {
    var content: RepeaterSessionResult
    
    init(_ content: RepeaterSessionResult) {
        self.content = content
    }
    
    var dateText: String {
        return RepeaterResultCell.dateFormatter.string(from: content.timestamp)
    }
    
    var countText: String {
        return String(format: "\(content.repeatCount) times")
    }

    var body: some View {
        HStack {
            Text(dateText)
            Spacer()
                .frame(maxWidth: 100)
            Text(countText)
        }
        .frame(minHeight: 50)
    }
}
