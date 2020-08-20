//
//  StandardVideoViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/7/22.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import os.log

final class StandardVideoViewModel: VideoViewModel {
    
    var isLoadingSpinnerHidden: ((Bool) -> Void)?
    private var currentPlayingSongName: String?
    var cycleText: String? {
        guard let first = currentPlayingSongName,
            let second = videoQueue.queue.first?.title else {
            return nil
        }
        let format = NSLocalizedString("cycle_text_title", comment: "Current playing: %@,       next: %@")
        return String(format: format, first, second)
    }
    var volume: ((Float) -> Void)?
    var streamURL: ((URL) -> Void)?
    
    private var isPlaying = false
    private let videoQueue: VideoQueue
    
    private let mixer: AudioMixer
    private var mixerToken: AudioMixer.Token = 0
    
    private let videoStreamingRepository: VideoStreamingRepository
    
    init(dependencyContainer: DependencyContainer) {
        self.videoQueue = dependencyContainer.videoQueue
        self.videoStreamingRepository = dependencyContainer.repo.videoStreamingRepository
        self.mixer = dependencyContainer.audioMixer
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onSongAdded),
                                               name: .addSong,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onVideoFinished),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onSkipVideo),
                                               name: .skipSong,
                                               object: nil)
        
        mixerToken = mixer.subscribeChanges(onChange: { [weak self] audioSettings in
            guard let videoVolume = audioSettings[.video] else {
                return
            }
            self?.volume?(videoVolume)
        })
    }
    
    deinit {
        mixer.unsubscribe(token: mixerToken)
        NotificationCenter.default.removeObserver(self)
    }
    
    func onAppear() {
        prepareAndPlayVideo()
    }
    
    @objc private func onSongAdded() {
        if !isPlaying {
            prepareAndPlayVideo()
        }
    }
    
    @objc private func onVideoFinished() {
        isPlaying = false
        currentPlayingSongName = nil
        prepareAndPlayVideo()
    }
    
    @objc private func onSkipVideo() {
        isPlaying = false
        currentPlayingSongName = nil
        prepareAndPlayVideo()
    }
    
    private func prepareAndPlayVideo() {
        guard let nextVideo = videoQueue.next() else {
            return
        }
        isPlaying = true
        isLoadingSpinnerHidden?(false)
        videoStreamingRepository.fetchStreamURL(id: nextVideo.id) { [weak self] result in
            switch result {
            case .success(let streamURL):
                self?.playVideo(video: nextVideo, url: streamURL)
            case .failure(let error):
                os_log("Error fetching streamingURL with error %s", error.localizedDescription)
            }
        }
    }
    
    private func playVideo(video: Video, url: URL) {
        currentPlayingSongName = video.title
        streamURL?(url)
        isLoadingSpinnerHidden?(true)
    }
}
