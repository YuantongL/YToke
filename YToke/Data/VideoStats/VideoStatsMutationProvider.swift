//
//  VideoStatsMutationProvider.swift
//  YToke
//
//  Created by Lyt on 9/14/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

/// Report video stats information to the backend
protocol VideoStatsMutationProvider {
    
    func reportTag(videoId: String, tag: VideoTag)
    
    func reportImpression(videoId: String, percentage: Double)
    
}
