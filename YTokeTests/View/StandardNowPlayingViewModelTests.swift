//
//  StandardNowPlayingViewModelTests.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/12.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class StandaredNowPlayingViewModelTests: XCTestCase {
    
    private var dependencyContainer: MockDependencyContainer!
    private var viewModel: StandardNowPlayingViewModel!
    private var windowManager: MockWindowManager!
    
    override func setUp() {
        super.setUp()
        
        windowManager = MockWindowManager()
        dependencyContainer = MockDependencyContainer()
        viewModel = StandardNowPlayingViewModel(dependencyContainer: dependencyContainer,
                                                windowManager: windowManager)
    }
    
    override func tearDown() {
        super.tearDown()
        
        windowManager = nil
        dependencyContainer = nil
        viewModel = nil
    }
    
    func test_onAppear_SHOULD_showVideoView() {
        var isVideoButtonHidden: Bool?
        var isLyricsButtonHidden: Bool?
        viewModel.isShowVideoButtonHidden = { isHidden in
            isVideoButtonHidden = isHidden
        }
        viewModel.isShowLyricsButtonHidden = { isHidden in
            isLyricsButtonHidden = isHidden
        }
        viewModel.onAppear()
        XCTAssertEqual(windowManager.numOfShowWindowCalled, 1)
        XCTAssertEqual(isLyricsButtonHidden, nil)
        
        guard let isVideoButtonHiddenUnwarp = isVideoButtonHidden else {
            XCTFail("Video button hidden should be called once")
            return
        }
        
        XCTAssertTrue(isVideoButtonHiddenUnwarp)
    }
    
    func test_onTapShowVideo_SHOULD_showVideoView() {
        viewModel.onTapShowVideo()
        XCTAssertEqual(windowManager.numOfShowWindowCalled, 1)
    }
    
    func test_onTapShowVideo_SHOULD_NOT_showVideoView_IF_windowPresent() {
        viewModel.onAppear()
        viewModel.onTapShowVideo()
        XCTAssertEqual(windowManager.numOfShowWindowCalled, 1)
    }
    
    func test_onTapShowlyrics_SHOULD_showLyricsView() {
        viewModel.onTapShowLyrics()
        XCTAssertEqual(windowManager.numOfShowWindowCalled, 1)
    }
    
    func test_onTapShowlyrics_SHOULD_NOT_showLyricsView_IF_windowPresent() {
        viewModel.onTapShowLyrics()
        viewModel.onTapShowLyrics()
        XCTAssertEqual(windowManager.numOfShowWindowCalled, 1)
    }
    
    func test_onSongStartToPlay_SHOULD_setImageAndTitle() {
        let expectedTitle = "TITLE"
        var titleResult: String?
        viewModel.title = { title in
            titleResult = title
        }
        let expectedURL = URL(string: "www.youtube.com")!
        var imageResult: URL?
        viewModel.image = { imageURL in
            imageResult = imageURL
        }
        let info = ["PopedVideo": Video(id: "ID",
                                        title: expectedTitle,
                                        thumbnail: expectedURL,
                                        percentageFinished: 0.5,
                                        tag: [],
                                        searchQuery: "SearchQuery")]
        NotificationCenter.default.post(name: .queuePop, object: nil, userInfo: info)
        
        guard let titleResultUnwarp = titleResult, let imageResultUnwarp = imageResult else {
            XCTFail("Does not get video info")
            return
        }
        
        XCTAssertEqual(titleResultUnwarp, expectedTitle)
        XCTAssertEqual(imageResultUnwarp, expectedURL)
    }
}
