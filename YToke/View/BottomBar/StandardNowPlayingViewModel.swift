//
//  StandardNowPlayingViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/8/3.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AppKit
import Foundation

final class StandardNowPlayingViewModel: NowPlayingViewModel {
    
    var title: ((String) -> Void)?
    var image: ((URL) -> Void)?
    var isShowVideoButtonHidden: ((Bool) -> Void)?
    var isShowLyricsButtonHidden: ((Bool) -> Void)?
    
    private let dependencyContainer: DependencyContainer
    private var isVideoViewOnScreen = false {
        didSet {
            isShowVideoButtonHidden?(isVideoViewOnScreen)
        }
    }
    private var isLyricsViewOnScreen = false {
        didSet {
            isShowLyricsButtonHidden?(isLyricsViewOnScreen)
        }
    }
    
    private let windowManager: WindowManager
    
    init(dependencyContainer: DependencyContainer, windowManager: WindowManager) {
        self.dependencyContainer = dependencyContainer
        self.windowManager = windowManager
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onSongStartToPlay(notification:)),
                                               name: .queuePop,
                                               object: nil)
    }
    
    func onAppear() {
        showVideoView()
    }
    
    func onTapNext() {
        NotificationCenter.default.post(name: .skipSong, object: nil)
    }
    
    func onTapShowVideo() {
        if !isVideoViewOnScreen {
            showVideoView()
        }
    }
    
    func onTapShowLyrics() {
        if !isLyricsViewOnScreen {
            showLyricsView()
        }
    }
    
    @objc private func onSongStartToPlay(notification: Notification) {
        guard let videoInfo = (notification.userInfo as? [String: Video])?["PopedVideo"] else {
            return
        }
        
        title?(videoInfo.title)
        if let thumbnail = videoInfo.thumbnail {
            image?(thumbnail)
        }
    }
    
    private func showVideoView() {
        let videoViewModel = StandardVideoViewModel(dependencyContainer: dependencyContainer)
        let videoViewController = VideoViewController(viewModel: videoViewModel)
        windowManager.showWindow(with: videoViewController, title: "KTV") { [weak self] in
            self?.isVideoViewOnScreen = false
        }
        isVideoViewOnScreen = true
    }
    
    private func showLyricsView() {
        let viewModel = StandardLyricsViewModel(lyricsRepository: dependencyContainer.repo.lyricsRepository)
        let lyricsViewController = LyricsViewController(viewModel: viewModel)
        windowManager.showWindow(with: lyricsViewController,
                                 title: NSLocalizedString("lyrics", comment: "Lyrics")) { [weak self] in
            self?.isLyricsViewOnScreen = false
        }
        isLyricsViewOnScreen = true
    }
}
