//
//  AVPrivacyPermissionProvider.swift
//  YToke
//
//  Created by Lyt on 8/29/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

enum MediaType {
    case audio
}

protocol AVPrivacyPermissionProvider {
    func status(of: MediaType) -> PrivacyPermissionStatus
    func askForPermission(_ :MediaType, completionHandler: @escaping (Bool) -> Void)
}
