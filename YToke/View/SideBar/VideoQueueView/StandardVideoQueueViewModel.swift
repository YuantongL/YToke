//
//  StandardVideoQueueViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/7/29.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

final class StandardVideoQueueViewModel: VideoQueueViewModel {
    
    var videos: [Video]
    var onReload: (() -> Void)?
    
    var onMoveToTop: ((Int) -> Void)?
    var onDeleteRow: ((Int) -> Void)?
    
    private let videoQueue: VideoQueue
    
    init(dependencyContainer: DependencyContainer) {
        self.videoQueue = dependencyContainer.videoQueue
        self.videos = videoQueue.queue
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onQueuePop),
                                               name: .queuePop,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onSongAdded),
                                               name: .addSong,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onSongMoveToTop(notification:)),
                                               name: .moveToTop,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDeleteSong(notification:)),
                                               name: .deleteSong,
                                               object: nil)
    }
    
    func onMoveToTopTap(video: Video) {
        videoQueue.moveToTop(video)
    }
    
    func onDeleteTap(video: Video) {
        videoQueue.delete(video)
    }
    
    @objc private func onQueuePop() {
        videos = videoQueue.queue
        onReload?()
    }
    
    @objc private func onSongAdded() {
        videos = videoQueue.queue
        onReload?()
    }
    
    @objc private func onSongMoveToTop(notification: Notification) {
        guard let index = (notification.userInfo as? [String: Int])?["FromIndex"] else {
            return
        }
        videos = videoQueue.queue
        onMoveToTop?(index)
    }
    
    @objc private func onDeleteSong(notification: Notification) {
        guard let videoId = (notification.userInfo as? [String: String])?["VideoId"] else {
            return
        }
        guard let index = videos.firstIndex(where: { $0.id == videoId }) else {
            return
        }
        onDeleteRow?(index)
        videos = videoQueue.queue
    }
}
