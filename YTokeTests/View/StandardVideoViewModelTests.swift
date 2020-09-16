//
//  StandardVideoViewModelTests.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/12.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class StandardVideoViewModelTests: XCTestCase {
    
    private var viewModel: StandardVideoViewModel!
    private var dependencyContainer: MockDependencyContainer!
    
    override func setUp() {
        super.setUp()
        
        dependencyContainer = MockDependencyContainer()
        viewModel = StandardVideoViewModel(dependencyContainer: dependencyContainer)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_init_SHOULD_subscribeMixerChange() {
        XCTAssertEqual(dependencyContainer.mockAudioMixer.numOfSubscribeChangesCalled, 1)
    }
    
    func test_onAppear_SHOULD_playVideo() {
        dependencyContainer.mockVideoQueue.nextResult = Video(id: "ID",
                                                              title: "TITLE",
                                                              thumbnail: nil,
                                                              percentageFinished: 0.5,
                                                              tag: [])
        viewModel.onAppear()
        XCTAssertEqual(dependencyContainer.mockVideoStreamingRepository.numOfFetchStreamURLCalled, 1)
        
        dependencyContainer.mockVideoQueue.nextResult = nil
        viewModel.onAppear()
        XCTAssertEqual(dependencyContainer.mockVideoStreamingRepository.numOfFetchStreamURLCalled, 1)
    }
    
    func test_onVideoFinished_SHOULD_playVideo() {
        dependencyContainer.mockVideoQueue.nextResult = Video(id: "ID",
                                                              title: "TITLE",
                                                              thumbnail: nil,
                                                              percentageFinished: 0.5,
                                                              tag: [])
        NotificationCenter.default.post(name: .AVPlayerItemDidPlayToEndTime, object: nil)
        XCTAssertEqual(dependencyContainer.mockVideoStreamingRepository.numOfFetchStreamURLCalled, 1)
        
        dependencyContainer.mockVideoQueue.nextResult = nil
        NotificationCenter.default.post(name: .AVPlayerItemDidPlayToEndTime, object: nil)
        XCTAssertEqual(dependencyContainer.mockVideoStreamingRepository.numOfFetchStreamURLCalled, 1)
    }
    
    func test_onSkipVideo_SHOULD_playVideo() {
        dependencyContainer.mockVideoQueue.nextResult = Video(id: "ID",
                                                              title: "TITLE",
                                                              thumbnail: nil,
                                                              percentageFinished: 0.5,
                                                              tag: [])
        NotificationCenter.default.post(name: .skipSong, object: nil)
        XCTAssertEqual(dependencyContainer.mockVideoStreamingRepository.numOfFetchStreamURLCalled, 1)
        
        dependencyContainer.mockVideoQueue.nextResult = nil
        NotificationCenter.default.post(name: .skipSong, object: nil)
        XCTAssertEqual(dependencyContainer.mockVideoStreamingRepository.numOfFetchStreamURLCalled, 1)
    }
    
    func test_onVideoPlayedHalf_SHOULD_showDualChoiceView() {
        var result = 0
        viewModel.showDualChoiceView = {
            result += 1
        }
        viewModel.onVideoPlayedHalf()
        XCTAssertEqual(result, 1)
    }
    
    func test_onVideoFinished_SHOULD_reportVideoImpression() {
        dependencyContainer.mockVideoQueue.nextResult = Video(id: "ID",
                                                              title: "TITLE",
                                                              thumbnail: nil,
                                                              percentageFinished: 0.5,
                                                              tag: [])
        viewModel.onAppear()
        viewModel.videoDuration = {
            300
        }
        viewModel.currentTime = {
            150
        }
        NotificationCenter.default.post(name: .AVPlayerItemDidPlayToEndTime, object: nil)
        XCTAssertEqual(dependencyContainer.mockVideoStatsRepository.numOfReportImpressionCalled, 1)
    }
    
    func test_onSkipVideo_SHOULD_reportVideoImpression() {
        dependencyContainer.mockVideoQueue.nextResult = Video(id: "ID",
                                                              title: "TITLE",
                                                              thumbnail: nil,
                                                              percentageFinished: 0.5,
                                                              tag: [])
        viewModel.onAppear()
        viewModel.videoDuration = {
            300
        }
        viewModel.currentTime = {
            150
        }
        NotificationCenter.default.post(name: .skipSong, object: nil)
        XCTAssertEqual(dependencyContainer.mockVideoStatsRepository.numOfReportImpressionCalled, 1)
    }
    
    func test_ondualChoiceViewSelect_SHOULD_reportTag() {
        dependencyContainer.mockVideoQueue.nextResult = Video(id: "ID",
                                                              title: "TITLE",
                                                              thumbnail: nil,
                                                              percentageFinished: 0.5,
                                                              tag: [])
        viewModel.onAppear()
        viewModel.onDualChoiceViewSelect(tag: .offVocal)
        XCTAssertEqual(dependencyContainer.mockVideoStatsRepository.numOfReportTagCalled, 1)
    }
}
