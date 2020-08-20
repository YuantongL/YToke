//
//  StandardVideoListRepository.swift
//  YToke
//
//  Created by Lyt on 2020/7/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

final class StandardVideoListRepository: VideoListRepository {
    
    private let videoListProvider: VideoListProvider

    init(videoListProvider: VideoListProvider) {
        self.videoListProvider = videoListProvider
    }
    
    func fetch(name: String, page: Int, onCompletion: @escaping (VideoListResult) -> Void) {
        videoListProvider.fetch(query: name, page: page) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    onCompletion(.failure(error))
                case .success(let videos):
                    onCompletion(.success(videos))
                }
            }
        }
    }
}
