//
//  StatsView.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 12.11.2021.
//

import SwiftUI

struct ExerciseStatsView<ResultType: SessionResult, CellType: ResultCell>: View where CellType.ContentType == ResultType {
    var viewModel: ExerciseStatsViewModel<ResultType>?
    var exerciseType: String = "repeat"
    @State var progressType: Int = 0
    @State var stats: [ResultType] = []
    @State var highScore:Float = 0.0
    @State var increaseProgress:Float = 0.0
    
    @State var chartXData: [Double] = []
    @State var chartYData: [Double] = []
    @State var chartXTitle: [String] = []
    @State var chartYTitle: [String] = []
    
    typealias CloseAction = () -> Void
    var close: CloseAction?
    
    @State var selectedMonth: String = ""
    @State var selectedDate: Date = Date().noon
    @State var selectedDateScore: Double = 0
    @State var selectedDateProgress: Double = 0
    @State var preSelectMonth: Date = Date()
    @State var preSelectedDate: Date = Date().noon
    
    @State var isShowCalendar: Bool = false
    init(model: ExerciseStatsViewModel<ResultType>) {
        self.viewModel = model
        print(type(of: model.stats))
        if type(of: model.stats) == type(of: [RepeaterSessionResult]()) {
            exerciseType = "repeat"
        } else {
            exerciseType = "holder"
        }
    }
    
    func getUnit(_ value: Int) -> Int {
        var unit = value
        if unit < 10 {
            unit = 10
        } else if(unit < 25) {
            unit = 25
        } else if(unit < 50) {
            unit = 50
        } else {
            unit = ((unit - 1) / 100 + 1) * 100
        }
        return unit
    }
    
    func setDaily() {
        progressType = 0
        stats = []
        chartXData = []
        chartYData = []
        var curHighest:Float = 0.0
        var curSum:Float = 0.0
        var previousHighest:Float = 0.0
        var previousSum:Float = 0.0
        if var modelStats = self.viewModel?.stats {
            modelStats.sort {
                $0.timestamp < $1.timestamp
            }
            for index in 0..<modelStats.count {
                let result = modelStats[index]
                
                if(Utils.isToday(result.timestamp)) {
                    
                    if(curHighest < result.score) {
                        curHighest = result.score
                    }
                    curSum = curSum + 1
                    stats.append(result)
                    
                } else if(Utils.isYesterday(result.timestamp)) {
                    if(previousHighest < result.score) {
                        previousHighest = result.score
                    }
                    previousSum = previousSum + 1
                }
            }
            
        }
        
        highScore = curHighest
        
        let unit = getUnit(Int(highScore / 4))
        
        let noon = Date().noon
        let totalTime: Double = 24 * 60 * 60
        for i in 0..<stats.count {
            chartXData.append(Utils.getDifference(stats[i].timestamp, noon) / totalTime)
            chartYData.append(Double(stats[i].score / Float(unit * 4)))
        }
        chartYTitle = []
        chartXTitle = []
        chartYTitle.append(contentsOf: [String(unit * 4), String(unit * 3), String(unit * 2), String(unit)])
        chartXTitle.append(contentsOf: ["00", "06", "12", "18"])
        
    }
    
