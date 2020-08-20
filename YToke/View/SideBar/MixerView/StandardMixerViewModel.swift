//
//  StandardMixerViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/7/28.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

final class StandardMixerViewModel: MixerViewModel {
    
    private let mixer: AudioMixer
    private let micStreamer: MicStreamer
    
    let toggleState: Bool
    var videoVolume: Float = 100
    var onVideoVolumeChange: ((Float) -> Void)?
    
    var voiceVolume: Float = 50
    var onVoiceVolumeChange: ((Float) -> Void)?
    
    init(dependencyContainer: DependencyContainer) {
        mixer = dependencyContainer.audioMixer
        micStreamer = dependencyContainer.micStreamer
        toggleState = micStreamer.isEnabled
    }
    
    func onAppear() {
        if let updatedVideoVolume = mixer.value(of: .video) {
            onVideoVolumeChange?(updatedVideoVolume)
        }
        if let updatedVoiceVolume = mixer.value(of: .voice) {
            onVoiceVolumeChange?(updatedVoiceVolume)
        }
    }
    
    func setVideoVolume(to value: Float) {
        mixer.setChanel(.video, value: value / 100.0)
    }
    
    func setVoiceVolume(to value: Float) {
        mixer.setChanel(.voice, value: value / 100.0)
    }
    
    func setToggleState(state isMicEnabled: Bool) {
        if isMicEnabled {
            micStreamer.startStreaming()
        } else {
            micStreamer.stopStreaming()
        }
    }
}
