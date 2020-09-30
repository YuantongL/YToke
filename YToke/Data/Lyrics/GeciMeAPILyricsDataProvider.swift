//
//  GeciMeAPILyricsDataProvider.swift
//  YToke
//
//  Created by Lyt on 9/28/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import os.log
import Foundation

enum GeciMeAPILyricsDataProviderError: Error {
    case notFound
    case failedToParseResponse
}

final class GeciMeAPILyricsDataProvider: LyricsDataProvider {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func get(url: URL, onCompletion: @escaping (Result<String, Error>) -> Void) {
        let urlRequest = URLRequest(url: url)
        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            if error != nil {
                onCompletion(.failure(GeciMeAPILyricsDataProviderError.notFound))
                return
            }
            
            guard let data = data else {
                onCompletion(.failure(GeciMeAPILyricsDataProviderError.notFound))
                return
            }
            
            guard let resultString = String(data: data, encoding: .utf8) else {
                onCompletion(.failure(GeciMeAPILyricsDataProviderError.failedToParseResponse))
                return
            }
            
            onCompletion(.success(resultString))
        }
        task.resume()
    }
}
