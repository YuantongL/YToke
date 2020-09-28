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
    var onPresentDualChoiceView: ((DualChoiceViewModel<VideoTag>) -> Void)?
    
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
    private lazy var videoStatsRepository: VideoStatsRepository = {
        dependencyContainer.repo.videoStatsRepository
    }()
    
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onSongPlayProgressHalf),
                                               name: .songPlayProgressHalf,
                                               object: nil)
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
    
    @objc private func onSongPlayProgressHalf(notification: Notification) {
        guard let videoId = (notification.userInfo as? [String: String])?["id"],
              let videoName = (notification.userInfo as? [String: String])?["name"] else {
            return
        }
        let viewModel = DualChoiceViewModel(question: NSLocalizedString("has_vocal_question",
                                            comment: "Does the current video has singer's vocal?"),
                                            subtitle: videoName,
                                            titleA: NSLocalizedString("yes", comment: "Yes"),
                                            contentA: VideoTag.withVocal,
                                            titleB: NSLocalizedString("no", comment: "No"),
                                            contentB: VideoTag.offVocal,
                                            onSelect: { [weak self] selectedTag in
                                                self?.videoStatsRepository.reportTag(videoId: videoId, tag: selectedTag)
                                            })
        onPresentDualChoiceView?(viewModel)
    }
}
