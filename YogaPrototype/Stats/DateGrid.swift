//
//  DateGrid.swift
//  YogaPrototype
//
//  Created by Ameya on 2022/4/12.
//

import Foundation

import SwiftUI

struct DateGrid<DateView>: View where DateView: View {

    //TODO: make Date generator class
    var selectedMonth: Date
    var content: (Date) -> DateView
    
    
    var dateList: [Date] = []
    
    init(selectedMonth: Date, content: @escaping (Date) -> DateView) {
        self.selectedMonth = selectedMonth
        self.content = content
        let startDay = selectedMonth.startOfMonth
        print(startDay)
        let weeks = startDay.getWeekDates()
        self.dateList = []
        self.dateList.append(contentsOf: weeks)
        let nextMonthStartDay = selectedMonth.nextStartOfMonth
        let nextWeekStartDay = selectedMonth.nextStartOfWeek
        for i in 0..<31 {
            let day = Calendar.current.date(byAdding: .day, value: i, to: nextWeekStartDay)!
            if(Utils.getDifference(day, nextMonthStartDay) >= 0) {
                break
            }
            self.dateList.append(day)
        }
    }
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
                ForEach(dateList, id: \.self) { date in
                    content(date)
                        .id(date)
                }
            }
        }
        
        
    }
    
    //MARK: constant and supportive methods
}


