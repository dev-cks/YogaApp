//
//  VMVideoRecording.swift
//  PoseSDK
//
//  Created by Sergii Kutnii on 14.01.2022.
//

import Foundation
import AVFoundation

class VMVideoRecording {
    private var writer: AVAssetWriter
    private var videoInput: AVAssetWriterInput
    private var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor
    private var timeScale: CMTimeScale
    
    public var location: URL {
        return writer.outputURL
    }
    
    public let startTime = Date()
    
    public var currentMediaTime: CMTime {
        let diffSeconds = Date().timeIntervalSince(startTime)
        return CMTime(seconds: diffSeconds, preferredTimescale: timeScale)
    }
    
    init(location: URL, type: AVFileType, timeScale: CMTimeScale) throws {
        writer = try AVAssetWriter(outputURL: location, fileType: type)
        self.timeScale = timeScale
        
        writer.movieTimeScale = timeScale

        let preset = AVOutputSettingsPreset.preset1920x1080
        let assistant = AVOutputSettingsAssistant(preset: preset)
        videoInput =  AVAssetWriterInput(mediaType: .video, outputSettings: assistant?.videoSettings)
        videoInput.expectsMediaDataInRealTime = true
        
        pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoInput, sourcePixelBufferAttributes: nil)
        
        writer.add(videoInput)
        
        writer.startWriting()
        writer.startSession(atSourceTime: .zero)
    }
    
    func append(_ buffer: CMSampleBuffer) {
        guard
            let imageBuffer = CMSampleBufferGetImageBuffer(buffer)
        else {
            return
        }
        
        
        pixelBufferAdaptor.append(imageBuffer, withPresentationTime: currentMediaTime)
    }
    
    func finish(completion: @escaping () -> Void) {
        writer.endSession(atSourceTime: currentMediaTime)
        writer.finishWriting(completionHandler: completion)
    }
    
    deinit {
        if writer.status == .writing {
            writer.cancelWriting()
        }
    }
}
