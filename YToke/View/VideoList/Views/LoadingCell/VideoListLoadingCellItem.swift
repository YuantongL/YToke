//
//  VideoListLoadingCellItem.swift
//  YToke
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

// TODO: Could generalize this
final class VideoListLoadingCellItem: NSCollectionViewItem {
    
    private var cellView: VideoListLoadingCellView?
     
    override func loadView() {
         let newView = VideoListLoadingCellView()
         cellView = newView
         view = newView
     }
}
