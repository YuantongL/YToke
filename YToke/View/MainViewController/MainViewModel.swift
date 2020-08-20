//
//  MainViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/8/10.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol MainViewModel {
    var videoListViewModel: VideoListViewModel { get }
    var nowPlayingViewModel: NowPlayingViewModel { get }
    var dependencyContainer: DependencyContainer { get }
    
    var onPresentDonationView: ((DonationViewModel) -> Void)? { get set }
    
    func onAppear()
}
