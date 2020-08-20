//
//  VideoModelTests.swift
//  YTokeTests
//
//  Created by Lyt on 8/19/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class VideoModelTests: XCTestCase {
    
    /// Test decodable object can get data from JSON
    func test_video_SHOULD_decode() {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "MockVideo", withExtension: "json"),
            let json = try? Data(contentsOf: url) else {
            XCTFail("Missing file: MockVideo.json")
            return
        }
        
        guard let video = try? JSONDecoder().decode(Video.self, from: json) else {
            XCTFail("Could not decode video")
            return
        }
        
        XCTAssertEqual(video.id, "ID")
        XCTAssertEqual(video.thumbnail, URL(string: "Thumbnail"))
        XCTAssertEqual(video.title, "Title")
    }
}
