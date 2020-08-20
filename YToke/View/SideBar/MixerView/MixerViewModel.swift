//
//  MixerViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/7/28.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol MixerViewModel {
    
    var toggleState: Bool { get }
    var videoVolume: Float { get }
    var onVideoVolumeChange: ((Float) -> Void)? { get set }
    var voiceVolume: Float { get }
    var onVoiceVolumeChange: ((Float) -> Void)? { get set }
    
    func onAppear()
    
    func setVideoVolume(to: Float)
    func setVoiceVolume(to: Float)
    func setToggleState(state: Bool)
}
