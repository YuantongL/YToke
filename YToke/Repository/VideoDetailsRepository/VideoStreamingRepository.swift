//
//  VideoStreamingRepository.swift
//  YToke
//
//  Created by Lyt on 2020/7/30.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol VideoStreamingRepository {
    func fetchStreamURL(id: String, onCompletion: @escaping (Result<URL, Error>) -> Void)
}
