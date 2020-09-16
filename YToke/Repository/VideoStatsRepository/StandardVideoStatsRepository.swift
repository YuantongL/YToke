//
//  StandardVideoStatsRepository.swift
//  YToke
//
//  Created by Lyt on 9/14/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

final class StandardVideoStatsRepository: VideoStatsRepository {
    
    private let videoStatsMutationProvider: VideoStatsMutationProvider
    
    init(videoStatsMutationProvider: VideoStatsMutationProvider) {
        self.videoStatsMutationProvider = videoStatsMutationProvider
    }
    
    func reportTag(videoId: String, tag: VideoTag) {
        videoStatsMutationProvider.reportTag(videoId: videoId, tag: tag)
    }
    
    func reportImpression(videoId: String, percentage: Double) {
        videoStatsMutationProvider.reportImpression(videoId: videoId, percentage: percentage)
    }
    
}
