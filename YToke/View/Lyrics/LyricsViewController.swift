//
//  LyricsViewController.swift
//  YToke
//
//  Created by Lyt on 9/28/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AppKit
import Foundation

struct LyricsViewConfig {
    let songName: String
    let singerName: String?
    let lyrics: String
}

final class LyricsViewController: NSViewController {
    
    private let viewModel: LyricsViewModel
    
    init(viewModel: LyricsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        setupLayout()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
    }
    
    private func setupBinding() {
        
    }
}
