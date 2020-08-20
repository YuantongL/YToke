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
    
    func onAppear()
}
