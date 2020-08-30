//
//  MicStreamer.swift
//  YToke
//
//  Created by Lyt on 2020/7/16.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol MicStreamer {
    var isEnabled: Bool { get }
    var volume: Float { get set }
    func startStreaming(completion: @escaping (Result<Void, Error>) -> Void)
    func stopStreaming()
}
