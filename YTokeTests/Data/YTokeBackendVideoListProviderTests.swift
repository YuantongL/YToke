//
//  YTokeBackendVideoListProviderTests.swift
//  YTokeTests
//
//  Created by Lyt on 9/16/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class YTokeBackendVideoListProviderTests: XCTestCase {
    
    private var sut: YTokeBackendVideoListProvider!
    private var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession(response: nil)
        sut = YTokeBackendVideoListProvider(session: mockURLSession)
    }
    
    override func tearDown() {
        super.tearDown()
        mockURLSession = nil
        sut = nil
    }
    
    func test_fetch_SHOULD_call_API() {
        sut.fetch(query: "song name", page: 3) { _ in }
        XCTAssertEqual(mockURLSession.numOfDataTaskCalled, 1)
        guard let requestURL = mockURLSession.requestURL else {
            XCTFail("Unable to get the request url")
            return
        }
        XCTAssertEqual(requestURL.absoluteString, "https://ytokebackend.appspot.com/videos?q=song%20name&page=3")
    }
    
    func test_dataTaskWithError_SHOULD_returnError() {
        mockURLSession.error = FakeError.someError
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "MockYTokeBackendAPI", withExtension: "json"),
            let json = try? Data(contentsOf: url) else {
            XCTFail("Missing file: MockYTokeBackendAPI.json")
            return
        }
        mockURLSession.data = json
        sut.fetch(query: "SongName", page: 8) { result in
            switch result {
            case .success:
                XCTFail("Should Not Success")
            case .failure(let error):
                guard let actualError = error as? YTokeBackendError else {
                    XCTFail("Should be YTokeBackendError type")
                    return
                }
                XCTAssertTrue(actualError == YTokeBackendError.fetchDataError)
            }
        }
    }
    
    func test_dataTaskWithNoData_SHOULD_returnError() {
        mockURLSession.error = nil
        mockURLSession.data = nil
        sut.fetch(query: "SongName", page: 8) { result in
            switch result {
            case .success:
                XCTFail("Should Not Success")
            case .failure(let error):
                guard let actualError = error as? YTokeBackendError else {
                    XCTFail("Should be YTokeBackendError type")
                    return
                }
                XCTAssertTrue(actualError == YTokeBackendError.fetchDataError)
            }
        }
    }
    
    func test_dataTaskWithResponseAndData_SHOULD_decode() {
        mockURLSession.error = nil
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "MockYTokeBackendAPI", withExtension: "json"),
            let json = try? Data(contentsOf: url) else {
            XCTFail("Missing file: MockYTokeBackendAPI.json")
            return
        }
        mockURLSession.data = json
        sut.fetch(query: "SongName", page: 8) { result in
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
                XCTAssertEqual(firstVideo.tag?.count, 1)
                XCTAssertEqual(firstVideo.tag?.first, VideoTag.offVocal)
                XCTAssertEqual(firstVideo.percentageFinished, nil)
                
                XCTAssertEqual(secondVideo.id, "VideoId2")
                XCTAssertEqual(secondVideo.thumbnail, URL(string: "highURL2"))
                XCTAssertEqual(secondVideo.title, "Title2")
                XCTAssertEqual(secondVideo.tag, nil)
                XCTAssertEqual(secondVideo.percentageFinished, 0.7)
            case .failure:
                XCTFail("Should return valid videos")
            }
        }
    }
}

private enum FakeError: Error {
    case someError
}
