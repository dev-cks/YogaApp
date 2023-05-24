//
//  DayCell.swift
//  YogaPrototype
//
//  Created by Ameya on 2022/4/12.
//

import Foundation

import SwiftUI

public struct DayCell: View {
    public init(date: Date) {
        self.date = date
    }
    
    private var date: Date
    public var body: some View {
        Text(date.day)
            .padding(8)
            .background(Color.blue)
            .cornerRadius(8)
            .padding([.bottom], 10)
    }
}
