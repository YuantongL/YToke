//
//  StandardLyricsViewModelTests.swift
//  YTokeTests
//
//  Created by Lyt on 9/30/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class StandardLyricsViewModelTests: XCTestCase {
    
    private var sut: StandardLyricsViewModel!
    private var lyricsRepository: MockLyricsRepository!
    
    override func setUp() {
        super.setUp()
        lyricsRepository = MockLyricsRepository()
        sut = StandardLyricsViewModel(lyricsRepository: lyricsRepository)
    }
    
    override func tearDown() {
        super.tearDown()
        lyricsRepository = nil
        sut = nil
    }
    
    func test_onSongStartToPlay_SHOULD_fetchLyrics() {
        let info = ["PopedVideo": Video(id: "ID",
                                        title: "Title",
                                        thumbnail: URL(string: "SomeURL")!,
                                        percentageFinished: 0.5,
                                        tag: [],
                                        searchQuery: "SearchQuery")]
        NotificationCenter.default.post(name: .queuePop, object: nil, userInfo: info)
        XCTAssertEqual(lyricsRepository.numOfGetCalled, 1)
    }
    
    func test_onPlayerStart_SHOULD_seekToBeginning() {
        var numOfSeekCalled = 0
        sut.onSeek = { timeInterval in
            numOfSeekCalled += 1
            XCTAssertEqual(timeInterval, .zero)
        }
        NotificationCenter.default.post(name: .videoPlayerStartPlayback, object: nil, userInfo: nil)
        XCTAssertEqual(numOfSeekCalled, 1)
    }
    
    func test_fetchError_SHOULD_showStatusLabel() {
        var statusMessages: [String?] = []
        sut.onStatusLabelChange = { message in
            statusMessages.append(message)
        }
        let info = ["PopedVideo": Video(id: "ID",
                                        title: "Title",
                                        thumbnail: URL(string: "SomeURL")!,
                                        percentageFinished: 0.5,
                                        tag: [],
                                        searchQuery: "SearchQuery")]
        lyricsRepository.getResult = .failure(GeciMeAPILyricsProviderError.failedToParseResponse)
        NotificationCenter.default.post(name: .queuePop, object: nil, userInfo: info)
        XCTAssertEqual(statusMessages.count, 2)
        XCTAssertNil(statusMessages[0])
        XCTAssertNotNil(statusMessages[1])
    }
    
    func test_duringFetch_SHOULD_showSpinner() {
        var spinnerChanges: [Bool] = []
        sut.onLoadingSpinnerHiddenChange = { isHidden in
            spinnerChanges.append(isHidden)
        }
        let info = ["PopedVideo": Video(id: "ID",
                                        title: "Title",
                                        thumbnail: URL(string: "SomeURL")!,
                                        percentageFinished: 0.5,
                                        tag: [],
                                        searchQuery: "SearchQuery")]
        lyricsRepository.getResult = .failure(GeciMeAPILyricsProviderError.failedToParseResponse)
        NotificationCenter.default.post(name: .queuePop, object: nil, userInfo: info)
        
        XCTAssertEqual(spinnerChanges.count, 2)
        XCTAssertEqual(spinnerChanges[0], false)
        XCTAssertEqual(spinnerChanges[1], true)
    }
    
    func test_songStartToPlay_SHOULD_callLyricPlay() {
        var numOfOnLyricsPlayCalled = 0
        sut.onLyricsPlay = { _ in
            numOfOnLyricsPlayCalled += 1
        }
        let info = ["PopedVideo": Video(id: "ID",
                                        title: "Title",
                                        thumbnail: URL(string: "SomeURL")!,
                                        percentageFinished: 0.5,
                                        tag: [],
                                        searchQuery: "SearchQuery")]
        NotificationCenter.default.post(name: .queuePop, object: nil, userInfo: info)
        XCTAssertEqual(numOfOnLyricsPlayCalled, 1)
    }
    
    func test_searchTapped_SHOULD_callLyricDisplay() {
        var numOfOnLyricsDisplayCalled = 0
        sut.onLyricsDisplay = { _ in
            numOfOnLyricsDisplayCalled += 1
        }
        sut.onSearchTapped(songName: "Song Name", singerName: "Singer Name")
        XCTAssertEqual(lyricsRepository.numOfGetCalled, 1)
        XCTAssertEqual(numOfOnLyricsDisplayCalled, 2)
    }
    
}
