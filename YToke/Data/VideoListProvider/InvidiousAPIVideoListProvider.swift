//
//  InvidiousAPIVideoListProvider.swift
//  YToke
//
//  Created by Lyt on 2020/7/27.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import os.log

enum InvidiousAPIError: Error {
    case unableToGenerateURL
    case fetchDataError
    case parseDataError
}

final class InvidiousAPIVideoListProvider: VideoListProvider {
    
    private static let endpoint = "https://www.invidio.us/api/v1/search"
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch(query: String, page: Int, onCompletion: @escaping (VideoListProviderResult) -> Void) {
        var urlComponents = URLComponents(string: Self.endpoint)
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: "\(query) ktv"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = urlComponents?.url else {
            onCompletion(.failure(InvidiousAPIError.unableToGenerateURL))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            if error != nil {
                onCompletion(.failure(InvidiousAPIError.fetchDataError))
                return
            }
            
            guard let data = data else {
                onCompletion(.failure(InvidiousAPIError.fetchDataError))
                return
            }
            
            do {
                let invidiousResult = try JSONDecoder().decode(Array<InvidiousVideo>.self, from: data)
                onCompletion(.success(invidiousResult.map { $0.video }))
            } catch {
                os_log("ERROR PARSING JSON DATA")
                onCompletion(.failure(InvidiousAPIError.parseDataError))
                return
            }
        }
        task.resume()
    }
}

private struct InvidiousVideo: Decodable {
    let title: String
    let videoId: String
    let videoThumbnails: [InvidiousThumbnails]
    
    struct InvidiousThumbnails: Decodable {
        let quality: String
        let url: String
    }
}

extension InvidiousVideo {
    var video: Video {
        if let thumbnailString = videoThumbnails.first(where: { $0.quality == "high" })?.url {
            let url = URL(string: thumbnailString)
            return Video(id: videoId,
                         title: title,
                         thumbnail: url)
        } else {
            return Video(id: videoId,
                         title: title,
                         thumbnail: nil)
        }
    }
}
