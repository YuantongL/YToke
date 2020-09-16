//
//  VideoStatsRepository.swift
//  YToke
//
//  Created by Lyt on 9/14/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

/// Repository for reporting video stats
protocol VideoStatsRepository {
    
    /// Report video tagged
    func reportTag(videoId: String, tag: VideoTag)
    
    /// Report video played, with the percentage of finishing
    func reportImpression(videoId: String, percentage: Double)
}
