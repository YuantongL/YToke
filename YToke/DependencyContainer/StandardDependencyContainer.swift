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
                      avPrivacyPermissionProvider: MacOSAVPrivacyPermissionProvider())
    }()

    let repo: RepositoryContainer
    
    let micStreamer: MicStreamer
    
    let audioMixer = AudioMixer()
    let audioDeviceManager: AudioDevicesManager = MacOSAudioDevicesManager()
    let videoQueue = VideoQueue()
    
    init() {
        // swiftlint:disable:next line_length
        let videoStreamingRepository = StandardVideoStreamingRepository(videoStreamingProvider: data.videoStreamingProvider)
        let videoListRepository = StandardVideoListRepository(videoListProvider: data.videoListProvider)
        
        // swiftlint:disable:next line_length
        let privacyPermissionRepository = StandardPrivacyPermissionRepository(avPrivacyPermissionProvider: data.avPrivacyPermissionProvider)
        repo = RepositoryContainer(videoStreamingRepository: videoStreamingRepository,
                                   videoListRepository: videoListRepository,
                                   privacyPermissionRepository: privacyPermissionRepository,
                                   alertManager: StandardPopUpAlertManager(),
                                   systemNavigator: MacOSSystemNavigator())
        
        //micStreamer = AudioKitMicStreamer()
        micStreamer = AVAudioEngineMicStreamer(privacyPermissionRepository: repo.privacyPermissionRepository)
    }
    
}
