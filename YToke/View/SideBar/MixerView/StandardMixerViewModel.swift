//
//  StandardMixerViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/7/28.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AppKit
import Foundation

final class StandardMixerViewModel: MixerViewModel {
    
    var isPermissionInformationHidden: Bool {
        privacyPermissionRepository.status(of: .audio) == .granted
    }
    
    var isAudioDevicesListHidden: Bool {
        !(privacyPermissionRepository.status(of: .audio) == .granted)
    }
    
    var isMicrophoneVolumeControlHidden: Bool {
        !(privacyPermissionRepository.status(of: .audio) == .granted)
    }
    
    let permissionInformationViewModel: AudioPermissionInformationViewModel
    let audioDevicesListViewModel: AudioDevicesListViewModel
    
    private let mixer: AudioMixer
    private let privacyPermissionRepository: PrivacyPermissionRepository
    
    var videoVolume: Float = 100
    var onVideoVolumeChange: ((Float) -> Void)?
    
    var voiceVolume: Float = 50
    var onVoiceVolumeChange: ((Float) -> Void)?
    
    init(dependencyContainer: DependencyContainer) {
        mixer = dependencyContainer.audioMixer
        let systemNavigator = dependencyContainer.repo.systemNavigator
        permissionInformationViewModel = StandardAudioPermissionInfoViewModel(systemNavigator: systemNavigator)
        privacyPermissionRepository = dependencyContainer.repo.privacyPermissionRepository
        let audioInputRepository = dependencyContainer.repo.audioInputRepository
        audioDevicesListViewModel = StandardAudioDevicesListViewModel(audioInputRepository: audioInputRepository)
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
}
