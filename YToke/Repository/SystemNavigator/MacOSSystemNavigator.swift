//
//  MacOSSystemNavigator.swift
//  YToke
//
//  Created by Lyt on 8/29/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AppKit
import Foundation

final class MacOSSystemNavigator: SystemNavigator {
    func openPrivacySettings() {
        let url = URL(fileURLWithPath: "/System/Library/PreferencePanes/Security.prefPane")
        NSWorkspace.shared.open(url)
    }
}
