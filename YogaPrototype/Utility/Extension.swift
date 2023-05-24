//
//  Extension.swift
//  YogaPrototype
//
//  Created by Ameya on 2022/4/1.
//

import Foundation
import SwiftUI
import AVFoundation
import AVKit

extension Color{
    static func HexToColor(hexString: String) -> Color {
        // Convert hex string to an integer
        var hexInt: UInt64 = 0
        let scanner: Scanner = Scanner(string: hexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt64(&hexInt)
        
        let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0
        
        // Create color object, specifying alpha as well
        let color = Color(UIColor(red: red, green: green, blue: blue, alpha: 1.0))
        return color
    }

}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct VLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
    }
}

struct HLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        }
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.all //By default you want all your views to rotate freely

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

extension View {
    public func gradientForeground(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) -> some View {
        self.overlay(
            
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint)
        )
            .mask(self)
    }
}

struct PlayerView: UIViewRepresentable {
    
    var player: AVQueuePlayer
    
    func makeUIView(context: Context) -> PlayerUIView {
        return PlayerUIView(player: player)
    }
    
    func updateUIView(_ uiView: PlayerUIView, context: UIViewRepresentableContext<PlayerView>) {
        uiView.playerViewController.player = player
    }
}

class PlayerUIView: UIView {
    
    // MARK: Class Property
    
    let playerViewController = AVPlayerViewController()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(player: AVQueuePlayer) {
        super.init(frame: .zero)
        self.playerSetup(player: player)
    }
    
    // MARK: Life-Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerViewController.view.frame = bounds
    }
    
    // MARK: Class Methods
    
    private func playerSetup(player: AVPlayer) {
        playerViewController.player = player
        playerViewController.view.backgroundColor = .clear
        self.addSubview(playerViewController.view)
    }
}

extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}

extension Date {

    func getWeekDates() -> [Date] {
        
        var arrThisWeek: [Date] = []
        for i in 0..<7 {
            arrThisWeek.append(Calendar.current.date(byAdding: .day, value: i, to: startOfWeek)!)
        }
        return arrThisWeek
    }

    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }

    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        return gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        
    }
    
    var nextStartOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: 7, to: sunday!)!
    }
    
    var prevStartOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: -7, to: sunday!)!
    }

    func toDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    var nextStartOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1), to: self.startOfMonth)!
    }
    
    var prevStartOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: -1), to: self.startOfMonth)!
    }
    
    public var day: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
    
    public static func getDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        return formatter.date(from: dateString)
    }
}

extension Calendar {
    func generateDates(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates: [Date] = []
        
        dates.append(interval.start)
        
        enumerateDates(startingAfter: interval.start, matching: components, matchingPolicy: .nextTime) { date, _, stop in
            
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                    
                } else {
                    stop = true
                }
            }
        }
        return dates
    }
}

extension DateFormatter {
    
    public static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }
    
    public static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}





