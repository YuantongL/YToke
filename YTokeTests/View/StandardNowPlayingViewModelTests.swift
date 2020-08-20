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
        viewModel.onAppear()
        XCTAssertEqual(windowManager.numOfShowWindowCalled, 1)
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
        let info = ["PopedVideo": Video(id: "ID", title: expectedTitle, thumbnail: expectedURL)]
        NotificationCenter.default.post(name: .queuePop, object: nil, userInfo: info)
        
        guard let titleResultUnwarp = titleResult, let imageResultUnwarp = imageResult else {
            XCTFail("Does not get video info")
            return
        }
        
        XCTAssertEqual(titleResultUnwarp, expectedTitle)
        XCTAssertEqual(imageResultUnwarp, expectedURL)
    }
}
