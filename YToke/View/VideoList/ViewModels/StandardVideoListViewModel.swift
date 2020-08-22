//
//  StandardVideoListViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/7/21.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa
import Foundation
import os.log

final class StandardVideoListViewModel: VideoListViewModel {
    
    var onUpdate: (() -> Void)?
    var videos: [VideoListVideo] = [] {
        didSet {
            onUpdate?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            onLoadingSpinnerHiddenChange?(!isLoading)
        }
    }
    var onLoadingSpinnerHiddenChange: ((Bool) -> Void)?
    
    var isLoadingSectionHidden: Bool = true {
        didSet {
            onLoadingSectionHiddenChange?(isLoadingSectionHidden)
        }
    }
    var onLoadingSectionHiddenChange: ((Bool) -> Void)?
    
    var onErrorLabelHiddenChange: ((Bool) -> Void)?
    
    private let videolistRepository: VideoListRepository
    private let videoQueue: VideoQueue
    private let onPresentDonationView: () -> Void
    
    init(dependencyContainer: DependencyContainer, onPresentDonationView: @escaping () -> Void) {
        self.videolistRepository = dependencyContainer.repo.videoListRepository
        self.videoQueue = dependencyContainer.videoQueue
        self.onPresentDonationView = onPresentDonationView
    }
    
    func onTapDonation() {
        // We probably need a navigator or coordinator
        onPresentDonationView()
    }
    
    func onTapSearch(keyword: String) {
        fetchVideoList(keyword: keyword)
    }
    
    func onTapAddVideo(_ video: Video) {
        videoQueue.add(video)
        
        videos = videos.map {
            if $0.video == video {
                return VideoListVideo(video: video, isAdded: true)
            } else {
                return $0
            }
        }
    }
    
    func onScrollToBottom() {
        fetchFollowingPagesVideoList()
    }
    
    private func fetchVideoList(keyword: String) {
        shouldFetchFollowingPages = false
        currentPage = 1
        lastSearchedKeyword = keyword
        videos = []
        isLoading = true
        onErrorLabelHiddenChange?(true)
        
        videolistRepository.fetch(name: keyword, page: 1) { [weak self] result in
            self?.isLoading = false
            self?.shouldFetchFollowingPages = true
            switch result {
            case .success(let videos):
                self?.videos = videos.map {
                    VideoListVideo(video: $0, isAdded: false)
                }
            case .failure(let error):
                self?.handleError(error: error)
            }
        }
    }
    
    private var lastSearchedKeyword: String?
    private var shouldFetchFollowingPages = true
    private var currentPage = 1
    private func fetchFollowingPagesVideoList() {
        guard shouldFetchFollowingPages, let keyword = lastSearchedKeyword else {
            return
        }
        shouldFetchFollowingPages = false
        currentPage += 1
        isLoadingSectionHidden = false
        onErrorLabelHiddenChange?(true)
                
        videolistRepository.fetch(name: keyword, page: currentPage) { [weak self] result in
            self?.shouldFetchFollowingPages = true
            self?.isLoadingSectionHidden = true
            switch result {
            case .success(let videos):
                self?.videos += videos.map {
                    VideoListVideo(video: $0, isAdded: false)
                }
            case .failure(let error):
                self?.handleError(error: error)
            }
        }
    }
    
    private func handleError(error: Error) {
        os_log(.debug, "Error fetch videos with error %s", error.localizedDescription)
        onErrorLabelHiddenChange?(false)
    }
}
