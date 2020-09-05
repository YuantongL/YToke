//
//  CoreAudioInputRepository.swift
//  YToke
//
//  Created by Lyt on 9/1/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

final class CoreAudioInputRepository: AudioInputRepository {
    
    private var currentSelectedDevice: AudioDevice?
    
    private var devicesManager: AudioDevicesProvider
    private let microphoneProvider: MicrophoneProvider
    private let alertProvider: PopUpAlertProvider
    private let privacyPermissionRepository: PrivacyPermissionRepository
    
    init(devicesManager: AudioDevicesProvider,
         microphoneProvider: MicrophoneProvider,
         alertProvider: PopUpAlertProvider,
         // TODO: Move this to a provider
         privacyPermissionRepository: PrivacyPermissionRepository) {
        self.alertProvider = alertProvider
        self.devicesManager = devicesManager
        self.microphoneProvider = microphoneProvider
        self.privacyPermissionRepository = privacyPermissionRepository
        
        // Set default input as the initial input device
        if let initialDevice = devicesManager.inputDevices().first(where: { $0.isOn }) {
            setActiveDevices(initialDevice) { [weak self] result in
                if case .failure(let error) = result {
                    self?.handleError(error)
                }
            }
        }
        
        self.devicesManager.onInputDevicesChange = { [weak self] in
            // If the current selected device is unplugged, default to the first input device
            if let currentSelectedDevice = self?.currentSelectedDevice {
                let newDevicesList = devicesManager.inputDevices()
                if !newDevicesList.contains(currentSelectedDevice), let firstDevice = newDevicesList.first {
                    self?.setActiveDevices(firstDevice) { result in
                        if case .success = result {
                            self?.currentSelectedDevice = firstDevice
                        }
                    }
                }
            }
            
            self?.handleInputDeviceChange()
        }
    }
    
    func devices() -> [AudioDevice] {
        devicesManager.inputDevices()
    }
    
    private func handleInputDeviceChange() {
        NotificationCenter.default.post(name: .audioInputDevicesChanged, object: nil)
    }
    
    func setActiveDevices(_ device: AudioDevice, completion: @escaping (Result<Void, Error>) -> Void) {
        checkForAudioPermission { [weak self] error in
            if let error = error {
                self?.handleError(error)
                completion(.failure(error))
            } else {
                do {
                    try self?.devicesManager.setDeviceAsDefaultInput(device)
                    try self?.microphoneProvider.startStreaming()
                    self?.currentSelectedDevice = device
                    completion(.success(()))
                } catch {
                    self?.handleError(error)
                    completion(.failure(error))
                }
            }
        }
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
            alertProvider.show(message: message)
        } else {
            alertProvider.show(error: error)
        }
    }
}
