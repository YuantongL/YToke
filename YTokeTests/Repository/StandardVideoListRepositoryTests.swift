//
//  StandardVideoListRepositoryTests.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class StandardVideoListRepositoryTests: XCTestCase {
    
    private var repository: StandardVideoListRepository!
    private var videoListProvider: MockVideoListProvider!
    
    override func setUp() {
        super.setUp()
        videoListProvider = MockVideoListProvider()
        repository = StandardVideoListRepository(videoListProvider: videoListProvider)
    }
    
    override func tearDown() {
        super.tearDown()
        videoListProvider = nil
        repository = nil
    }
    
    func test_fetch_SHOULD_callProvider() {
        repository.fetch(name: "Name", page: 8) { _ in }
        XCTAssertEqual(videoListProvider.numOfFetchCalled, 1)
    }
    
    func test_fetch_SHOULD_passQuery() {
        repository.fetch(name: "Name", page: 8) { _ in }
        XCTAssertEqual(videoListProvider.query, "Name")
    }
    
    func test_fetch_SHOULD_passPage() {
        repository.fetch(name: "Name", page: 8) { _ in }
        XCTAssertEqual(videoListProvider.page, 8)
    }
    
    func test_fetch_SHOULD_callCompletion() {
        let videos = [Video(id: "id",
                            title: "title",
                            thumbnail: nil,
                            percentageFinished: 0.5,
                            tag: [])]
        videoListProvider.result = .success(videos)
        repository.fetch(name: "Name", page: 8) { result in
            guard case .success(let resultVideos) = result else {
                XCTFail("Should return failure result")
                return
            }
            XCTAssertEqual(videos, resultVideos)
        }
    }
}
