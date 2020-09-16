//
//  MockPopUpAlertProvider.swift
//  YTokeTests
//
//  Created by Lyt on 8/30/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
@testable import YToke

final class MockPopUpAlertProvider: PopUpAlertProvider {
    
    var numOfShowErrorCalled = 0
    func show(error: Error) {
        numOfShowErrorCalled += 1
    }
    
    var numOfShowMessageCalled = 0
    func show(message: String) {
        numOfShowMessageCalled += 1
    }
}
