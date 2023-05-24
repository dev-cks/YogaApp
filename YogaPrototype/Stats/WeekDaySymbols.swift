//
//  WeekDaySymbols.swift
//  YogaPrototype
//
//  Created by Ameya on 2022/4/12.
//

import SwiftUI

public struct WeekDaySymbols: View {
    
    public init() {}
    
    public var body: some View {
        HStack {
            ForEach(Calendar.current.veryShortWeekdaySymbols, id: \.self) { item in
                Spacer()
                Text(item)
                    .font(.system(size: 16))
                    .foregroundColor(Color.white)
                    
                Spacer()
                
            }
        }
    }
}
