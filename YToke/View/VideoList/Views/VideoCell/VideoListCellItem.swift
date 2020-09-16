//
//  VideoListCellItem.swift
//  YToke
//
//  Created by Lyt on 2020/7/21.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa
import Foundation

final class VideoListCellItem: NSCollectionViewItem {
    
    private var cellView: VideoListCellView?
    
    override func loadView() {
        let newView = VideoListCellView()
        cellView = newView
        view = newView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure(_ config: VideoListCellConfig) {
        cellView?.configure(config)
    }
}