    func setWeekly() {
        progressType = 1
        stats = []
        chartXData = []
        chartYData = []
        var curHighest:Float = 0.0
        var curSum:Float = 0.0
        var previousHighest:Float = 0.0
        var previousSum:Float = 0.0
        if var modelStats = self.viewModel?.stats {
            modelStats.sort {
                $0.timestamp < $1.timestamp
            }
            for index in 0..<modelStats.count {
                let result = modelStats[index]
                
                if(Utils.isCurWeek(result.timestamp)) {
                    
                    if(curHighest < result.score) {
                        curHighest = result.score
                    }
                    curSum = curSum + 1
                    stats.append(result)
                    
                } else if(Utils.isPreviousWeek(result.timestamp)) {
                    if(previousHighest < result.score) {
                        previousHighest = result.score
                    }
                    previousSum = previousSum + 1
                }
            }
            
        }
        
        highScore = curHighest
        
        let unit = getUnit(Int(highScore / 4))
        
        let noon = Date().startOfWeek
        let totalTime: Double = 24 * 60 * 60 * 7
        for i in 0..<stats.count {
            chartXData.append(Utils.getDifference(stats[i].timestamp, noon) / totalTime)
            chartYData.append(Double(stats[i].score / Float(unit * 4)))
        }
        chartYTitle = []
        chartXTitle = []
        chartYTitle.append(contentsOf: [String(unit * 4), String(unit * 3), String(unit * 2), String(unit)])
        chartXTitle.append(contentsOf: ["S", "M", "T", "W", "T", "F", "S"])
    }
    
    func setMonthly() {
        progressType = 2
        stats = []
        chartXData = []
        chartYData = []
        var curHighest:Float = 0.0
        var curSum:Float = 0.0
        var previousHighest:Float = 0.0
        var previousSum:Float = 0.0
        if var modelStats = self.viewModel?.stats {
            modelStats.sort {
                $0.timestamp < $1.timestamp
            }
            for index in 0..<modelStats.count {
                let result = modelStats[index]
                
                if(Utils.isCurMonth(result.timestamp)) {
                    
                    if(curHighest < result.score) {
                        curHighest = result.score
                    }
                    curSum = curSum + 1
                    stats.append(result)
                    
                } else if(Utils.isPrevMonth(result.timestamp)) {
                    if(previousHighest < result.score) {
                        previousHighest = result.score
                    }
                    previousSum = previousSum + 1
                }
            }
            
        }
        
        highScore = curHighest
        
        let unit = getUnit(Int(highScore / 4))
        
        let noon = Date().startOfMonth
        let totalTime: Double = Utils.getDifference(Date().nextStartOfMonth, noon)
        let totalDate: Int = Int(totalTime / Double(60 * 60 * 24))
        for i in 0..<stats.count {
            chartXData.append(Utils.getDifference(stats[i].timestamp, noon) / totalTime)
            chartYData.append(Double(stats[i].score / Float(unit * 4)))
        }
        chartYTitle = []
        chartXTitle = []
        chartYTitle.append(contentsOf: [String(unit * 4), String(unit * 3), String(unit * 2), String(unit)])
        for i in 0..<totalDate {
            if(i % 3 == 0) {
                chartXTitle.append(String(i + 1))
            }
            
        }
    }
    
    func showSelectedDateInfo(_ date: Date) {
        selectedDate = date
        selectedMonth = Utils.getMonthInfo(selectedDate)
        selectedDateScore = 0
        selectedDateProgress = 0
        if var modelStats = self.viewModel?.stats {
            modelStats.sort {
                $0.timestamp < $1.timestamp
            }
            for index in 0..<modelStats.count {
                let result = modelStats[index]
                if(Utils.getDifference(selectedDate, result.timestamp) == 0) {
                    selectedDateScore = selectedDateScore + Double(result.score)
                    if let repeatResult = result as? RepeaterSessionResult {
                        selectedDateProgress = selectedDateProgress + Double(repeatResult.repeatCount)
                    } else if let holderResult = result as? HolderSessionResult {
                        selectedDateProgress = selectedDateProgress + holderResult.duration.seconds
                    }
                }
            }
        }
    }
    
