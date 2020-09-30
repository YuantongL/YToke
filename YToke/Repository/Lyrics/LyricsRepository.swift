//
//  LyricsRepository.swift
//  YToke
//
//  Created by Lyt on 9/28/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol LyricsRepository {
    /// Fetch lyrics by providing song name and singer name
    func get(songName: String, singerName: String?, onCompletion: @escaping (Result<String, Error>) -> Void)
}
