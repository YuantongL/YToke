//
//  AVAuthorizationStatus+Extensions.swift
//  YToke
//
//  Created by Lyt on 8/29/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AVFoundation
import Foundation

extension AVAuthorizationStatus {
    var status: PrivacyPermissionStatus {
        switch self {
        case .authorized:
            return .granted
        case .denied, .restricted:
            return .notGranted
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .notGranted
        }
    }
}
