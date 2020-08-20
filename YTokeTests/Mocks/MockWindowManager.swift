//
//  MockWindowManager.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/12.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa
import Foundation

@testable import YToke

final class MockWindowManager: WindowManager {
    
    var numOfShowWindowCalled = 0
    var shouldCallOnClose = false
    func showWindow(with viewController: NSViewController, title: String, onClose: (() -> Void)?) {
        numOfShowWindowCalled += 1
        if shouldCallOnClose {
            onClose?()
        }
    }
    
}
