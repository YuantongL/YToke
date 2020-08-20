//
//  StandardVideoStreamingRespository.swift
//  YToke
//
//  Created by Lyt on 2020/7/30.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

final class StandardVideoStreamingRepository: VideoStreamingRepository {
    
    private let videoStreamingProvider: VideoStreamingProvider
    
    init(videoStreamingProvider: VideoStreamingProvider) {
        self.videoStreamingProvider = videoStreamingProvider
    }
    
    func fetchStreamURL(id: String, onCompletion: @escaping (Result<URL, Error>) -> Void) {
        videoStreamingProvider.fetchStreamURL(id: id) { result in
            DispatchQueue.main.async {
                onCompletion(result)
            }
        }
    }
}
