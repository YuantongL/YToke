//
//  WindowManager.swift
//  YToke
//
//  Created by Lyt on 2020/8/12.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa
import Foundation

protocol WindowManager {
    /// Present a new window with a UNIQUE string title
    func showWindow(with viewController: NSViewController, title: String, onClose: (() -> Void)?)
}
