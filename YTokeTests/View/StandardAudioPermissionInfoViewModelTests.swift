//
//  StandardAudioPermissionInfoViewModelTests.swift
//  YTokeTests
//
//  Created by Lyt on 8/30/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

// swiftlint:disable:next type_name
final class StandardAudioPermissionInfoViewModelTests: XCTestCase {
    
    private var viewModel: StandardAudioPermissionInfoViewModel!
    private var systemNavigator: MockSystemNavigator!
    
    override func setUp() {
        super.setUp()
        systemNavigator = MockSystemNavigator()
        viewModel = StandardAudioPermissionInfoViewModel(systemNavigator: systemNavigator)
    }
    
    override func tearDown() {
        super.tearDown()
        systemNavigator = nil
        viewModel = nil
    }
    
    func test_onButtonTap_SHOULD_callNavigator() {
        viewModel.onButtonTap()
        XCTAssertEqual(systemNavigator.numOfOpenPrivacySettingsCalled, 1)
    }
}
