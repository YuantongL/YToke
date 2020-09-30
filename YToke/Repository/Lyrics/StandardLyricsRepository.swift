//
//  StandardLyricsRepository.swift
//  YToke
//
//  Created by Lyt on 9/28/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

final class StandardLyricsRepository: LyricsRepository {
    
    private let urlProvider: LyricsURLProvider
    private let dataProvider: LyricsDataProvider
    
    init(urlProvider: LyricsURLProvider, dataProvider: LyricsDataProvider) {
        self.urlProvider = urlProvider
        self.dataProvider = dataProvider
    }
    
    func get(songName: String, singerName: String?, onCompletion: @escaping (Result<String, Error>) -> Void) {
        urlProvider.getLyrics(songName: songName, singerName: singerName) { [weak self] result in
            switch result {
            case .success(let url):
                self?.fetchData(url: url, onCompletion: onCompletion)
            case .failure(let error):
                DispatchQueue.main.async {
                    onCompletion(.failure(error))
                }
            }
        }
    }
    
    private func fetchData(url: URL, onCompletion: @escaping (Result<String, Error>) -> Void) {
        dataProvider.get(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let lyricsString):
                    onCompletion(.success(lyricsString))
                case .failure(let error):
                    onCompletion(.failure(error))
                }
            }
        }
    }
}
