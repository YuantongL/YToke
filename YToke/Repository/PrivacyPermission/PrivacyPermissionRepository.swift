//
//  PrivacyPermissionRepository.swift
//  YToke
//
//  Created by Lyt on 8/29/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

enum PrivacyPermissionType {
    case audio
}

enum PrivacyPermissionStatus {
    case granted
    case notGranted
    case notDetermined
}

protocol PrivacyPermissionRepository {
    func status(of: PrivacyPermissionType) -> PrivacyPermissionStatus
    func askForPermission(_ :PrivacyPermissionType, completionHandler: @escaping (Bool) -> Void)
}
