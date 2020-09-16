//
//  VideoViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/7/22.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol VideoViewModel {
    
    var isLoadingSpinnerHidden: ((Bool) -> Void)? { get set }
    var streamURL: ((URL) -> Void)? { get set }
    var cycleText: String? { get }
    var volume: ((Float) -> Void)? { get set }
    
    var currentTime: (() -> Double?)? { get set }
    var videoDuration: (() -> Double?)? { get set }
    
    var dualChoiceTitle: String { get }
    var dualChoiceTitleA: String { get }
    var dualChoiceContentA: VideoTag { get }
    var dualChoiceTitleB: String { get }
    var dualChoiceContentB: VideoTag { get }
    var showDualChoiceView: (() -> Void)? { get set }
    var hideDualChoiceView: (() -> Void)? { get set }
    
    func onAppear()
    func onDualChoiceViewSelect(tag: VideoTag?)
    func onVideoPlayedHalf()
}
