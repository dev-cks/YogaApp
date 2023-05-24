//
//  VideoView.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 07.10.2021.
//

import SwiftUI
import AVKit

struct VideoGuideView: View {
    var viewModel: VideoGuideViewModel
    
    var body: some View {
        PlayerView(player: viewModel.player)
    }
}

