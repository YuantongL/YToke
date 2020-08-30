//
//  StandardPrivacyPermissionRepositoryTests.swift
//  YTokeTests
//
//  Created by Lyt on 8/29/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class StandardPrivacyPermissionRepositoryTests: XCTest {
    
    private var repository: StandardPrivacyPermissionRepository!
    private var mockPermissionProvider: MockAVPrivacyPermissionProvider!
    
    override func setUp() {
        super.setUp()
        mockPermissionProvider = MockAVPrivacyPermissionProvider()
        repository = StandardPrivacyPermissionRepository(avPrivacyPermissionProvider: mockPermissionProvider)
    }
    
    override func tearDown() {
        super.tearDown()
        mockPermissionProvider = nil
        repository = nil
    }
    
    func test_status_SHOULD_callProvider() {
        XCTAssertEqual(repository.status(of: .audio), mockPermissionProvider.statusResult)
        XCTAssertEqual(mockPermissionProvider.numOfAskForPermissionCalled, 1)
    }
    
    func test_askForPermission_SHOULD_callProvider() {
        mockPermissionProvider.askForPermissionResult = true
        repository.askForPermission(.audio) { isGranted in
            guard isGranted else {
                XCTFail("Should return true")
                return
            }
        }
        XCTAssertEqual(mockPermissionProvider.numOfAskForPermissionCalled, 1)
    }
}
