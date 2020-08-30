//
//  MockSystemNavigator.swift
//  YTokeTests
//
//  Created by Lyt on 8/30/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
@testable import YToke

final class MockSystemNavigator: SystemNavigator {
    
    var numOfOpenPrivacySettingsCalled = 0
    func openPrivacySettings() {
        numOfOpenPrivacySettingsCalled += 1
    }
    
}
