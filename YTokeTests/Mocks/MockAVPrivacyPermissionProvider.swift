//
//  MockAVPrivacyPermissionProvider.swift
//  YTokeTests
//
//  Created by Lyt on 8/29/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
@testable import YToke

final class MockAVPrivacyPermissionProvider: AVPrivacyPermissionProvider {
    
    var numOfStatusCalled = 0
    var statusResult: PrivacyPermissionStatus = .granted
    func status(of: MediaType) -> PrivacyPermissionStatus {
        numOfStatusCalled += 1
        return statusResult
    }
    
    var numOfAskForPermissionCalled = 0
    var askForPermissionResult = true
    func askForPermission(_: MediaType, completionHandler: @escaping (Bool) -> Void) {
        numOfAskForPermissionCalled += 1
        completionHandler(askForPermissionResult)
    }
}
