//
//  StandardPrivacyPermissionRepository.swift
//  YToke
//
//  Created by Lyt on 8/29/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

final class StandardPrivacyPermissionRepository: PrivacyPermissionRepository {
    
    private let avPrivacyPermissionProvider: AVPrivacyPermissionProvider
    
    init(avPrivacyPermissionProvider: AVPrivacyPermissionProvider) {
        self.avPrivacyPermissionProvider = avPrivacyPermissionProvider
    }
    
    func status(of permissionType: PrivacyPermissionType) -> PrivacyPermissionStatus {
        switch permissionType {
        case .audio:
            return avPrivacyPermissionProvider.status(of: .audio)
        }
    }
    
    func askForPermission(_ permissionType: PrivacyPermissionType, completionHandler: @escaping (Bool) -> Void) {
        switch permissionType {
        case .audio:
            avPrivacyPermissionProvider.askForPermission(.audio, completionHandler: completionHandler)
        }
    }
}
