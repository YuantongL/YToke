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
    private var currentVideo: Video?
    var cycleText: String? {
        guard let first = currentVideo?.title,
            let second = videoQueue.queue.first?.title else {
            return nil
        }
        let format = NSLocalizedString("cycle_text_title",
                                       comment: "Current playing: %@,       next: %@")
        return String(format: format, first, second)
    }
    var volume: ((Float) -> Void)?
    var streamURL: ((URL) -> Void)?
    
    var currentTime: (() -> Double?)?
    var videoDuration: (() -> Double?)?
    
    private var isPlaying = false
    private let videoQueue: VideoQueue
    private var currentVideoId: String?
    
    private let mixer: AudioMixer
    private var mixerToken: AudioMixer.Token = 0
    
    private let videoStreamingRepository: VideoStreamingRepository
    private let videoStatsRepository: VideoStatsRepository
    
    init(dependencyContainer: DependencyContainer) {
        self.videoQueue = dependencyContainer.videoQueue
        self.videoStreamingRepository = dependencyContainer.repo.videoStreamingRepository
        self.mixer = dependencyContainer.audioMixer
        self.videoStatsRepository = dependencyContainer.repo.videoStatsRepository
        
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
    
    func onVideoPlayedHalf() {
        guard let videoId = currentVideo?.id, let videoName = currentVideo?.title else {
            return
        }
        NotificationCenter.default.post(name: .songPlayProgressHalf,
                                        object: self,
                                        userInfo: ["id": videoId, "name": videoName])
    }
    
    @objc private func onSongAdded() {
        if !isPlaying {
            prepareAndPlayVideo()
        }
    }
    
    @objc private func onVideoFinished() {
        reportVideoImpression()
        isPlaying = false
        currentVideo = nil
        prepareAndPlayVideo()
    }
    
    @objc private func onSkipVideo() {
        reportVideoImpression()
        isPlaying = false
        currentVideo = nil
        prepareAndPlayVideo()
    }
    
    private func reportVideoImpression() {
        guard let videoId = currentVideo?.id,
            let duration = videoDuration?(),
            let currentTime = currentTime?(),
            duration > 0 else {
                return
        }
        videoStatsRepository.reportImpression(videoId: videoId, percentage: currentTime / duration)
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
        currentVideo = video
        streamURL?(url)
        isLoadingSpinnerHidden?(true)
    }
}
