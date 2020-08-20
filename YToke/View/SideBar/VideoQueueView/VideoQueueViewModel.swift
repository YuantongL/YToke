//
//  VideoQueueViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/7/29.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol VideoQueueViewModel {
    var videos: [Video] { get }
    
    var onReload: (() -> Void)? { get set }
    var onMoveToTop: ((Int) -> Void)? { get set }
    var onDeleteRow: ((Int) -> Void)? { get set }
    
    func onMoveToTopTap(video: Video)
    func onDeleteTap(video: Video)
}
