//
//  LyricsDataProvider.swift
//  YToke
//
//  Created by Lyt on 9/28/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol LyricsDataProvider {
    /// Get the lyric content from a url
    func get(url: URL, onCompletion: @escaping (Result<String, Error>) -> Void)
}
