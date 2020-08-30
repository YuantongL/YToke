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
    
    let permissionInformationViewModel: AudioPermissionInformationViewModel
    
    private let mixer: AudioMixer
    private let micStreamer: MicStreamer
    private let alertManager: PopUpAlertManager
    private let privacyPermissionRepository: PrivacyPermissionRepository
    
    var toggleState: Bool = true {
        didSet {
            onToggleStateChange?(toggleState)
        }
    }
    var onToggleStateChange: ((Bool) -> Void)?
    
    var videoVolume: Float = 100
    var onVideoVolumeChange: ((Float) -> Void)?
    
    var voiceVolume: Float = 50
    var onVoiceVolumeChange: ((Float) -> Void)?
    
    init(dependencyContainer: DependencyContainer) {
        mixer = dependencyContainer.audioMixer
        micStreamer = dependencyContainer.micStreamer
        alertManager = dependencyContainer.repo.alertManager
        toggleState = micStreamer.isEnabled
        let systemNavigator = dependencyContainer.repo.systemNavigator
        permissionInformationViewModel = StandardAudioPermissionInfoViewModel(systemNavigator: systemNavigator)
        privacyPermissionRepository = dependencyContainer.repo.privacyPermissionRepository
    }
    
    func onAppear() {
        if let updatedVideoVolume = mixer.value(of: .video) {
            onVideoVolumeChange?(updatedVideoVolume)
        }
        if let updatedVoiceVolume = mixer.value(of: .voice) {
            onVoiceVolumeChange?(updatedVoiceVolume)
        }
        toggleState = micStreamer.isEnabled && privacyPermissionRepository.status(of: .audio) == .granted
    }
    
    func setVideoVolume(to value: Float) {
        mixer.setChanel(.video, value: value / 100.0)
    }
    
    func setVoiceVolume(to value: Float) {
        mixer.setChanel(.voice, value: value / 100.0)
    }
    
    func setToggleState(state isMicEnabled: Bool) {
        if isMicEnabled {
            micStreamer.startStreaming { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.toggleState = false
                    switch error {
                    case AVAudioEngineMicStreamerError.permissionNotGranted:
                        let message = NSLocalizedString("permission_request_microphone",
                                                        // swiftlint:disable:next line_length
                                                        comment: "If you are willing to use Microphone, please head to System Settings and grant YToke~ microphone permission")
                        self?.alertManager.show(message: message)
                    default:
                        self?.alertManager.show(error: error)
                    }
                case .success:
                    self?.toggleState = true
                }
            }
        } else {
            micStreamer.stopStreaming()
        }
    }
}
