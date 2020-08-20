//
//  VideoStreamingProvider.swift
//  YToke
//
//  Created by Lyt on 2020/7/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol VideoStreamingProvider {
    func fetchStreamURL(id: String, onCompletion: @escaping (Result<URL, Error>) -> Void)
}
