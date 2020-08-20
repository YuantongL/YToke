//
//  MockMicStreamer.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

@testable import YToke

final class MockMicStreamer: MicStreamer {
    
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
    func startStreaming() {
        numOfStartStreamingCalled += 1
    }
    
    var numOfStopStreamingCalled = 0
    func stopStreaming() {
        numOfStopStreamingCalled += 1
    }
    
}