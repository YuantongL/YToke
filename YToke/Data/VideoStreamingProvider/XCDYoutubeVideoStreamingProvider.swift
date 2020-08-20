//
//  XCDYoutubeVideoStreamingProvider.swift
//  YToke
//
//  Created by Lyt on 2020/7/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCDYouTubeKit

enum XCDYoutubeError: Error {
    case failed
}

final class XCDYoutubeVideoStreamingProvider: VideoStreamingProvider {
    
    private let client: XCDYouTubeClient
    
    init(client: XCDYouTubeClient = XCDYouTubeClient.default()) {
        self.client = client
    }
    
    func fetchStreamURL(id: String, onCompletion: @escaping (Result<URL, Error>) -> Void) {
        client.getVideoWithIdentifier(id) { video, error in
            if let error = error {
                onCompletion(.failure(error))
                return
            }
            
            guard let video = video, let streamURL = video.streamURL else {
                onCompletion(.failure(XCDYoutubeError.failed))
                return
            }
            
            onCompletion(.success(streamURL))
        }
    }
}
