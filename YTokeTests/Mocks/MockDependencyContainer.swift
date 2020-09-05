//
//  MockDependencyContainer.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

@testable import YToke

final class MockDependencyContainer: DependencyContainer {
    
    let data: DataContainer
    let repo: RepositoryContainer
    
    var audioMixer: AudioMixer = MockAudioMixer()
    var videoQueue: VideoQueue = MockVideoQueue()
    
    init() {
        data = DataContainer(videoStreamingProvider: MockVideoStreamingProvider(),
                             videoListProvider: MockVideoListProvider(),
                             avPrivacyPermissionProvider: MockAVPrivacyPermissionProvider(),
                             popUpAlertProvider: MockPopUpAlertProvider(),
                             audioDevicesProvider: MockAudioDevicesProvider(),
                             microphoneProvider: MockMicrophoneProvider())
        
        repo = RepositoryContainer(videoStreamingRepository: MockVideoStreamingRepository(),
                                   videoListRepository: MockVideoListRepository(),
                                   privacyPermissionRepository: MockPrivacyPermissionRepository(),
                                   systemNavigator: MockSystemNavigator(),
                                   audioInputRepository: MockAudioInputRepository())
    }
}

// swiftlint:disable force_cast
extension MockDependencyContainer {
    var mockVideoStreamingProvider: MockVideoStreamingProvider {
        data.videoStreamingProvider as! MockVideoStreamingProvider
    }
    
    var mockVideoListProvider: MockVideoListProvider {
        data.videoListProvider as! MockVideoListProvider
    }
    
    var mockVideoStreamingRepository: MockVideoStreamingRepository {
        repo.videoStreamingRepository as! MockVideoStreamingRepository
    }
    
    var mockVideoListRepository: MockVideoListRepository {
        repo.videoListRepository as! MockVideoListRepository
    }
    
    var mockPrivacyPermissionRepository: MockPrivacyPermissionRepository {
        repo.privacyPermissionRepository as! MockPrivacyPermissionRepository
    }
    
    var mockAudioMixer: MockAudioMixer {
        audioMixer as! MockAudioMixer
    }
    
    var mockVideoQueue: MockVideoQueue {
        videoQueue as! MockVideoQueue
    }
    
    var mockMicrophoneProvider: MockMicrophoneProvider {
        data.microphoneProvider as! MockMicrophoneProvider
    }
    
    var alertProvider: MockPopUpAlertProvider {
        data.popUpAlertProvider as! MockPopUpAlertProvider
    }
}
