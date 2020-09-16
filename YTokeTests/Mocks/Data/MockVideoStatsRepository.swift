//
//  MockVideoStatsRepository.swift
//  YTokeTests
//
//  Created by Lyt on 9/16/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

@testable import YToke

final class MockVideoStatsRepository: VideoStatsRepository {
    
    var numOfReportTagCalled = 0
    func reportTag(videoId: String, tag: VideoTag) {
        numOfReportTagCalled += 1
    }
    
    var numOfReportImpressionCalled = 0
    func reportImpression(videoId: String, percentage: Double) {
        numOfReportImpressionCalled += 1
    }
    
}
