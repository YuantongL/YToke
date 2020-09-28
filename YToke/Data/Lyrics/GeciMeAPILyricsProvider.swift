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
}

class GeciMeAPILyricsURLProvider: LyricsURLProvider {
    
    private static let endpoint = "http://geci.me/api/lyric"
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func getLyrics(songName: String, singerName: String?, onCompletion: (Result<URL, Error>) -> Void) {
        var urlString = "\(Self.endpoint)/\(songName)"
        if let singerName = singerName {
            urlString.append("/\(singerName)")
        }
        guard let url = URL(string: urlString) else {
            onCompletion(.failure(GeciMeAPILyricsProviderError.failedToGenerateURL))
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
                let result = try JSONDecoder().decode(GeCiMeResponse.self, from: data)
            } catch {
                os_log("ERROR PARSING JSON DATA")
                onCompletion(.failure(YTokeBackendError.parseDataError))
                return
            }
        }
        task.resume()
    }
}

private struct GeCiMeResponse: Decodable {
    
    let result: [Result]
    
    private struct Result {
        let lrc: URL
    }
}
