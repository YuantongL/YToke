//
//  LyricsProvider.swift
//  YToke
//
//  Created by Lyt on 9/28/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol LyricsURLProvider {
    /// Fetches lyric for song and singer
    func getLyrics(songName: String, singerName: String?, onCompletion: @escaping (Result<URL, Error>) -> Void)
}
