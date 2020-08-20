//
//  InvidiousAPIVideoListProviderTests.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class InvidiousAPIVideoListProviderTests: XCTestCase {
    
    private var provider: InvidiousAPIVideoListProvider!
    private var urlSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        urlSession = MockURLSession(response: nil)
        provider = InvidiousAPIVideoListProvider(session: urlSession)
    }
    
    override func tearDown() {
        super.tearDown()
        urlSession = nil
        provider = nil
    }
    
    func test_fetch_SHOULD_callDataTask() {
        provider.fetch(query: "SongName", page: 8) { _ in }
        XCTAssertEqual(urlSession.numOfDataTaskCalled, 1)
    }
    
    func test_url_components() {
        provider.fetch(query: "SongName", page: 8) { _ in }
        guard let requestURL = urlSession.requestURL else {
            XCTFail("Unable to get the request url")
            return
        }
        XCTAssertEqual(requestURL.absoluteString,
                       "https://www.invidio.us/api/v1/search?q=SongName%20ktv&page=8")
    }
    
    func test_dataTaskWithError_SHOULD_returnError() {
        urlSession.error = FakeError.someError
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "MockInvidiosAPI", withExtension: "json"),
            let json = try? Data(contentsOf: url) else {
            XCTFail("Missing file: MockInvidiosAPI.json")
            return
        }
        urlSession.data = json
        provider.fetch(query: "SongName", page: 8) { result in
            switch result {
            case .success:
                XCTFail("Should Not Success")
            case .failure(let error):
                guard let actualError = error as? InvidiousAPIError else {
                    XCTFail("Should be InvidiousAPIError type")
                    return
                }
                XCTAssertTrue(actualError == InvidiousAPIError.fetchDataError)
            }
        }
    }
    
    func test_dataTaskWithNoData_SHOULD_returnError() {
        urlSession.error = nil
        urlSession.data = nil
        provider.fetch(query: "SongName", page: 8) { result in
            switch result {
            case .success:
                XCTFail("Should Not Success")
            case .failure(let error):
                guard let actualError = error as? InvidiousAPIError else {
                    XCTFail("Should be InvidiousAPIError type")
                    return
                }
                XCTAssertTrue(actualError == InvidiousAPIError.fetchDataError)
            }
        }
    }
    
    func test_dataTaskWithResponseAndData_SHOULD_decode() {
        urlSession.error = nil
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "MockInvidiosAPI", withExtension: "json"),
            let json = try? Data(contentsOf: url) else {
            XCTFail("Missing file: MockInvidiosAPI.json")
            return
        }
        urlSession.data = json
        provider.fetch(query: "SongName", page: 8) { result in
            switch result {
            case .success(let videos):
                XCTAssertEqual(videos.count, 2)
                guard let firstVideo = videos.first,
                    let secondVideo = videos.last else {
                    XCTFail("Unable to get 2 videos")
                    return
                }
                XCTAssertEqual(firstVideo.id, "VideoId")
                XCTAssertEqual(firstVideo.thumbnail, URL(string: "highURL"))
                XCTAssertEqual(firstVideo.title, "Title")
                
                XCTAssertEqual(secondVideo.id, "VideoId2")
                XCTAssertEqual(secondVideo.thumbnail, URL(string: "highURL2"))
                XCTAssertEqual(secondVideo.title, "Title2")
            case .failure:
                XCTFail("Should return valid videos")
            }
        }
    }
    
}

private enum FakeError: Error {
    case someError
}
