//
//  StandardVideoStatsRepositoryTests.swift
//  YTokeTests
//
//  Created by Lyt on 9/16/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class StandardVideoStatsRepositoryTests: XCTestCase {
    
    private var sut: StandardVideoStatsRepository!
    private var mockVideoStatsMutationProvider: MockVideoStatsMutationProvider!
    
    override func setUp() {
        super.setUp()
        mockVideoStatsMutationProvider = MockVideoStatsMutationProvider()
        sut = StandardVideoStatsRepository(videoStatsMutationProvider: mockVideoStatsMutationProvider)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        mockVideoStatsMutationProvider = nil
    }
    
    func test_reportTag_SHOULD_call_provider() {
        sut.reportTag(videoId: "videoId", tag: .offVocal)
        XCTAssertEqual(mockVideoStatsMutationProvider.numOfReportTagCalled, 1)
    }
    
    func test_reportImpression_SHOULD_call_provider() {
        sut.reportImpression(videoId: "videoId", percentage: 0.5)
        XCTAssertEqual(mockVideoStatsMutationProvider.numOfReportImpressionCalled, 1)
    }
}
