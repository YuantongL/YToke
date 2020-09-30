//
//  StandardLyricsRepositoryTests.swift
//  YTokeTests
//
//  Created by Lyt on 9/30/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class StandardLyricsRepositoryTests: XCTestCase {
    
    private var sut: StandardLyricsRepository!
    private var urlProvider: MockLyricsURLProvider!
    private var dataProvider: MockLyricsDataProvider!
    
    override func setUp() {
        super.setUp()
        urlProvider = MockLyricsURLProvider()
        dataProvider = MockLyricsDataProvider()
        sut = StandardLyricsRepository(urlProvider: urlProvider, dataProvider: dataProvider)
    }
    
    override func tearDown() {
        super.tearDown()
        urlProvider = nil
        dataProvider = nil
        sut = nil
    }
    
    func test_get_SHOULD_getLyricsURLAndData() {
        urlProvider.getLyricsResult = .success(URL(string: "someURL")!)
        dataProvider.getResult = .success("someLyrics")
        sut.get(songName: "Song", singerName: "Singer") { result in
            guard case .success(let url) = result else {
                XCTFail("Get url failed")
                return
            }
            XCTAssertEqual(url, "someLyrics")
        }
        XCTAssertEqual(urlProvider.numOfGetLyricsCalled, 1)
        XCTAssertEqual(dataProvider.numOfGetCalled, 1)
    }
}
