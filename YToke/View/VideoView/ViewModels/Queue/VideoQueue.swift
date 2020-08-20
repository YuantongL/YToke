//
//  VideoQueue.swift
//  YToke
//
//  Created by Lyt on 2020/7/29.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

class VideoQueue: Queue {
    
    var queue: [Video] {
        get {
            memory
        }
        set {
           memory = newValue
        }
    }
    
    @CodableUserDefault(key: "video_queue", defaultValue: [])
    private var memory: [Video]
    
    func add(_ video: Video) {
        memory.append(video)
        NotificationCenter.default.post(name: .addSong, object: nil)
    }
    
    func next() -> Video? {
        guard !memory.isEmpty else {
            return nil
        }
        let video = memory.removeFirst()
        let info = ["PopedVideo": video]
        NotificationCenter.default.post(name: .queuePop, object: nil, userInfo: info)
        return video
    }
    
    func moveToTop(_ video: Video) {
        guard let index = memory.firstIndex(of: video) else {
            return
        }
        memory.removeAll { (queuedVideo) -> Bool in
            queuedVideo == video
        }
        
        memory.insert(video, at: 0)
        let info = ["FromIndex": index]
        NotificationCenter.default.post(name: .moveToTop, object: nil, userInfo: info)
    }
    
    func index(of video: Video) -> Int? {
        memory.firstIndex(of: video)
    }
    
    func delete(_ video: Video) {
        memory.removeAll { $0 == video }
        let info = ["VideoId": video.id]
        NotificationCenter.default.post(name: .deleteSong, object: nil, userInfo: info)
    }
}
