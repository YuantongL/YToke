//
//  VideoListLoadingCellItem.swift
//  YToke
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

final class VideoListLoadingCellItem: NSCollectionViewItem {

    private var cellView: VideoListLoadingCellView?
     
     override func loadView() {
         let newView = VideoListLoadingCellView()
         cellView = newView
         view = newView
     }
     
     override func viewDidLoad() {
         super.viewDidLoad()
     }
    
}
