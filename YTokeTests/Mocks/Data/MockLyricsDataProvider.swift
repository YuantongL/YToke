//
//  MockLyricsDataProvider.swift
//  YTokeTests
//
//  Created by Lyt on 9/30/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

@testable import YToke

final class MockLyricsDataProvider: LyricsDataProvider {
    
    private (set) var numOfGetCalled = 0
    var getResult: Result<String, Error> = .success("Result")
    func get(url: URL, onCompletion: @escaping (Result<String, Error>) -> Void) {
        numOfGetCalled += 1
        onCompletion(getResult)
    }
    
}
