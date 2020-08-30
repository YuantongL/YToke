//
//  StandardPopUpAlertManager.swift
//  YToke
//
//  Created by Lyt on 8/29/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AppKit
import Foundation

final class StandardPopUpAlertManager: PopUpAlertManager {
    
    private var isRunningTest: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    func show(error: Error) {
        guard !isRunningTest else {
            return
        }
        
        DispatchQueue.main.async {
            let alert = NSAlert(error: error)
            alert.runModal()
        }
    }
    
    func show(message: String) {
        guard !isRunningTest else {
            return
        }
        
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.addButton(withTitle: NSLocalizedString("ok", comment: "OK"))
            alert.messageText = message
            alert.alertStyle = .informational
            alert.runModal()
        }
    }
}
