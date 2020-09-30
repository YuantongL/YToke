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
    
    // MARK: - Data
    let mockVideoStreamingProvider = MockVideoStreamingProvider()
    let mockVideoListProvider = MockVideoListProvider()
    let mockMicrophoneProvider = MockMicrophoneProvider()
    let mockAlertProvider = MockPopUpAlertProvider()
    let mockAudioDevicesProvider = MockAudioDevicesProvider()
    let mockVideoStatsMutationProvider = MockVideoStatsMutationProvider()
    let mockLyricsURLProvider = MockLyricsURLProvider()
    let mockLyricsDataProvider = MockLyricsDataProvider()
    
    // MARK: - Repository
    
    let mockVideoStreamingRepository = MockVideoStreamingRepository()
    let mockVideoListRepository = MockVideoListRepository()
    let mockPrivacyPermissionRepository = MockPrivacyPermissionRepository()
    let mockVideoStatsRepository = MockVideoStatsRepository()
    let mockLyricsRepository = MockLyricsRepository()
    
    // MARK: - Init
    
    init() {
        data = DataContainer(videoStreamingProvider: mockVideoStreamingProvider,
                             videoListProvider: mockVideoListProvider,
                             avPrivacyPermissionProvider: MockAVPrivacyPermissionProvider(),
                             popUpAlertProvider: mockAlertProvider,
                             audioDevicesProvider: mockAudioDevicesProvider,
                             microphoneProvider: mockMicrophoneProvider,
                             videoStatsMutationProvider: mockVideoStatsMutationProvider,
                             lyricsURLProvider: mockLyricsURLProvider,
                             lyricsDataProvider: mockLyricsDataProvider)
        
        repo = RepositoryContainer(videoStreamingRepository: mockVideoStreamingRepository,
                                   videoListRepository: mockVideoListRepository,
                                   privacyPermissionRepository: mockPrivacyPermissionRepository,
                                   systemNavigator: MockSystemNavigator(),
                                   audioInputRepository: MockAudioInputRepository(),
                                   videoStatsRepository: mockVideoStatsRepository,
                                   lyricsRepository: mockLyricsRepository)
    }
}

// swiftlint:disable force_cast
extension MockDependencyContainer {
    
    var mockAudioMixer: MockAudioMixer {
        audioMixer as! MockAudioMixer
    }
    
    var mockVideoQueue: MockVideoQueue {
        videoQueue as! MockVideoQueue
    }
}
