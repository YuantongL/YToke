//
//  StandardVideoStreamingRepositoryTests.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class StandardVideoStreamingRepositoryTests: XCTestCase {
    
    private var repository: StandardVideoStreamingRepository!
    private var videoStreamingProvider: MockVideoStreamingProvider!
    
    override func setUp() {
        super.setUp()
        videoStreamingProvider = MockVideoStreamingProvider()
        repository = StandardVideoStreamingRepository(videoStreamingProvider: videoStreamingProvider)
    }
    
    override func tearDown() {
        super.tearDown()
        repository = nil
        videoStreamingProvider = nil
    }
    
    func test_fetchStreamURL_SHOULD_callProvider() {
        repository.fetchStreamURL(id: "ID") { _ in }
        XCTAssertEqual(videoStreamingProvider.numFetchStreamURLCalled, 1)
    }
    
    func test_fetchStreamURL_SHOULD_passID() {
        repository.fetchStreamURL(id: "ID") { _ in }
        guard let resultID = videoStreamingProvider.id else {
            XCTFail("ID was not passed to provider")
            return
        }
        XCTAssertEqual(resultID, "ID")
    }
    
    func test_fetchStreamURL_SHOULD_callCompletionHandler() {
        let url = URL(string: "www.youtube.com")!
        videoStreamingProvider.result = .success(url)
        repository.fetchStreamURL(id: "ID") { result in
            guard case .success(let resultURL) = result else {
                XCTFail("Should return success")
                return
            }
            XCTAssertEqual(resultURL, url)
        }
    }
}
