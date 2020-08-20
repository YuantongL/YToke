//
//  MockVideoListRepository.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

@testable import YToke

final class MockVideoListRepository: VideoListRepository {
    
    var numOfFetchCalled = 0
    var fetchParamName: String?
    var fetchParamPage: Int?
    var result: VideoListResult = .success([])
    func fetch(name: String, page: Int, onCompletion: @escaping (VideoListResult) -> Void) {
        fetchParamName = name
        fetchParamPage = page
        numOfFetchCalled += 1
        onCompletion(result)
    }
}
