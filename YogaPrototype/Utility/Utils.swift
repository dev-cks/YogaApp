//
//  Utils.swift
//  YogaPrototype
//
//  Created by Ameya on 2022/4/8.
//

import Foundation

class Utils: NSObject {
    class func isToday(_ date: Date) -> Bool {
        return Calendar.current.isDateInToday(date)
    }
    
    class func isYesterday(_ date: Date) -> Bool {
        return Calendar.current.isDateInYesterday(date)
    }
    
    class func isCurWeek(_ date: Date) -> Bool {
        let today = Date()
        let startDay = today.startOfWeek
        let nextStartDay = today.nextStartOfWeek
        if(date >= startDay) {
            if(date < nextStartDay) {
                return true
            }
        }
        return false
    }
    
    class func isPreviousWeek(_ date: Date) -> Bool {
        let today = Date()
        let startDay = today.startOfWeek
        let prevStartDay = today.prevStartOfWeek
        if(date >= prevStartDay) {
            if(date < startDay) {
                return true
            }
        }
        return false
    }
    
    class func isCurMonth(_ date: Date) -> Bool {
        let today = Date()
        let startDay = today.startOfMonth
        let nextStartDay = today.nextStartOfMonth
        if(date >= startDay) {
            if(date < nextStartDay) {
                return true
            }
        }
        return false
    }
    
    class func isPrevMonth(_ date: Date) -> Bool {
        let today = Date()
        let startDay = today.startOfWeek
        let prevStartDay = today.prevStartOfMonth
        if(date >= prevStartDay) {
            if(date < startDay) {
                return true
            }
        }
        return false
    }
    
    class func getDifference(_ first: Date, _ second: Date) -> Double {
        
        let difference = first.timeIntervalSinceReferenceDate - second.timeIntervalSinceReferenceDate
        print("\(first) : \(second) : \(difference)")
        return difference
    }
    
    class func getDayInfo(_ date: Date) -> (day: String, week: String) {
        var tuple: (day: String, week: String)
        var day: String = ""
        var week: String = ""
        let weekDays = [
               "S",
               "M",
               "T",
               "W",
               "T",
               "F",
               "S"
           ]

           
           
        let myCalendar = Calendar.current
        let weekDay = myCalendar.component(.weekday, from: date)
        week = weekDays[weekDay - 1]
        
        let dayDetail = myCalendar.component(.day, from: date)
        day = String(dayDetail)
        tuple = (day: day,week: week)
        return tuple
    }
    
    class func getMonthInfo(_ date: Date) -> String {
        let myCalendar = Calendar.current
        let monthList = [
               "JANUARY",
               "FEBRUARY",
               "MARCH",
               "APRIL",
               "MAY",
               "JUNE",
               "JULY",
               "AUGUST",
               "SEPTEMBER",
               "OCTOBER",
               "NOVEMBER",
               "DECEMBER"
           ]
        let monthInfo = myCalendar.component(.month, from: date)
        let yearInfo = myCalendar.component(.year, from: date)
        return monthList[monthInfo - 1] + " " + String(yearInfo)
    }
}
