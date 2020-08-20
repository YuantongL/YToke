//
//  AudioMixer.swift
//  YToke
//
//  Created by Lyt on 2020/7/28.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

enum AudioChanel {
    case voice
    case video
}

class AudioMixer: Mixer {
    /// Value is in scale of 0.0 - 1.0
    typealias ChangeHandler = ([AudioChanel: Float]) -> Void
    
    private var memory: [AudioChanel: Float] = [:]
    private var listeners: [Token: ChangeHandler] = [:]
    private var token = 0
    
    func setChanel(_ chanel: AudioChanel, value: Float) {
        memory[chanel] = value
        for handler in listeners.values {
            handler([chanel: value])
        }
    }
    
    func subscribeChanges(onChange: @escaping ChangeHandler) -> Int {
        token += 1
        listeners[token] = onChange
        return token
    }
    
    func unsubscribe(token: Int) {
        listeners.removeValue(forKey: token)
    }
    
    func value(of chanel: AudioChanel) -> Float? {
        memory[chanel]
    }
}
