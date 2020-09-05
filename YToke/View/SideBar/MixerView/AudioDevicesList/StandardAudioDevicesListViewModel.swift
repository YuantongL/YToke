//
//  StandardAudioDevicesListViewModel.swift
//  YToke
//
//  Created by Lyt on 8/31/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

final class StandardAudioDevicesListViewModel: AudioDevicesListViewModel {
    
    var items: [AudioDevice] {
        didSet {
            onItemsUpdate?()
        }
    }
    var onItemsUpdate: (() -> Void)?
    private let audioInputRepository: AudioInputRepository
    
    private var audioObserver: NSObjectProtocol?
    
    init(audioInputRepository: AudioInputRepository) {
        self.audioInputRepository = audioInputRepository
        
        items = audioInputRepository.devices()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onSystemDeviceChange),
                                               name: .audioInputDevicesChanged,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .audioInputDevicesChanged, object: nil)
    }
    
    private func resetDevicesList() {
        let updatedList = audioInputRepository.devices()
        var result: [AudioDevice] = []
        for updatedItem in updatedList where items.contains(updatedItem) {
            result.append(updatedItem)
        }
        for unlistedItem in updatedList where !items.contains(unlistedItem) {
            result.append(unlistedItem)
        }
        items = result
    }
    
    @objc private func onSystemDeviceChange() {
        resetDevicesList()
    }
    
    func onDeviceStateChange(device: AudioDevice, isToggled: Bool) {
        guard isToggled else {
            resetDevicesList()
            return
        }
        audioInputRepository.setActiveDevices(device) { [weak self] _ in
            self?.resetDevicesList()
        }
    }
}
