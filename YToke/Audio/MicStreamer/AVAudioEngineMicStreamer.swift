//
//  AVAudioEngineMicStreamer.swift
//  YToke
//
//  Created by Lyt on 2020/7/31.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AVFoundation
import Foundation

enum AVAudioEngineMicStreamerError: Error {
    case permissionNotGranted
}

final class AVAudioEngineMicStreamer: MicStreamer {
    
    var isEnabled: Bool = false
    
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
    private let privacyPermissionRepository: PrivacyPermissionRepository
    
    init(privacyPermissionRepository: PrivacyPermissionRepository) {
        self.privacyPermissionRepository = privacyPermissionRepository
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
    
    func startStreaming(completion: @escaping (Result<Void, Error>) -> Void) {
        switch privacyPermissionRepository.status(of: .audio) {
        case .granted:
            startAudioEngineSteraming(completion: completion)
        case .notGranted:
            completion(.failure(AVAudioEngineMicStreamerError.permissionNotGranted))
        case .notDetermined:
            privacyPermissionRepository.askForPermission(.audio) { [weak self] isGranted in
                if isGranted {
                    self?.startAudioEngineSteraming(completion: completion)
                } else {
                    completion(.failure(AVAudioEngineMicStreamerError.permissionNotGranted))
                }
            }
        }
    }
    
    private func startAudioEngineSteraming(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try audioEngine.start()
            isEnabled = true
            completion(.success(Void()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func stopStreaming() {
        audioEngine.stop()
        isEnabled = false
    }
}
