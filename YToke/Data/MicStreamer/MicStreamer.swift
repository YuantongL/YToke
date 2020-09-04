//
//  MicStreamer.swift
//  YToke
//
//  Created by Lyt on 2020/7/16.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

//enum MicStreamerSource {
//    case actualDevice(AudioDevice)
//    case aggregateDevice(AudioDevice)
//}

protocol MicStreamer {
    
    /// Is microphone streaming currently enabled
    var isEnabled: Bool { get }
    
    /// The audio volume set in scale of 0 - 1
    var volume: Float { get set }
    
    /// Start microphone stream with a system default audio input, you can also call this method to switch streaming devices
    func startStreaming() throws
    
    /// Stops microphone streaming
    func stopStreaming()
}
