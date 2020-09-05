//
//  MicrophoneProvider.swift
//  YToke
//
//  Created by Lyt on 2020/7/16.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol MicrophoneProvider {
    
    /// Is microphone streaming currently enabled
    var isEnabled: Bool { get }
    
    /// The audio volume set in scale of 0 - 1
    var volume: Float { get set }
    
    /// Start microphone stream with a system default audio input
    func startStreaming() throws
    
    /// Stops microphone streaming
    func stopStreaming()
    
}
