//
//  AVAudioEngineMicrophoneProvider.swift
//  YToke
//
//  Created by Lyt on 2020/7/31.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AVFoundation
import Foundation

final class AVAudioEngineMicrophoneProvider: MicrophoneProvider {
    
    var isEnabled: Bool {
        audioEngine?.isRunning ?? false
    }
    
    var volume: Float = 0 {
        didSet {
            // We want to normalize it to -24db ~ 24db range
            let convertedVolume = volume * 24.0 * 2.0 - 24.0
            volumeEffect?.globalGain = Float(convertedVolume)
        }
    }
    
    private var audioEngine: AVAudioEngine?
    private var volumeEffect: AVAudioUnitEQ?
    private var currentAggregateDeviceId: AudioDeviceID?
    
    init() {}
    
    private func prepareToStream() {
        audioEngine = AVAudioEngine()
        volumeEffect = AVAudioUnitEQ()
        
        guard let audioEngine = audioEngine,
            let volumeEffect = volumeEffect else {
            return
        }
        
        let unitEffect = AVAudioUnitReverb()
        unitEffect.wetDryMix = 50
        
        audioEngine.attach(unitEffect)
        audioEngine.attach(volumeEffect)
        
        let defaultFormat = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 2) ?? AVAudioFormat()
        audioEngine.connect(audioEngine.inputNode, to: unitEffect, format: defaultFormat)
        audioEngine.connect(unitEffect, to: volumeEffect, format: defaultFormat)
        audioEngine.connect(volumeEffect, to: audioEngine.outputNode, format: defaultFormat)
        
        audioEngine.prepare()
    }
    
    func startStreaming() throws {
        stopStreaming()
        prepareToStream()
//try audioEngine?.start()
    }
    
    func stopStreaming() {
        audioEngine?.stop()
        audioEngine?.reset()
        audioEngine = nil
    }
}
