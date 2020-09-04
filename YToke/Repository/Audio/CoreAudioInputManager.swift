//
//  CoreAudioInputManager.swift
//  YToke
//
//  Created by Lyt on 9/1/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

final class CoreAudioInputManager: AudioInputManager {
    
    private var cachedSelectedDevices: [AudioDevice] = []
    
    private var devicesManager: AudioDevicesManager
    private let micStreamer: MicStreamer
    private let alertManager: PopUpAlertManager
    private let privacyPermissionRepository: PrivacyPermissionRepository
    
    init(devicesManager: AudioDevicesManager,
         micStreamer: MicStreamer,
         alertManager: PopUpAlertManager,
         privacyPermissionRepository: PrivacyPermissionRepository) {
        self.alertManager = alertManager
        self.devicesManager = devicesManager
        self.micStreamer = micStreamer
        self.privacyPermissionRepository = privacyPermissionRepository
        
        //devicesManager.deleteExistingAggregateDevice()
        
        // Set default input as the initial input device
//        cachedSelectedDevices = devicesManager.inputDevices().filter { $0.isOn }
//        setActiveDevices(cachedSelectedDevices) { [weak self] result in
//            if case .failure(let error) = result {
//                self?.handleError(error)
//            }
//        }
        
        self.devicesManager.onInputDevicesChange = { [weak self] in
            self?.handleInputDeviceChange()
        }
    }
    
    func devices() -> [AudioDevice] {
        devicesManager.inputDevices()
    }
    
    private func handleInputDeviceChange() {
        NotificationCenter.default.post(name: .audioInputDevicesChanged, object: nil)
    }
    
    func setActiveDevices(_ devices: [AudioDevice], completion: @escaping (Result<Void, Error>) -> Void) {
        checkForAudioPermission { [weak self] error in
            if let error = error {
                self?.handleError(error)
            } else {
                do {
                    try self?.createAggregateDeviceThenStream(devices: devices)
                } catch {
                    self?.handleError(error)
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func createAggregateDeviceThenStream(devices: [AudioDevice]) throws {
//        devicesManager.deleteExistingAggregateDevice()
//        guard !devices.isEmpty else {
//            return
//        }
//        guard let aggregrateDevice = try? devicesManager.createAggregateDevice(with: devices) else {
//            throw AudioInputManagerError.unableToStream
//        }
//        try devicesManager.setDeviceAsDefaultInput(aggregrateDevice)
        try micStreamer.startStreaming()
    }
    
    private func checkForAudioPermission(completion: @escaping (Error?) -> Void) {
        switch privacyPermissionRepository.status(of: .audio) {
        case .granted:
            completion(nil)
        case .notGranted:
            completion(AudioInputManagerError.permissionNotGranted)
        case .notDetermined:
            privacyPermissionRepository.askForPermission(.audio) { isGranted in
                if isGranted {
                    completion(nil)
                } else {
                    completion(AudioInputManagerError.permissionNotGranted)
                }
            }
        }
    }
    
    private func handleError(_ error: Error) {
        if case AudioInputManagerError.permissionNotGranted = error {
            let message = NSLocalizedString("permission_request_microphone",
            // swiftlint:disable:next line_length
            comment: "If you are willing to use Microphone, please head to System Settings and grant YToke~ microphone permission")
            alertManager.show(message: message)
        } else {
            alertManager.show(error: error)
        }
    }
}
