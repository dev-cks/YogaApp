//
//  ExercisePreview.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 20.10.2021.
//

import Foundation
import UIKit
import AVFoundation

func previewImage(for videoName: String, offset: TimeInterval) -> UIImage? {
    let videoNameComps = videoName.split(separator: ".")
    guard
        videoNameComps.count == 2,
        let vidURL =
            Bundle.main.url(forResource: String(videoNameComps[0]), withExtension: String(videoNameComps[1]))
    else {
        return nil
    }
    
    let asset = AVURLAsset(url: vidURL)
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true

    let timestamp = CMTimeMakeWithSeconds(offset, preferredTimescale: 600)

    do {
        let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
       return UIImage(cgImage: imageRef)
    }
    catch let error as NSError
    {
        print("Image generation failed with error \(error)")
        return nil
    }
}

func previewImage(for exercise: Exercise) -> UIImage? {
    return previewImage(for: exercise.video, offset: exercise.previewOffset)
}
