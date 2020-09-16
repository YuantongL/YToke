//
//  StandardVideoStatsMutationProvider.swift
//  YToke
//
//  Created by Lyt on 9/14/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

final class StandardVideoStatsMutationProvider: VideoStatsMutationProvider {
    
    private static let endpoint = "https://ytokebackend.appspot.com/video/stats"
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func reportTag(videoId: String, tag: VideoTag) {
        let parameters = "videoId=\(videoId)&tag=\(tag.queryParameter)"
        let postData =  parameters.data(using: .utf8)
        
        guard let url = URL(string: "\(Self.endpoint)/tag") else {
            return
        }

        var request = URLRequest(url: url)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = session.dataTask(with: request)
        task.resume()
    }
    
    func reportImpression(videoId: String, percentage: Double) {
        let parameters = "videoId=\(videoId)&percentage=\(percentage)"
        let postData =  parameters.data(using: .utf8)
        
        guard let url = URL(string: "\(Self.endpoint)/impression") else {
            return
        }

        var request = URLRequest(url: url)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = session.dataTask(with: request)
        task.resume()
    }
    
}

private extension VideoTag {
    var queryParameter: String {
        switch self {
        case .offVocal:
            return "OFF_VOCAL"
        case .withVocal:
            return "WITH_VOCAL"
        }
    }
}
