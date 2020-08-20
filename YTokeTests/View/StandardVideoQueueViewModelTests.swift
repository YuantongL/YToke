//
//  StandardVideoQueueViewModelTests.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/12.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class StandardVideoQueueViewModelTests: XCTestCase {
    
    private var viewModel: StandardVideoQueueViewModel!
    private var dependencyContainer: MockDependencyContainer!
    
    override func setUp() {
        super.setUp()
        
        dependencyContainer = MockDependencyContainer()
        viewModel = StandardVideoQueueViewModel(dependencyContainer: dependencyContainer)
    }
    
    override func tearDown() {
        super.tearDown()
        
        dependencyContainer = nil
        viewModel = nil
    }
    
    func test_onMoveToTopTap_SHOULD_moveInQueue() {
        let video = Video(id: "ID", title: "TITLE", thumbnail: nil)
        viewModel.onMoveToTopTap(video: video)
        XCTAssertEqual(dependencyContainer.mockVideoQueue.numOfMoveToTopCalled, 1)
    }
    
    func test_onDeleteTap_SHOULD_deleteInQueue() {
        let video = Video(id: "ID", title: "TITLE", thumbnail: nil)
        viewModel.onDeleteTap(video: video)
        XCTAssertEqual(dependencyContainer.mockVideoQueue.numOfDeleteCalled, 1)
    }
    
    func test_onQueuePop_SHOULD_reloadQueue() {
        var numOfOnReloadCalled = 0
        viewModel.onReload = {
            numOfOnReloadCalled += 1
        }
        NotificationCenter.default.post(name: .queuePop, object: nil)
        XCTAssertEqual(dependencyContainer.mockVideoQueue.numOfGetQueueCalled, 2)
        XCTAssertEqual(numOfOnReloadCalled, 1)
    }
    
    func test_onSongAdded_SHOULD_reloadQueue() {
        var numOfOnReloadCalled = 0
        viewModel.onReload = {
            numOfOnReloadCalled += 1
        }
        NotificationCenter.default.post(name: .addSong, object: nil)
        XCTAssertEqual(dependencyContainer.mockVideoQueue.numOfGetQueueCalled, 2)
        XCTAssertEqual(numOfOnReloadCalled, 1)
    }
    
    func test_onSongMoveToTop_SHOULD_moveToTop() {
        viewModel.videos = [Video(id: "12345", title: "TITLE", thumbnail: nil)]
        var resultIndex: Int?
        viewModel.onMoveToTop = { index in
            resultIndex = index
        }
        let info = ["FromIndex": 0]
        NotificationCenter.default.post(name: .moveToTop, object: nil, userInfo: info)
        XCTAssertEqual(dependencyContainer.mockVideoQueue.numOfGetQueueCalled, 2)
        guard let resultIndexUnwarp = resultIndex else {
            XCTFail("Should get result index from notification")
            return
        }
        XCTAssertEqual(resultIndexUnwarp, 0)
    }
    
    func test_onDeleteSong_SHOULD_delete() {
        var resultIndex: Int?
        viewModel.videos = [Video(id: "12345", title: "TITLE", thumbnail: nil)]
        viewModel.onDeleteRow = { id in
            resultIndex = id
        }
        let info = ["VideoId": "12345"]
        NotificationCenter.default.post(name: .deleteSong, object: nil, userInfo: info)
        guard let resultIndexUnwarp = resultIndex else {
            XCTFail("Should get video id from notification")
            return
        }
        XCTAssertEqual(resultIndexUnwarp, 0)
    }
    
}
