//
//  MicrophoneProvider.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

@testable import YToke

final class MockMicrophoneProvider: MicrophoneProvider {
    
    var numOfIsEnabledSet = 0
    var isEnabled: Bool = false {
        didSet {
            numOfIsEnabledSet += 1
        }
    }
    
    var numOfVolumeSet = 0
    var volume: Float = 0.0 {
        didSet {
            numOfVolumeSet += 1
        }
    }
    
    var numOfStartStreamingCalled = 0
    var startStreamingResult: Result<Void, Error> = .success(())
    func startStreaming() throws {
        numOfStartStreamingCalled += 1
        if case .failure(let error) = startStreamingResult {
            throw error
        }
    }
    
    var numOfStopStreamingCalled = 0
    func stopStreaming() {
        numOfStopStreamingCalled += 1
    }
    
}
