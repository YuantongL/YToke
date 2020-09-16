//
//  MockVideoListProvider.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
@testable import YToke

final class MockVideoListProvider: VideoListProvider {
    var result: VideoListProviderResult = .success([])
    var numOfFetchCalled = 0
    var query: String?
    var page: Int?
    func fetch(query: String,
               page: Int,
               onCompletion: @escaping (VideoListProviderResult) -> Void) {
        numOfFetchCalled += 1
        self.query = query
        self.page = page
        onCompletion(result)
    }
}
