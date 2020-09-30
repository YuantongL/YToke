//
//  GeciMeAPILyricsProvider.swift
//  YToke
//
//  Created by Lyt on 9/28/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import os.log
import Foundation

enum GeciMeAPILyricsProviderError: Error {
    case failedToGenerateURL
    case notFound
    case failedToParseResponse
}

class GeciMeAPILyricsURLProvider: LyricsURLProvider {
    
    private static let endpoint = "https://geci.me/api/lyric"
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func getLyrics(songName: String, singerName: String?, onCompletion: @escaping (Result<URL, Error>) -> Void) {
        var urlString = "\(Self.endpoint)/\(songName)"
        if let singerName = singerName {
            urlString.append("/\(singerName)")
        }
        guard let urlEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlEncoded) else {
            onCompletion(.failure(GeciMeAPILyricsProviderError.failedToGenerateURL))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            if error != nil {
                onCompletion(.failure(GeciMeAPILyricsProviderError.notFound))
                return
            }
            
            guard let data = data else {
                onCompletion(.failure(GeciMeAPILyricsProviderError.notFound))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(GeCiMeResponse.self, from: data)
                if let url = result.result.first?.lrc {
                    onCompletion(.success(url))
                } else {
                    onCompletion(.failure(GeciMeAPILyricsProviderError.failedToParseResponse))
                }
            } catch {
                os_log("ERROR PARSING JSON DATA")
                onCompletion(.failure(GeciMeAPILyricsProviderError.failedToParseResponse))
                return
            }
        }
        task.resume()
    }
}

private struct GeCiMeResponse: Decodable {
    
    let result: [Result]
    
    struct Result: Decodable {
        let lrc: URL
    }
}
