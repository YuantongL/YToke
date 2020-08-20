//
//  AVAudioEngineMicStreamer.swift
//  YToke
//
//  Created by Lyt on 2020/7/31.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AVFoundation
import Foundation

final class AVAudioEngineMicStreamer: MicStreamer {
    
    var isEnabled: Bool = true
    
    /// The audio volume set in scale of 0 - 1
    var volume: Float = 0 {
        didSet {
            // We want to normalize it to -24db ~ 24db range
            let convertedVolume = volume * 24.0 * 2.0 - 24.0
            volumeEffect.globalGain = convertedVolume
        }
    }
    
    private let audioEngine = AVAudioEngine()
    private let volumeEffect = AVAudioUnitEQ()
    
    init() {
        volumeEffect.globalGain = volume
        
        prepareToStartStreaming()
    }
    
    private func prepareToStartStreaming() {
        let unitEffect = AVAudioUnitReverb()
        unitEffect.wetDryMix = 50

        audioEngine.attach(unitEffect)
        audioEngine.attach(volumeEffect)

        audioEngine.connect(audioEngine.inputNode, to: unitEffect, format: nil)
        audioEngine.connect(unitEffect, to: volumeEffect, format: nil)
        audioEngine.connect(volumeEffect, to: audioEngine.outputNode, format: nil)

        audioEngine.prepare()
    }
    
    func startStreaming() {
        do {
            try audioEngine.start()
            isEnabled = true
        } catch {
            isEnabled = false
        }
    }
    
    func stopStreaming() {
        audioEngine.stop()
        isEnabled = false
    }
}
