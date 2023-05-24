//
//  VideoSuggestionViewModel.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 07.10.2021.
//

import Foundation
import AVFoundation

class VideoGuideViewModel: ObservableObject {
    @Published var player: AVQueuePlayer
    
    private var looper: AVPlayerLooper
    
    init(_ suggestion: URL) {
        let item = AVPlayerItem(url: suggestion)
        let queuePlayer = AVQueuePlayer(items: [item])
        player = queuePlayer
        queuePlayer.isMuted = true
        looper = AVPlayerLooper(player: queuePlayer, templateItem: item)
    }
    
}
