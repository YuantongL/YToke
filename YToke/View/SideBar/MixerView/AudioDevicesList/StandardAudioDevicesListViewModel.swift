//
//  StandardAudioDevicesListViewModel.swift
//  YToke
//
//  Created by Lyt on 8/31/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

final class StandardAudioDevicesListViewModel: AudioDevicesListViewModel {
    
    var items: [AudioDevice: Bool] {
        didSet {
            onItemsUpdate?()
        }
    }
    var onItemsUpdate: (() -> Void)?
    private let audioInputManager: AudioInputManager
    
    private var audioObserver: NSObjectProtocol?
    
    init(audioInputManager: AudioInputManager) {
        self.audioInputManager = audioInputManager
        
        var tempDevices: [AudioDevice: Bool] = [:]
        for device in audioInputManager.devices() {
            if device.isOn {
                tempDevices[device] = true
            } else {
                tempDevices[device] = false
            }
        }
        items = tempDevices
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onSystemDeviceChange),
                                               name: .audioInputDevicesChanged,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .audioInputDevicesChanged, object: nil)
    }
    
    @objc private func onSystemDeviceChange() {
        let updatedDevices = audioInputManager.devices()
        var tempDevices: [AudioDevice: Bool] = [:]
        for device in updatedDevices {
            if items.keys.contains(device) {
                tempDevices[device] = items[device]
            } else {
                tempDevices[device] = false
            }
        }
        items = tempDevices
    }
    
    func onDeviceStateChange(device: AudioDevice, isToggled: Bool) {
        items[device] = isToggled
        let selectedDevices = items.filter { isOn -> Bool in
            isOn.value
        }
        audioInputManager.setActiveDevices(Array(selectedDevices.keys)) { result in
            if case .failure = result {
                // TODO: Untoggle
            }
        }
    }
}
