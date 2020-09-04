//
//  AudioInputManager.swift
//  YToke
//
//  Created by Lyt on 9/1/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

enum AudioInputManagerError: Error {
    case permissionNotGranted
    case unableToStream
}

protocol AudioInputManager {
    
    /// A list of audio input devices to select with their status
    func devices() -> [AudioDevice]
    
    /// Set devices as input device by giving a list of devices
    func setActiveDevices(_: [AudioDevice], completion: @escaping (Result<Void, Error>) -> Void)
    
}
