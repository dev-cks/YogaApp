//
//  main.swift
//  VideoParser
//
//  Created by Sergii Kutnii on 21.10.2021.
//

import Foundation
import AVFoundation
import PoseSDK

func parse(content: [String]) {
    let options = createModelIIOptions()
    defer {
            VMBodyDetectorOptionsDelete(options)
    }
    
    let detector = VMBodyDetector(options: options)
    let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    for name in content {
        let parts = name.split(separator: ".")
        let fileName = String(parts[0])
        let fileExtension = String(parts[1])
        guard
            let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension)
        else {
            continue
        }
        
        let reader = VideoReader(url: url)
        let offset = CMTime(value: 10, timescale: 600)
        let duration = CMTime(value: 10, timescale: 600)
        let motion = reader.motion(withFrameDuration: duration, startOffset: offset,
                                   detector: detector, confidenceThreshold: 0.0)
                                                                
        let motionJSON = MotionSerialization.json(withMotion: motion)
        let data = try! JSONSerialization.data(withJSONObject: motionJSON, options: [.prettyPrinted])
        
        let outName = fileName + ".json"
        let outURL = docsDir.appendingPathComponent(outName)
                
        try! data.write(to: outURL)
        print("Written data for \(name) to \(outURL)")
    }
}

