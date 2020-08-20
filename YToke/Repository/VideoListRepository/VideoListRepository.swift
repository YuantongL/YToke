//
//  VideoListRepository.swift
//  YToke
//
//  Created by Lyt on 2020/7/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol VideoListRepository {
    
    typealias VideoListResult = Result<[Video], Error>
    
    func fetch(name: String, page: Int, onCompletion: @escaping (VideoListResult) -> Void)
}
