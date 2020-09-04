//
//  MacOSAudioDevicesManager.swift
//  YToke
//
//  Created by Lyt on 8/31/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import CoreAudio
import AVFoundation
import Foundation
import AppKit

enum MacOSAudioDevicesManagerError: Error {
    case unableToCreateAggregateDevice
    case unableToDestroyAggregrateDevice
}

final class MacOSAudioDevicesManager: AudioDevicesManager {
    
    private var aggregateDeviceSubDevices: [AudioDevice] = []
    
    var onInputDevicesChange: (() -> Void)?
    
    private var defaultAggregateDeviceUID = "YToke.AggregateDevice.ID"
    private var defaultAggregateDeviceName = "YToke Multi-Input Device"
    private var currentAggregateDeviceID: AudioDeviceID?
    
    private var defaultAudioInputDevice: AudioDeviceID? {
        var audioInputDeviceId: AudioDeviceID = 0
        var audioInputAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultInputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMaster)
        
        var propertySize = UInt32(MemoryLayout.size(ofValue: audioInputDeviceId))
        if AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject),
                                      &audioInputAddress,
                                      0,
                                      nil,
                                      &propertySize,
                                      &audioInputDeviceId) != kAudioHardwareNoError {
            return nil
        }
      
        return audioInputDeviceId
    }
    
    init() {
        listenToDeviceChange()
    }
    
    deinit {
        var address: AudioObjectPropertyAddress = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioHardwarePropertyDevices),
            mScope: AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))
        AudioObjectRemovePropertyListenerBlock(AudioObjectID(kAudioObjectSystemObject),
                                               &address,
                                               .main) { _, _ in }
    }
    
    private func listenToDeviceChange() {
        var address: AudioObjectPropertyAddress = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioHardwarePropertyDevices),
            mScope: AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))
        let status = AudioObjectAddPropertyListenerBlock(AudioObjectID(kAudioObjectSystemObject),
                                            &address,
                                            .main) { [weak self] _, _ in
                                                self?.onInputDevicesChange?()
        }
        guard status == 0 else {
            print("Error in listen to audio device change")
            return
        }
    }
        
    private func getDevices() -> [MacOSAudioDevice] {
        var propertySize: UInt32 = 0

        var address: AudioObjectPropertyAddress = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioHardwarePropertyDevices),
            mScope: AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))

        guard AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject),
                                             &address,
                                             UInt32(MemoryLayout<AudioObjectPropertyAddress>.size),
                                             nil,
                                             &propertySize) == 0 else {
                                                return []
        }
        
        let numberOfDevices = Int(propertySize / UInt32(MemoryLayout<AudioDeviceID>.size))
        var deviceIds = Array(repeating: AudioDeviceID(), count: numberOfDevices)
        guard AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject),
                                         &address,
                                         0,
                                         nil,
                                         &propertySize,
                                         &deviceIds) == 0 else {
                                            return []
        }
        
        let macOSAudioDevices = (0..<numberOfDevices).map { i in
            MacOSAudioDevice(audioDeviceID: deviceIds[i])
        }
        return macOSAudioDevices
    }
    
    /// All input devices
    private func allInputDevices() -> [AudioDevice] {
        getDevices()
            .filter { $0.hasInput }
            .compactMap { macOSDevice -> AudioDevice? in
                guard let uid = macOSDevice.uid else {
                    return nil
                }
                let isDefaultDevice = macOSDevice.audioDeviceID == defaultAudioInputDevice
                let aggregateContainsDevice = aggregateDeviceSubDevices.map { $0.uid }.contains(uid)
                return AudioDevice(id: macOSDevice.audioDeviceID,
                                   uid: uid,
                                   name: macOSDevice.name,
                                   isOn: isDefaultDevice || aggregateContainsDevice)
        }
    }
    
    /// All input devices not including aggregate device
    func inputDevices() -> [AudioDevice] {
        let result = allInputDevices()
            .filter { $0.uid != defaultAggregateDeviceUID }
        return result
    }
    
    func deleteExistingAggregateDevice() {
        guard let existingDeviceID = getDevices()
            .first(where: { $0.uid == defaultAggregateDeviceUID })?.audioDeviceID else {
            return
        }
        
        let statusCode = AudioHardwareDestroyAggregateDevice(existingDeviceID)
        guard statusCode == 0 else {
            // TODO: Log
            print(statusCode)
            return
        }
        
        aggregateDeviceSubDevices = []
    }
    
    func createAggregateDevice(with devices: [AudioDevice]) throws -> AudioDevice {        
        guard let firstDevice = devices.first else {
            throw MacOSAudioDevicesManagerError.unableToCreateAggregateDevice
        }
        
        let subDevicesList: [[String: Any]] = devices.map { device in
            [kAudioSubDeviceUIDKey: device.uid as CFString,
             kAudioSubDeviceDriftCompensationKey: 1]
        }
        
        let desc: [String: Any] = [
            kAudioAggregateDeviceNameKey: defaultAggregateDeviceName,
            kAudioAggregateDeviceUIDKey: defaultAggregateDeviceUID,
            kAudioAggregateDeviceSubDeviceListKey: subDevicesList,
            kAudioAggregateDeviceMasterSubDeviceKey: firstDevice.uid,
            kAudioAggregateDeviceClockDeviceKey: firstDevice.uid
            // TODO: Uncomment
            //kAudioAggregateDeviceIsPrivateKey: 1
        ]

        var aggregateDeviceId: AudioDeviceID = 0
        let status = AudioHardwareCreateAggregateDevice(desc as CFDictionary, &aggregateDeviceId)
        guard status == 0 else {
            throw MacOSAudioDevicesManagerError.unableToCreateAggregateDevice
        }
        currentAggregateDeviceID = aggregateDeviceId
        
        aggregateDeviceSubDevices = devices
        
        return AudioDevice(id: aggregateDeviceId,
                           uid: defaultAggregateDeviceUID,
                           name: defaultAggregateDeviceName,
                           isOn: false)
    }
    
    func setDeviceAsDefaultInput(_ device: AudioDevice) throws {
        var deviceId = device.id
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultInputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMaster
        )
        
        let statusCode = AudioObjectSetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &address,
            0,
            nil,
            UInt32(MemoryLayout<AudioDeviceID>.size),
            &deviceId
        )
        
        guard statusCode == 0 else {
            throw AudioInputManagerError.unableToStream
        }
    }
}
