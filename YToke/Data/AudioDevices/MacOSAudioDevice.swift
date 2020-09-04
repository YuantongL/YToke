//
//  MacOSAudioDevice.swift
//  YToke
//
//  Created by Lyt on 9/1/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AVFoundation
import Foundation

final class MacOSAudioDevice {
    
    let audioDeviceID: AudioDeviceID
    
    init(audioDeviceID: AudioDeviceID) {
        self.audioDeviceID = audioDeviceID
    }
    
    var hasInput: Bool {
        var address = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioDevicePropertyStreamConfiguration),
            mScope: AudioObjectPropertyScope(kAudioDevicePropertyScopeInput),
            mElement: 0)
        
        var propertySize: UInt32 = UInt32(MemoryLayout<CFString?>.size)
        guard AudioObjectGetPropertyDataSize(audioDeviceID, &address, 0, nil, &propertySize) == 0 else {
            return false
        }
        
        let bufferList = UnsafeMutablePointer<AudioBufferList>.allocate(capacity: Int(propertySize))
        guard AudioObjectGetPropertyData(audioDeviceID, &address, 0, nil, &propertySize, bufferList) == 0 else {
            return false
        }
        
        let buffers = UnsafeMutableAudioBufferListPointer(bufferList)
        for bufferNum in 0..<buffers.count where buffers[bufferNum].mNumberChannels > 0 {
            return true
        }
        return false
    }
    
    var uid: String? {
        var address = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioDevicePropertyDeviceUID),
            mScope: AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))
        
        var name: CFString?
        var propertySize: UInt32 = UInt32(MemoryLayout<CFString?>.size)
        guard AudioObjectGetPropertyData(audioDeviceID, &address, 0, nil, &propertySize, &name) == 0 else {
            return nil
        }
        return name as String?
    }

    var name: String? {
        var address = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioDevicePropertyDeviceNameCFString),
            mScope: AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))
        
        var name: CFString?
        var propertySize: UInt32 = UInt32(MemoryLayout<CFString?>.size)
        guard AudioObjectGetPropertyData(audioDeviceID, &address, 0, nil, &propertySize, &name) == 0 else {
            return nil
        }
        return name as String?
    }
}
