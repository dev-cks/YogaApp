//
//  FrameStore.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 06.01.2022.
//

import Foundation
import CoreMedia
import UIKit
import PoseSDK

class FrameStore {
    struct Descriptor {
        var time: CMTime
        var location: URL
    }
        
    private var folder: URL
    
    private(set) var frames = [Descriptor]()
    
    init() throws {
        let fileManager = FileManager.default
        folder = try fileManager.url(for: .itemReplacementDirectory,
                                        in: .userDomainMask, appropriateFor: fileManager.temporaryDirectory, create: true)
    }
    
    func append(frame: VMRawFrame) {
        guard
            let image = frame.content.cgImage
        else {
            return
        }
        
        let time = frame.timestamp
        let name = "\(time.value)_\(time.timescale).png"
        let uiImage = UIImage(cgImage: image)
        let location = folder.appendingPathComponent(name)
        let data = uiImage.pngData()
        
        guard
            (try? data?.write(to: location)) != nil
        else {
            return
        }
        
        let descriptor = Descriptor(time: time, location: location)
        frames.append(descriptor)
    }
    
    func clear() {
        let fileManager = FileManager.default
        for descriptor in frames {
            try? fileManager.removeItem(at: descriptor.location)
        }
        
        frames = []
    }
    
    func frame(at index: Int) -> CGImage? {
        guard
            index >= 0,
            index < frames.count,
            let data = try? NSData(contentsOf: frames[index].location) as Data,
            let uiImage = UIImage(data: data)
        else {
            return nil
        }
        
        return uiImage.cgImage
    }
            
}
