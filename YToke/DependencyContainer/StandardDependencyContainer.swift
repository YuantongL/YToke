//
//  StandardDependencyContainer.swift
//  YToke
//
//  Created by Lyt on 8/29/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

struct StandardDependencyContainer: DependencyContainer {
    
    let data: DataContainer = {
        DataContainer(videoStreamingProvider: XCDYoutubeVideoStreamingProvider(),
                      videoListProvider: InvidiousAPIVideoListProvider(),
                      avPrivacyPermissionProvider: MacOSAVPrivacyPermissionProvider(),
                      popUpAlertProvider: StandardPopUpAlertProvider(),
                      audioDevicesProvider: MacOSAudioDevicesProvider(),
                      microphoneProvider: AVAudioEngineMicrophoneProvider())
    }()

    let repo: RepositoryContainer
    
    let audioMixer = AudioMixer()
    let audioDeviceManager: AudioDevicesProvider = MacOSAudioDevicesProvider()
    let videoQueue = VideoQueue()
    
    init() {
        // swiftlint:disable:next line_length
        let videoStreamingRepository = StandardVideoStreamingRepository(videoStreamingProvider: data.videoStreamingProvider)
        let videoListRepository = StandardVideoListRepository(videoListProvider: data.videoListProvider)
        
        // swiftlint:disable:next line_length
        let privacyPermissionRepository = StandardPrivacyPermissionRepository(avPrivacyPermissionProvider: data.avPrivacyPermissionProvider)
        let audioInputRepository = CoreAudioInputRepository(devicesManager: data.audioDevicesProvider,
                                                            microphoneProvider: data.microphoneProvider,
                                                            alertProvider: data.popUpAlertProvider,
                                                            privacyPermissionRepository: privacyPermissionRepository)
        repo = RepositoryContainer(videoStreamingRepository: videoStreamingRepository,
                                   videoListRepository: videoListRepository,
                                   privacyPermissionRepository: privacyPermissionRepository,
                                   systemNavigator: MacOSSystemNavigator(),
                                   audioInputRepository: audioInputRepository)
    }
    
}
