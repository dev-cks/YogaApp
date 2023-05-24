//
//  VideoAnalyzerViewModel.swift
//  VideoAnalyzer
//
//  Created by Sergii Kutnii on 04.11.2021.
//

import Foundation
import PoseSDK
import AVFoundation
import QuartzCore
import UIKit

class VideoAnalyzerViewModel {
    
    var yellowColor: CGColor {
        return CGColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
    }
    
    var greenColor: CGColor {
        return CGColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
    }
    
    var redColor: CGColor {
        return CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
    func pointColor(_ bodyPart: VMBodyPart) -> CGColor {
        switch(bodyPart) {
        case .leftHip, .leftAnkle, .leftKnee:
            return redColor
        case .rightHip, .rightKnee, .rightAnkle:
            return greenColor
        default:
            return yellowColor
        }
    }
    
    func boneColor(_ bodyPart1: VMBodyPart, _ bodyPart2: VMBodyPart) -> CGColor {
        let leftLegParts: [VMBodyPart] = [.leftHip, .leftAnkle, .leftKnee]
        let rightLegParts: [VMBodyPart] = [.rightHip, .rightKnee, .rightAnkle]
        
        if (leftLegParts.contains(bodyPart1) && leftLegParts.contains(bodyPart2)) {
            return redColor
        }
                                                 
        if (rightLegParts.contains(bodyPart1) && rightLegParts.contains(bodyPart2)) {
            return greenColor
        }

        return yellowColor
    }
    
    func run() {
        let options = createModelIIOptions()
        defer {
            VMBodyDetectorOptionsDelete(options)
        }
        
        let detector = VMBodyDetector(options: options)
        let contentURL = Bundle.main.url(forResource: "ideal_squat", withExtension: "mp4")!
        let reader = VideoReader(url: contentURL)
        
        let offset = CMTime(value: 10, timescale: 600)
        let frameDuration = CMTime(value: 10, timescale: 600)

        var currentTime = offset
        var timestamps = [CMTime]()
        while  (CMTimeCompare(currentTime, reader.asset.duration) == -1) {
            timestamps.append(currentTime)
            currentTime = CMTimeAdd(currentTime, frameDuration)
        }
        
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        for timestamp in timestamps {
            guard
                let image = try? reader.frame(at: timestamp)
            else {
                continue
            }
            
            let scene = detector.detectBody(in: image, at: .zero)
            guard
                let pose = VMPose(scene: scene, minKeypointConfidence: 0.0)
            else {
                continue
            }
                   
            guard
                let overlayedImage = render(pose: pose, on: image)
            else {
                continue
            }
            
            let uiImage = UIImage(cgImage: overlayedImage)
            
            guard
                let png = uiImage.pngData()
            else {
                continue
            }
            
            let outName = "\(timestamp.value)_\(timestamp.timescale).png"
            let outURL = docsURL.appendingPathComponent(outName)
            try! png.write(to: outURL)
            print("Written to \(outURL)")
        }
        
        func render(pose: VMPose, on background: CGImage) -> CGImage? {
            let width = background.width
            let height = background.height

            let data = NSMutableData(length: width * height * 4)!
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: UnsafeMutableRawPointer(mutating: data.bytes),
                                    width: width,
                                    height: height,
                                    bitsPerComponent: 8,
                                    bytesPerRow: width * 4,
                                    space: colorSpace,
                                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
            
            let vertFlip = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: -1.0, tx: 0.0, ty: CGFloat(height))
            
            let bounds = CGRect(x: 0, y: 0, width: width, height: height)
            context?.draw(background, in: bounds)
            
            context?.setLineWidth(6.0)
            for (j1, j2) in VMPose.skeleton {
                guard
                    let kp1 = pose.keypoints[j1],
                    let kp2 = pose.keypoints[j2]
                else {
                    continue
                }
                
                let color = boneColor(j1, j2)
                context?.setStrokeColor(color)

                let locations = [kp1.location.applying(vertFlip), kp2.location.applying(vertFlip)]
                context?.strokeLineSegments(between: locations)
            }
            
            for (part, point) in pose.keypoints {
                let location = point.location.applying(vertFlip)
                let bounds = CGRect(x: location.x - 15.0, y: location.y - 15.0, width: 30.0, height: 30.0)
                let color = pointColor(part)
                context?.setFillColor(color)
                context?.fillEllipse(in: bounds)
            }

            return context?.makeImage()
        }

    }
    
}
