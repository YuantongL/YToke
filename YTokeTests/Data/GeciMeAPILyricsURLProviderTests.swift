//
//  GeciMeAPILyricsURLProviderTests.swift
//  YTokeTests
//
//  Created by Lyt on 9/30/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class GeciMeAPILyricsURLProviderTests: XCTestCase {
    
    private var sut: GeciMeAPILyricsURLProvider!
    private var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession(response: nil)
        sut = GeciMeAPILyricsURLProvider(session: mockURLSession)
    }
    
    override func tearDown() {
        super.tearDown()
        mockURLSession = nil
        sut = nil
    }
    
    func test_get_SHOULD_make_networkCall() {
        sut.getLyrics(songName: "Song", singerName: "Singer") { _ in }
        XCTAssertEqual(mockURLSession.numOfDataTaskCalled, 1)
        guard let requestURL = mockURLSession.requestURL else {
            XCTFail("Unabled to get the request url")
            return
        }
        XCTAssertEqual(requestURL.absoluteString, "https://geci.me/api/lyric/Song/Singer")
    }
}
