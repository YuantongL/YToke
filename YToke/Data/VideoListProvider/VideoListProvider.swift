//
//  VideoListProvider.swift
//  YToke
//
//  Created by Lyt on 2020/7/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol VideoListProvider {
    
    typealias VideoListProviderResult = Result<[Video], Error>
    
    /// Fetch list of video ids relative to the query string
    func fetch(query: String, page: Int, onCompletion: @escaping (VideoListProviderResult) -> Void)
}
