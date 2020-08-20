//
//  MockVideoStreamingRepository.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

@testable import YToke

final class MockVideoStreamingRepository: VideoStreamingRepository {
    
    var numOfFetchStreamURLCalled = 0
    var result: Result<URL, Error> = .success(URL(string: "www.youtube.com")!)
    func fetchStreamURL(id: String, onCompletion: @escaping (Result<URL, Error>) -> Void) {
        numOfFetchStreamURLCalled += 1
        onCompletion(result)
    }
    
}
