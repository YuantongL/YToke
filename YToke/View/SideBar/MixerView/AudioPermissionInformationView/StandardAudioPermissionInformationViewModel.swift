//
//  StandardAudioPermissionInfoViewModel.swift
//  YToke
//
//  Created by Lyt on 8/29/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

final class StandardAudioPermissionInfoViewModel: AudioPermissionInformationViewModel {
    
    var description: String {
        // swiftlint:disable:next line_length
        let comment = "YToke~ does not have microphone access. If you want to use microphone stream, please go to system Settings menu and grant microphone access"
        return NSLocalizedString("audio_permission_information", comment: comment)
    }
    
    private let systemNavigator: SystemNavigator
    
    init(systemNavigator: SystemNavigator) {
        self.systemNavigator = systemNavigator
    }
    
    func onButtonTap() {
        systemNavigator.openPrivacySettings()
    }
}
