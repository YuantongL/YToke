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
    let avPrivacyPermissionProvider: AVPrivacyPermissionProvider
}

struct RepositoryContainer {
    let videoStreamingRepository: VideoStreamingRepository
    let videoListRepository: VideoListRepository
    let privacyPermissionRepository: PrivacyPermissionRepository
    let alertManager: PopUpAlertManager
    let systemNavigator: SystemNavigator
}

protocol DependencyContainer {
    var data: DataContainer { get }
    var repo: RepositoryContainer { get }
    var audioMixer: AudioMixer { get }
    var videoQueue: VideoQueue { get }
    var micStreamer: MicStreamer { get }
}
