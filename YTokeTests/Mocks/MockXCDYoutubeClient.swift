//
//  MockXCDYoutubeClient.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCDYouTubeKit

final class MockYoutubeClient: XCDYouTubeClient {
    var numOfGetVideoCalled: Int = 0
    var mockResult: Result<XCDYouTubeVideo?, Error> = .success(nil)
    // swiftlint:disable line_length
    override func getVideoWithIdentifier(_ videoIdentifier: String?,
                                         completionHandler: @escaping (XCDYouTubeVideo?, Error?) -> Void) -> XCDYouTubeOperation {
        numOfGetVideoCalled += 1
        switch mockResult {
        case .success(let video):
            completionHandler(video, nil)
        case .failure(let error):
            completionHandler(nil, error)
        }
        return XCDYouTubeVideoOperation(videoIdentifier: "Video", languageIdentifier: nil)
    }
}
