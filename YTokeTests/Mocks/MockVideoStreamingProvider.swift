//
//  MockVideoStreamingProvider.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

@testable import YToke

final class MockVideoStreamingProvider: VideoStreamingProvider {
    var id: String?
    var numFetchStreamURLCalled = 0
    var result: Result<URL, Error> = .success(URL(string: "www.youtube.com")!)
    func fetchStreamURL(id: String,
                        onCompletion: @escaping (Result<URL, Error>) -> Void) {
        numFetchStreamURLCalled += 1
        self.id = id
        onCompletion(result)
    }
}
