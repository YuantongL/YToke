//
//  Notification+Extensions.swift
//  YToke
//
//  Created by Lyt on 2020/7/22.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    /// A song is picked and added to the queue
    static let addSong = Notification.Name(rawValue: "add-song")
    
    /// The queue poped a song out of the queue
    static let queuePop = Notification.Name(rawValue: "queue-pop")
    
    /// A song is moved to the top of the queue
    static let moveToTop = Notification.Name(rawValue: "move-to-top")
    
    /// A song is skipped
    static let skipSong = Notification.Name(rawValue: "skip-song")
    
    /// A song is deleted
    static let deleteSong = Notification.Name(rawValue: "delete-song")
    
    /// System's audio input devices changed
    static let audioInputDevicesChanged = Notification.Name(rawValue: "audio-input-devices-change")
    
    /// Video player's current song played half progress
    static let songPlayProgressHalf = Notification.Name(rawValue: "song-play-progress-half")
    
    /// Video finished streaming and the video starts to play
    static let videoPlayerStartPlayback = Notification.Name(rawValue: "video-player-start-playback")
}
