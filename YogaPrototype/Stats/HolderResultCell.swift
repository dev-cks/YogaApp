//
//  SessionCell.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 14.10.2021.
//

import SwiftUI

struct HolderResultCell: ResultCell {
    var content: HolderSessionResult
        
    init(_ content: HolderSessionResult) {
        self.content = content
    }
    
    var dateText: String {
        return HolderResultCell.dateFormatter.string(from: content.timestamp)
    }
    
    var durationText: String {
        return String(format: "%.2f", content.duration.seconds)
    }
    
    var body: some View {
        HStack {
            Text(dateText)
            Spacer()
                .frame(maxWidth: 100)
            Text("Duration: \(durationText)")
        }
        .frame(minHeight: 50)
    }
}

