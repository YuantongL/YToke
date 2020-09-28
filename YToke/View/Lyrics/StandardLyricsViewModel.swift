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
    var onSeek: ((Float) -> Void)?
    var onPause: (() -> Void)?
    
    private let lyricsRepository: LyricsRepository
    
    init(lyricsRepository: LyricsRepository) {
        self.lyricsRepository = lyricsRepository
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onSongStartToPlay(notification:)),
                                               name: .queuePop,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func onSongStartToPlay(notification: Notification) {
        guard let videoInfo = (notification.userInfo as? [String: Video])?["PopedVideo"] else {
            return
        }
        onLoadingSpinnerHiddenChange?(false)
        onStatusLabelChange?(nil)
        lyricsRepository.get(songName: "Temp VideoName", singerName: nil) { [weak self] result in
            self?.onLoadingSpinnerHiddenChange?(true)
            guard case .success(let lyricsString) = result else {
                // TODO: Localize
                self?.onStatusLabelChange?("Can not find lyrics for this song")
                return
            }
            self?.onLyricsPlay?(LyricsViewConfig(songName: "Temp VideoName", singerName: nil, lyrics: lyricsString))
        }
    }
    
    func onSearchTapped(songName: String, singerName: String?) {
        onLoadingSpinnerHiddenChange?(false)
        onStatusLabelChange?(nil)
        lyricsRepository.get(songName: songName, singerName: singerName) { [weak self] result in
            self?.onLoadingSpinnerHiddenChange?(true)
            guard case .success(let lyricsString) = result else {
                self?.onStatusLabelChange?("Can not find lyrics for this song")
                return
            }
            self?.onLyricsDisplay?(LyricsViewConfig(songName: songName, singerName: singerName, lyrics: lyricsString))
        }
    }
    
}
