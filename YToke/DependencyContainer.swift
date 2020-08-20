//
//  DependencyContainer.swift
//  YToke
//
//  Created by Lyt on 2020/8/3.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

struct DataContainer {
    let videoStreamingProvider: VideoStreamingProvider
    let videoListProvider: VideoListProvider
}

struct RepositoryContainer {
    let videoStreamingRepository: VideoStreamingRepository
    let videoListRepository: VideoListRepository
}

protocol DependencyContainer {
    var data: DataContainer { get }
    var repo: RepositoryContainer { get }
    var audioMixer: AudioMixer { get }
    var videoQueue: VideoQueue { get }
    var micStreamer: MicStreamer { get }
}

struct StandardDependencyContainer: DependencyContainer {
    
    let data = DataContainer(videoStreamingProvider: XCDYoutubeVideoStreamingProvider(),
                             videoListProvider: InvidiousAPIVideoListProvider())
    
    let repo: RepositoryContainer
    
    let audioMixer = AudioMixer()
    let videoQueue = VideoQueue()
    let micStreamer: MicStreamer = AVAudioEngineMicStreamer()
    
    init() {
        // swiftlint:disable:next line_length
        let videoStreamingRepository = StandardVideoStreamingRepository(videoStreamingProvider: data.videoStreamingProvider)
        let videoListRepository = StandardVideoListRepository(videoListProvider: data.videoListProvider)
        repo = RepositoryContainer(videoStreamingRepository: videoStreamingRepository,
                                   videoListRepository: videoListRepository)
    }
    
}
