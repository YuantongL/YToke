//
//  StandardWindowManager.swift
//  YToke
//
//  Created by Lyt on 2020/8/12.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa
import Foundation

final class StandardWindowManager: NSObject, WindowManager {
    
    static let defaultManager: WindowManager = StandardWindowManager()
    
    private var onCloseHandlers: [String: (() -> Void)] = [:]
    
    func showWindow(with viewController: NSViewController, title: String, onClose: (() -> Void)?) {
        let window = NSWindow(contentViewController: viewController)
        window.delegate = self
        window.title = title
        let windowController = NSWindowController(window: window)
        windowController.showWindow(nil)
        
        if let onClose = onClose {
            onCloseHandlers[title] = onClose
        }
    }
}

extension StandardWindowManager: NSWindowDelegate {
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        onCloseHandlers[sender.title]?()
        return true
    }
}
