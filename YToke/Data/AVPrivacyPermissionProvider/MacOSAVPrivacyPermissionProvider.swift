//
//  MacOSAVPrivacyPermissionProvider.swift
//  YToke
//
//  Created by Lyt on 8/29/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AVFoundation
import Foundation

final class MacOSAVPrivacyPermissionProvider: AVPrivacyPermissionProvider {
    
    func status(of mediaType: MediaType) -> PrivacyPermissionStatus {
        AVCaptureDevice.authorizationStatus(for: mediaType.avMediaType).status
    }
    
    func askForPermission(_ mediaType: MediaType, completionHandler: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: mediaType.avMediaType) { isGranted in
            completionHandler(isGranted)
        }
    }
    
}

private extension MediaType {
    var avMediaType: AVMediaType {
        switch self {
        case .audio:
            return .audio
        }
    }
}
