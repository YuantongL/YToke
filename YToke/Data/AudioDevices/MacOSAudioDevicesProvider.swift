//
//  MacOSAudioDevicesProvider.swift
//  YToke
//
//  Created by Lyt on 8/31/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import CoreAudio
import AVFoundation
import Foundation
import AppKit

final class MacOSAudioDevicesProvider: AudioDevicesProvider {
    
    var onInputDevicesChange: (() -> Void)?
    
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
                return AudioDevice(id: macOSDevice.audioDeviceID,
                                   uid: uid,
                                   name: macOSDevice.name,
                                   isOn: macOSDevice.audioDeviceID == defaultAudioInputDevice)
        }
    }
    
    /// All input devices not including aggregate device
    func inputDevices() -> [AudioDevice] {
        allInputDevices()
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
