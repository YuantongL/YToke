//
//  StandardDonationViewModelTests.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class StandardDonationViewModelTests: XCTestCase {
    
    private var mockWorkspace: MockWorkspace!
    private var viewModel: StandardDonationViewModel!
    
    override func setUp() {
        super.setUp()
        mockWorkspace = MockWorkspace()
        viewModel = StandardDonationViewModel(workspace: mockWorkspace)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        mockWorkspace = nil
    }
    
    func test_onTapButton_SHOULD_openURL() {
        viewModel.onTapButton()
        XCTAssertEqual(mockWorkspace.numOfOpenCalled, 1)
    }
}

private class MockWorkspace: NSWorkspace {
    var numOfOpenCalled = 0
    override func open(_ url: URL) -> Bool {
        numOfOpenCalled += 1
        return true
    }
}
