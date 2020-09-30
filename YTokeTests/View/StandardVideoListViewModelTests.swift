//
//  StandardVideoListViewModelTests.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/12.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class StandardVideoListViewModelTests: XCTestCase {
    
    private var viewModel: StandardVideoListViewModel!
    private var dependencyContainer: MockDependencyContainer!
    
    override func setUp() {
        super.setUp()
        dependencyContainer = MockDependencyContainer()
        viewModel = StandardVideoListViewModel(dependencyContainer: dependencyContainer, onPresentDonationView: {})
    }
    
    override func tearDown() {
        super.tearDown()
        dependencyContainer = nil
        viewModel = nil
    }
    
    func test_onTapDonation_SHOULD_callOnPresentDonationView() {
        var numOfPresentDonationView = 0
        let testViewModel = StandardVideoListViewModel(dependencyContainer: dependencyContainer) {
            numOfPresentDonationView += 1
        }
        testViewModel.onTapDonation()
        XCTAssertEqual(numOfPresentDonationView, 1)
    }
    
    func test_onTapSearch_SHOULD_fetchVideoList() {
        viewModel.onTapSearch(keyword: "Keyword")
        XCTAssertEqual(dependencyContainer.mockVideoListRepository.numOfFetchCalled, 1)
        XCTAssertEqual(dependencyContainer.mockVideoListRepository.fetchParamPage, 1)
        XCTAssertEqual(dependencyContainer.mockVideoListRepository.fetchParamName, "Keyword")
    }
    
    func test_onTapAddVideo_SHOULD_addToQueue() {
        let video = Video(id: "ID",
                          title: "TITLE",
                          thumbnail: nil,
                          percentageFinished: 0.5,
                          tag: [],
                          searchQuery: "SearchQuery")
        viewModel.onTapAddVideo(video)
        XCTAssertEqual(dependencyContainer.mockVideoQueue.numOfAddCalled, 1)
    }
    
    func test_onTapAddVideo_SHOULD_updateVideoList() {
        let video = Video(id: "ID",
                          title: "TITLE",
                          thumbnail: nil,
                          percentageFinished: 0.5,
                          tag: [],
                          searchQuery: "SearchQuery")
        var numOfOnUpdateCalled = 0
        viewModel.onUpdate = {
            numOfOnUpdateCalled += 1
        }
        viewModel.onTapAddVideo(video)
        XCTAssertEqual(numOfOnUpdateCalled, 1)
        XCTAssertEqual(viewModel.videos.count, 0)
    }
    
    func test_onScrollToBottom_SHOULD_fetchFollowingPages() {
        viewModel.onTapSearch(keyword: "Keyword")
        viewModel.onScrollToBottom()
        XCTAssertEqual(dependencyContainer.mockVideoListRepository.numOfFetchCalled, 2)
        XCTAssertEqual(dependencyContainer.mockVideoListRepository.fetchParamPage, 2)
    }
    
    func test_onScrollToBottom_SHOULD_notFetchWhenFetching() {
        dependencyContainer.mockVideoListRepository.result = nil
        viewModel.onTapSearch(keyword: "Keyword")
        viewModel.onScrollToBottom()
        XCTAssertEqual(dependencyContainer.mockVideoListRepository.numOfFetchCalled, 1)
        XCTAssertEqual(dependencyContainer.mockVideoListRepository.fetchParamPage, 1)
    }
}
