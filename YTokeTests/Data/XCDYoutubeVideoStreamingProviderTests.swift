//
//  XCDYoutubeVideoStreamingProviderTests.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa
import XCDYouTubeKit
import XCTest

@testable import YToke

final class XCDYoutubeVideoStreamingProviderTests: XCTestCase {
    
    private var provider: XCDYoutubeVideoStreamingProvider!
    private var client: MockYoutubeClient!
    
    override func setUp() {
        super.setUp()
        client = MockYoutubeClient()
        provider = XCDYoutubeVideoStreamingProvider(client: client)
    }
    
    override func tearDown() {
        super.tearDown()
        client = nil
        provider = nil
    }
    
    func test_fetchStreamURL_SHOULD_call_client() {
        provider.fetchStreamURL(id: "MockID") { _ in
            XCTAssertEqual(self.client.numOfGetVideoCalled, 1)
        }
    }
    
    func test_noStreamURL_SHOULD_fail() {
        client.mockResult = .success(MockVideoWithoutStreamURL())
        provider.fetchStreamURL(id: "MockID") { result in
            guard case .failure = result else {
                XCTFail("Should fail with video without stream url")
                return
            }
            return
        }
    }
    
    func test_validStreamURL_SHOULD_success() {
        client.mockResult = .success(MockVideoWithStreamURL())
        provider.fetchStreamURL(id: "MockID") { result in
            guard case .success = result else {
                XCTFail("Should return success")
                return
            }
            return
        }
    }
}

private class MockVideoWithStreamURL: XCDYouTubeVideo {
    override var streamURL: URL? {
        URL(string: "www.youtube.com")
    }
}

private class MockVideoWithoutStreamURL: XCDYouTubeVideo {
    override var streamURL: URL? {
        nil
    }
}
