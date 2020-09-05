//
//  StandardMainViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/8/10.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AppKit
import Foundation

final class StandardMainViewModel: MainViewModel {
    
    var videoListViewModel: VideoListViewModel {
        StandardVideoListViewModel(dependencyContainer: dependencyContainer,
                                   onPresentDonationView: { [weak self] in
                                    self?.onPresentDonationView?(StandardDonationViewModel())
        })
    }
    
    var nowPlayingViewModel: NowPlayingViewModel {
        StandardNowPlayingViewModel(dependencyContainer: dependencyContainer,
                                    windowManager: StandardWindowManager.defaultManager)
    }
    
    let dependencyContainer: DependencyContainer
    var onPresentDonationView: ((DonationViewModel) -> Void)?
    
    private var audioMixerToken: Int?
    private lazy var audioMixer: AudioMixer = {
        dependencyContainer.audioMixer
    }()
    
    // TODO: Provider should not appear in viewModel, fix this
    private lazy var microphoneProvider: MicrophoneProvider = {
        dependencyContainer.data.microphoneProvider
    }()
    
    private var songPlayed: Int = 0
    private var firstDonationViewShown = false
    private var secondDonationViewShown = false
    
    private let audioDeviceManager = MacOSAudioDevicesProvider()
    
    init(dependencyContainer: DependencyContainer = StandardDependencyContainer()) {
        self.dependencyContainer = dependencyContainer
        
        audioMixerToken = audioMixer.subscribeChanges { [weak self] audioSettings in
            guard let updatedVoiceVolume = audioSettings[.voice] else {
                return
            }
            
            self?.microphoneProvider.volume = updatedVoiceVolume
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNewSongPlay), name: .queuePop, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAddSong), name: .addSong, object: nil)
    }
    
    deinit {
        guard let token = audioMixerToken else {
            return
        }
        audioMixer.unsubscribe(token: token)
    }
    
    // MARK: - Sponsorship Window
    
    // Show support view when they have singed 10 songs and added a new song after that
    @objc private func onNewSongPlay() {
        songPlayed += 1
    }
    
    @objc private func onAddSong() {
        if !firstDonationViewShown, songPlayed > 10 {
            showFirstDonationView()
            return
        }
        
        if !secondDonationViewShown, songPlayed > 30 {
            showSecondDonationView()
        }
    }
    
    private func showFirstDonationView() {
        firstDonationViewShown = true
        onPresentDonationView?(StandardDonationViewModel())
    }
    
    private func showSecondDonationView() {
        secondDonationViewShown = true
        onPresentDonationView?(StandardDonationViewModel())
    }
}
