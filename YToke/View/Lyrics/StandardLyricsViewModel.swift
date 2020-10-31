//
//  StandardLyricsViewModel.swift
//  YToke
//
//  Created by Lyt on 9/28/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

final class StandardLyricsViewModel: LyricsViewModel {
    
    var onLoadingSpinnerHiddenChange: ((Bool) -> Void)?
    var onStatusLabelChange: ((String?) -> Void)?
    
    var onLyricsPlay: ((LyricsViewConfig) -> Void)?
    var onLyricsDisplay: ((LyricsViewConfig) -> Void)?
    var onSeek: ((TimeInterval) -> Void)?
    var onPause: (() -> Void)?
    
    private let lyricsRepository: LyricsRepository
    
    init(lyricsRepository: LyricsRepository) {
        self.lyricsRepository = lyricsRepository
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onSongStartToPlay(notification:)),
                                               name: .queuePop,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onVideoPlayerStartPlayBack),
                                               name: .videoPlayerStartPlayback,
                                               object: nil)
    }
    
    @objc private func onSongStartToPlay(notification: Notification) {
        guard let videoInfo = (notification.userInfo as? [String: Video])?["PopedVideo"],
              let songName = videoInfo.searchQuery else {
            onLyricsDisplay?(LyricsViewConfig(songName: "", singerName: nil, lyrics: ""))
            onStatusLabelChange?(NSLocalizedString("no_lyrics",
                                                   comment: "No lyrics to display"))
            return
        }
        
        onLoadingSpinnerHiddenChange?(false)
        onStatusLabelChange?(nil)
        onLyricsDisplay?(LyricsViewConfig(songName: "", singerName: "", lyrics: ""))
        lyricsRepository.get(songName: songName, singerName: nil) { [weak self] result in
            self?.onLoadingSpinnerHiddenChange?(true)
            guard case .success(let lyricsString) = result else {
                self?.onStatusLabelChange?(NSLocalizedString("cant_find_lyrics",
                                                             comment: "Can not find lyrics for this song"))
                return
            }
            self?.onLyricsPlay?(LyricsViewConfig(songName: songName,
                                                 singerName: nil,
                                                 lyrics: lyricsString))
        }
    }
    
    func onSearchTapped(songName: String, singerName: String?) {
        guard !songName.isEmpty else {
            return
        }
        onLyricsDisplay?(LyricsViewConfig(songName: "", singerName: "", lyrics: ""))
        onLoadingSpinnerHiddenChange?(false)
        onStatusLabelChange?(nil)
        lyricsRepository.get(songName: songName, singerName: singerName) { [weak self] result in
            self?.onLoadingSpinnerHiddenChange?(true)
            guard case .success(let lyricsString) = result else {
                self?.onStatusLabelChange?(NSLocalizedString("cant_find_lyrics",
                                                             comment: "Can not find lyrics for this song"))
                return
            }
            self?.onLyricsDisplay?(LyricsViewConfig(songName: songName, singerName: singerName, lyrics: lyricsString))
        }
    }
    
    @objc private func onVideoPlayerStartPlayBack() {
        onSeek?(TimeInterval.zero)
    }
    
}
