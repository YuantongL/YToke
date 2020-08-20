//
//  VideoListViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/7/17.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

struct VideoListVideo {
    let video: Video
    var isAdded: Bool
}

protocol VideoListViewModel {
    var videos: [VideoListVideo] { get }
    var onUpdate: (() -> Void)? { get set }
    
    var isLoading: Bool { get }
    var onLoadingSpinnerHiddenChange: ((Bool) -> Void)? { get set }
    
    var isLoadingSectionHidden: Bool { get }
    var onLoadingSectionHiddenChange: ((Bool) -> Void)? { get set }
    
    var onErrorLabelHiddenChange: ((Bool) -> Void)? { get set }
    
    func onTapDonation()
    func onTapSearch(keyword: String)
    func onTapAddVideo(_ video: Video)
    
    func onScrollToBottom()
}
