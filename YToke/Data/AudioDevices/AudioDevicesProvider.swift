//
//  AudioDevicesProvider.swift
//  YToke
//
//  Created by Lyt on 8/31/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol AudioDevicesProvider {
    
    var onInputDevicesChange: (() -> Void)? { get set }
    
    /// All input devices, not including aggregate device
    func inputDevices() -> [AudioDevice]
    
    func setDeviceAsDefaultInput(_: AudioDevice) throws
    
}
