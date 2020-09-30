//
//  MockLyricsURLProvider.swift
//  YTokeTests
//
//  Created by Lyt on 9/30/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

@testable import YToke

final class MockLyricsURLProvider: LyricsURLProvider {
    
    private (set) var numOfGetLyricsCalled = 0
    var getLyricsResult: Result<URL, Error> = .success(URL(string: "www.url.com")!)
    func getLyrics(songName: String, singerName: String?, onCompletion: @escaping (Result<URL, Error>) -> Void) {
        numOfGetLyricsCalled += 1
        onCompletion(getLyricsResult)
    }
    
}
