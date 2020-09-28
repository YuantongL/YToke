//
//  LyricsViewModel.swift
//  YToke
//
//  Created by Lyt on 9/28/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol LyricsViewModel {
    
    /// This will show and play the lyrics along with the video from the begining
    var onLyricsPlay: ((LyricsViewConfig) -> Void)? { get set }
    
    /// Just display the lyrics in the scrollable view
    var onLyricsDisplay: ((LyricsViewConfig) -> Void)? { get set }
    
    var onSeek: ((Float) -> Void)? { get set }
    var onPause: (() -> Void)? { get set }
    
    var onLoadingSpinnerHiddenChange: ((Bool) -> Void)? { get set }
    var onStatusLabelChange: ((String?) -> Void)? { get set }
    
    func onSearchTapped(songName: String, singerName: String?)
    
}
