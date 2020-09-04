//
//  AudioDevicesManager.swift
//  YToke
//
//  Created by Lyt on 8/31/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

struct AudioDevice: Hashable {
    let id: UInt32
    let uid: String
    let name: String?
    var isOn: Bool
    
    static func == (lhs: AudioDevice, rhs: AudioDevice) -> Bool {
        lhs.id == rhs.id
    }
}

protocol AudioDevicesManager {
    
    var onInputDevicesChange: (() -> Void)? { get set }
    
    /// All input devices, not including aggregate device
    func inputDevices() -> [AudioDevice]
    
    func createAggregateDevice(with: [AudioDevice]) throws -> AudioDevice
    
    func deleteExistingAggregateDevice()
    
    func setDeviceAsDefaultInput(_: AudioDevice) throws
    
}
