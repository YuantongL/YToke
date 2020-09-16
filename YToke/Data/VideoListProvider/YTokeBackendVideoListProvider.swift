//
//  YTokeBackendVideoListProvider.swift
//  YToke
//
//  Created by Lyt on 9/14/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import os.log

enum YTokeBackendError: Error {
    case unableToGenerateURL
    case fetchDataError
    case parseDataError
}

final class YTokeBackendVideoListProvider: VideoListProvider {
    
    private static let endpoint = "https://ytokebackend.appspot.com/videos"
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch(query: String, page: Int, onCompletion: @escaping (VideoListProviderResult) -> Void) {
        var urlComponents = URLComponents(string: Self.endpoint)
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: "\(query)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = urlComponents?.url else {
            onCompletion(.failure(YTokeBackendError.unableToGenerateURL))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            if error != nil {
                onCompletion(.failure(YTokeBackendError.fetchDataError))
                return
            }
            
            guard let data = data else {
                onCompletion(.failure(YTokeBackendError.fetchDataError))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(YTokeBackendResponse.self, from: data)
                onCompletion(.success(result.videos.map { $0.video }))
            } catch {
                os_log("ERROR PARSING JSON DATA")
                onCompletion(.failure(YTokeBackendError.parseDataError))
                return
            }
        }
        task.resume()
    }
}

private struct YTokeBackendResponse: Decodable {
    
    let q: String
    let videos: [Video]
    
    struct Video: Decodable {
        let title: String
        let videoId: String
        let thumbnails: [Thumbnail]
        let tags: [String]?
        let percentageFinished: Float?
    }
    
    struct Thumbnail: Decodable {
        let quality: String
        let url: String
    }
}

private extension YTokeBackendResponse.Video {
    var video: Video {
        if let urlString = thumbnails.first(where: { $0.quality == "high" })?.url {
            return Video(id: self.videoId,
                         title: self.title,
                         thumbnail: URL(string: urlString),
                         percentageFinished: self.percentageFinished,
                         tag: self.tags?.compactMap { $0.videoTag })
        } else {
            return Video(id: self.videoId,
                         title: self.title,
                         thumbnail: nil,
                         percentageFinished: self.percentageFinished,
                         tag: self.tags?.compactMap { $0.videoTag })
        }
    }
}

private extension String {
    var videoTag: VideoTag? {
        switch self {
        case "OFF_VOCAL":
            return .offVocal
        case "WITH_VOCAL":
            return .withVocal
        default:
            return nil
        }
    }
}
