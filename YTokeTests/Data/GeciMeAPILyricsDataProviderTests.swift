//
//  GeciMeAPILyricsDataProviderTests.swift
//  YTokeTests
//
//  Created by Lyt on 9/30/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class GeciMeAPILyricsDataProviderTests: XCTestCase {
    
    private var sut: GeciMeAPILyricsDataProvider!
    private var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession(response: nil)
        sut = GeciMeAPILyricsDataProvider(session: mockURLSession)
    }
    
    override func tearDown() {
        super.tearDown()
        mockURLSession = nil
        sut = nil
    }
    
    func test_get_SHOULD_make_networkCall() {
        sut.get(url: URL(string: "http://s.gecimi.com/lrc/303/30392/3039215.lrc")!) { _ in }
        XCTAssertEqual(mockURLSession.numOfDataTaskCalled, 1)
        guard let requestURL = mockURLSession.requestURL else {
            XCTFail("Unabled to get the request url")
            return
        }
        XCTAssertEqual(requestURL.absoluteString, "http://s.gecimi.com/lrc/303/30392/3039215.lrc")
    }
}
