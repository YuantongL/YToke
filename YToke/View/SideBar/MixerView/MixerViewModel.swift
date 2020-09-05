//
//  MixerViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/7/28.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol MixerViewModel {
    
    var isPermissionInformationHidden: Bool { get }
    var permissionInformationViewModel: AudioPermissionInformationViewModel { get }
    
    var isAudioDevicesListHidden: Bool { get }
    var audioDevicesListViewModel: AudioDevicesListViewModel { get }
    
    var videoVolume: Float { get }
    var onVideoVolumeChange: ((Float) -> Void)? { get set }
    
    var voiceVolume: Float { get }
    var onVoiceVolumeChange: ((Float) -> Void)? { get set }
    var isMicrophoneVolumeControlHidden: Bool { get }
    
    func onAppear()
    
    func setVideoVolume(to: Float)
    func setVoiceVolume(to: Float)
}
