//
//  NowPlayingViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/8/3.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol NowPlayingViewModel {
    var title: ((String) -> Void)? { get set }
    var image: ((URL) -> Void)? { get set }
    var isShowVideoButtonHidden: ((Bool) -> Void)? { get set }
    
    func onAppear()
    func onTapNext()
    func onTapShowVideo()
}