    var topView: some View {
        ZStack(alignment: .leading) {
            VStack {
                Text("OVERALL PROGRESS")
                    .font(.system(size: 14).bold())
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
            }
            Button(action: {
                close?()
            }) {
                ZStack {
                    Circle()
                        .fill(
                            Color.HexToColor(hexString: Constant.Color.poseBackGround)
                        )
                        .frame(width: 28, height: 28)
                    
                        Image(systemName: "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)
                            
                    
                    
                }
            }
            .padding(.leading, 16)
            .padding(.top, 14)
            .padding(.bottom, 14)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    var scoreString: String {
        return String(format: "%.2f", highScore)
    }
    
    var scoreView: some View {
        HStack(alignment: .center){
            VStack(alignment: .leading, spacing: 6) {
                
                Text("HIGHEST SCORE")
                    .font(.system(size: 14).bold())
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(scoreString)
                    .font(.system(size: 32).bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .gradientForeground(colors: [
                        Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                        Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                    ], startPoint: .top, endPoint: .bottom)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            
            if let highest = UIImage(named: "highest") {
                Image(uiImage: highest)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
            }
        }
        .frame(maxWidth: .infinity, minHeight: 108, maxHeight: 108)
        
        .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
        .cornerRadius(20)
    }
    
    var dailyView: some View {
        Button(action: {
            setDaily()
        }) {
            Group {
                if progressType == 0 {
                    ZStack {
                        Text("DAILY")
                            .font(.system(size: 12).bold())
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                    .background(LinearGradient(gradient: Gradient(colors:
                                                                            [
                                                                                Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                                                                                Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                                                                            ]), startPoint: .top, endPoint: .bottom))
                    
                    .cornerRadius(16)
                } else {
                    ZStack {
                        Text("DAILY")
                            .font(.system(size: 12).bold())
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                    .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
                    
                    .cornerRadius(16)
                }
            }
        }
    }
    
    var weeklyView: some View {
        Button(action: {
            setWeekly()
        }) {
            Group {
                if progressType == 1 {
                    ZStack {
                        Text("WEEKLY")
                            .font(.system(size: 12).bold())
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                    .background(LinearGradient(gradient: Gradient(colors:
                                                                            [
                                                                                Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                                                                                Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                                                                            ]), startPoint: .top, endPoint: .bottom))
                    
                    .cornerRadius(16)
                } else {
                    ZStack {
                        Text("WEEKLY")
                            .font(.system(size: 12).bold())
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                    .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
                    
                    .cornerRadius(16)
                }
            }
        }
    }
    
    var monthlyView: some View {
        Button(action: {
            setMonthly()
        }) {
            Group {
                if progressType == 2 {
                    ZStack {
                        Text("MONTHLY")
                            .font(.system(size: 12).bold())
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                    .background(LinearGradient(gradient: Gradient(colors:
                                                                            [
                                                                                Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                                                                                Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                                                                            ]), startPoint: .top, endPoint: .bottom))
                    
                    .cornerRadius(16)
                } else {
                    ZStack {
                        Text("MONTHLY")
                            .font(.system(size: 12).bold())
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                    .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
                    
                    .cornerRadius(16)
                }
            }
        }
    }
    
    
    var progressView: some View {
        HStack(alignment: .center){
            VStack(alignment: .leading, spacing: 6) {
                
                Text("YOUR PROGRESS")
                    .font(.system(size: 14).bold())
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(scoreString)
                    .font(.system(size: 32).bold())
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .gradientForeground(colors: [
                        Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                        Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                    ], startPoint: .top, endPoint: .bottom)
                    
                
                Text("Since yesterday")
                    .font(.system(size: 14))
                    .foregroundColor(Color.HexToColor(hexString: Constant.FontColor.gray))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            
            if let progress = UIImage(named: "progress") {
                Image(uiImage: progress)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
            }
        }
        .frame(maxWidth: .infinity, minHeight: 128, maxHeight: 128)
        
        .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
        .cornerRadius(20)
    }
    
    var chartView: some View {
        VStack {
            HStack {
                LineChartView(chartXData: chartXData, chartYData: chartYData).frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack {
                    ForEach(chartYTitle, id: \.self) {
                        value in
                        Text(String(value))
                            .font(.system(size: 12))
                            .foregroundColor(Color.HexToColor(hexString: Constant.FontColor.gray))
                            .frame(maxHeight: .infinity, alignment: .topTrailing)
                    }
                }.frame(maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                ForEach(chartXTitle, id: \.self) {
                    value in
                    Text(String(value))
                        .font(.system(size: 12))
                        .foregroundColor(Color.HexToColor(hexString: Constant.FontColor.gray))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
        }
        .frame(maxWidth: .infinity, minHeight: 240, maxHeight: 240)
    }
    
    var dailyScoreTitleView: some View {
        HStack {
            Text("DAILY SCORE")
                .font(.system(size: 20).bold())
                .foregroundColor(Color.white)
                
            Spacer()
            
            Button(action: {
                isShowCalendar = true
                
                preSelectedDate = selectedDate
                preSelectMonth = preSelectedDate.startOfMonth
            }) {
                HStack(alignment: .center, spacing: 8) {
                    Text(selectedMonth)
                        .font(.system(size: 14))
                        .foregroundColor(Color.white)
                    
                    Image(systemName: "chevron.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 8, height: 8)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    var dailyListView: some View {
        HStack(alignment: .center) {
            ForEach(self.selectedDate.getWeekDates(), id:\.self) {
                date in
                Button(action: {
                    showSelectedDateInfo(date)
                }) {
                    Group {
                        if(Utils.getDifference(date, self.selectedDate) != 0.0) {
                            VStack(alignment: .center, spacing: 6) {
                                Text(Utils.getDayInfo(date).week)
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.HexToColor(hexString: Constant.FontColor.gray))
                                
                                Text(Utils.getDayInfo(date).day)
                                    .font(.system(size: 16))
                                    .foregroundColor(Color.white)
                            }
                            .padding(.vertical, 16)
                            .frame(minWidth: 45, maxWidth: 45, alignment: .center)
                            
                            .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
                            .cornerRadius(12)
                        } else {
                            VStack(alignment: .center, spacing: 6) {
                                Text(Utils.getDayInfo(date).week)
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.white)
                                
                                Text(Utils.getDayInfo(date).day)
                                    .font(.system(size: 16))
                                    .foregroundColor(Color.white)
                            }
                            .padding(.vertical, 16)
                            .frame(minWidth: 45, maxWidth: 45, alignment: .center)
                            
                            .background(LinearGradient(gradient: Gradient(colors:
                                                                            [
                                                                                Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                                                                                Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                                                                            ]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(12)
                        }
                    }
                }
                
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    var dailyScoreView: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let score = UIImage(named: "score") {
                Image(uiImage: score)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    
            }
            Text("VIVID SCORE")
                .font(.system(size: 14).bold())
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(String(format: "%.2f", selectedDateScore))
                .font(.system(size: 32).bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .gradientForeground(colors: [
                    Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                    Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                ], startPoint: .top, endPoint: .bottom)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
        .cornerRadius(20)
    }
    
    var dailyRepeatView: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let score = UIImage(named: "repeat") {
                Image(uiImage: score)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    
            }
            Group {
                if exerciseType == "repeat" {
                    Text("REPEATS")
                        .font(.system(size: 14).bold())
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(String(format: "%.0f", selectedDateProgress))
                        .font(.system(size: 32).bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .gradientForeground(colors: [
                            Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                            Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                        ], startPoint: .top, endPoint: .bottom)
                } else {
                    Text("DURATION")
                        .font(.system(size: 14).bold())
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(String(format: "%.2f", selectedDateProgress))
                        .font(.system(size: 32).bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .gradientForeground(colors: [
                            Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                            Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                        ], startPoint: .top, endPoint: .bottom)
                }
            }
            
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
        .cornerRadius(20)
    }
    
    var calendarApplyView: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Button(action: {
                    self.isShowCalendar = false
                }) {
                    Text("CANCEL")
                        .font(.system(size: 14).bold())
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                .background(Color.HexToColor(hexString: Constant.Color.darkButtonColor))
                .cornerRadius(12)
            }
            .frame(maxWidth: .infinity)
            
            
            ZStack {
                Button(action: {
                    self.showSelectedDateInfo(self.preSelectedDate)
                    self.isShowCalendar = false
                }) {
                    Text("APPLY")
                        .font(.system(size: 14).bold())
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                .background(LinearGradient(gradient: Gradient(colors:
                                                                [
                                                                    Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                                                                    Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                                                                ]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(12)
            }
            .frame(maxWidth: .infinity)
            
            
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
        .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: -12)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        
    }
    
    var calendarView: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: {
                        preSelectMonth = preSelectMonth.prevStartOfMonth
                    }) {
                        VStack {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 14, height: 14)
                                .foregroundColor(.white)
                        }
                        .padding(4)
                        
                        
                    }
                    Text(Utils.getMonthInfo(preSelectMonth))
                        .font(.system(size: 16).bold())
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        preSelectMonth = preSelectMonth.nextStartOfMonth
                    }) {
                        VStack {
                            Image(systemName: "chevron.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 14, height: 14)
                                .foregroundColor(.white)
                        }
                        .padding(4)
                    }
                }
                DateGrid(selectedMonth: preSelectMonth) { date in
                    Button(action: {
                        preSelectedDate = date
                    }) {
                        ZStack {
                            Group {
                                
                                if(Utils.getDifference(date, preSelectMonth) < 0.0) {
                                    Text(Utils.getDayInfo(date).day)
                                        .font(.system(size: 16))
                                        .foregroundColor(Color.HexToColor(hexString: Constant.FontColor.gray).opacity(0.4))
                                } else if(Utils.getDifference(date, preSelectedDate) == 0.0) {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(gradient: Gradient(colors:
                                                                                                [
                                                                                                    Color.HexToColor(hexString: Constant.Color.poseInnerGradientStart),
                                                                                                    Color.HexToColor(hexString: Constant.Color.poseInnerGradientEnd)
                                                                                                ]), startPoint: .top, endPoint: .bottom)
                                            )
                                        
                                        Text(Utils.getDayInfo(date).day)
                                            .font(.system(size: 16))
                                            .foregroundColor(Color.white)
                                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                                } else {
                                    Text(Utils.getDayInfo(date).day)
                                        .font(.system(size: 16))
                                        .foregroundColor(Color.HexToColor(hexString: Constant.FontColor.gray))
                                }
                            }
                        }
                        .frame(width: 32, height: 32)
                    }
                    
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            
            calendarApplyView
            
        }
        .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
        .cornerRadius(20, corners: [.topLeft, .topRight])
        
    }
    
    
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    topView
                    VStack{
                        scoreView
                        HStack {
                            Text("PROGRESS")
                                .font(.system(size: 20).bold())
                                .foregroundColor(Color.white)
                        
                            Spacer()
                        }
                        .padding(.top, 32)
                        .padding(.bottom, 20)
                        HStack(alignment: .center, spacing: 4) {
                            dailyView
                            weeklyView
                            monthlyView
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 20)
                        
                        progressView
                        VStack {
                            chartView
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                        .padding(.bottom, 20)
                        
                        dailyScoreTitleView
                        
                        VStack {
                            dailyListView
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        
                        HStack(alignment: .top, spacing: 8) {
                            dailyScoreView
                            dailyRepeatView
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 32)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                }
            }
            .background(LinearGradient(gradient: Gradient(colors:
                                                            [
                                                                Color.HexToColor(hexString: Constant.Color.instructionContentGradientStartColor),
                                                                Color.HexToColor(hexString: Constant.Color.instructionContentGradientEndColor)
                                                            ]), startPoint: .top, endPoint: .bottom))
            
            if isShowCalendar {
                VStack {
                    Spacer()
                    calendarView
                }
                .background(Color.black.opacity(0.7))
            }
        }
        
        .onAppear {
            setDaily()
            showSelectedDateInfo(Date().noon)
        }
    }
    
    func withCloseAction(_ action: @escaping CloseAction) -> Self {
        var clone = self
        clone.close = action
        return clone
    }
}
