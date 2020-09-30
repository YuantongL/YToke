//
//  StandardVideoStatsMutationProviderTests.swift
//  YTokeTests
//
//  Created by Lyt on 9/16/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class StandardVideoStatsMutationProviderTests: XCTestCase {
    
    private var sut: StandardVideoStatsMutationProvider!
    private var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession(response: nil)
        sut = StandardVideoStatsMutationProvider(session: mockURLSession)
    }
    
    override func tearDown() {
        super.tearDown()
        mockURLSession = nil
        sut = nil
    }
    
    func test_reportTag_SHOULD_call_API() {
        sut.reportTag(videoId: "videoId", tag: .offVocal)
        XCTAssertEqual(mockURLSession.numOfDataTaskCalled, 1)
        guard let requestURL = mockURLSession.requestURL else {
            XCTFail("Unable to get the request url")
            return
        }
        XCTAssertEqual(requestURL.absoluteString, "https://ytokebackend.appspot.com/video/stats/tag")
        
        let parameters = "videoId=videoId&tag=OFF_VOCAL"
        let expectedBody = parameters.data(using: .utf8)
        guard let httpBody = mockURLSession.httpBody else {
            XCTFail("Unable to get the http body")
            return
        }
        XCTAssertEqual(httpBody, expectedBody)
    }
    
    func test_reportImpression_SHOULD_call_API() {
        sut.reportImpression(videoId: "videoId", percentage: 0.5)
        XCTAssertEqual(mockURLSession.numOfDataTaskCalled, 1)
        guard let requestURL = mockURLSession.requestURL else {
            XCTFail("Unable to get the request url")
            return
        }
        XCTAssertEqual(requestURL.absoluteString, "https://ytokebackend.appspot.com/video/stats/impression")
        
        let parameters = "videoId=videoId&percentage=0.5"
        let expectedBody =  parameters.data(using: .utf8)
        guard let httpBody = mockURLSession.httpBody else {
            XCTFail("Unable to get the http body")
            return
        }
        XCTAssertEqual(httpBody, expectedBody)
    }
}
