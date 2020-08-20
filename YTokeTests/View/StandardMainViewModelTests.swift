//
//  StandardMainViewModelTests.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class StandardMainViewModelTests: XCTestCase {
    
    private var viewModel: StandardMainViewModel!
    private var mockDependencyContainer: MockDependencyContainer!
    
    override func setUp() {
        super.setUp()
        mockDependencyContainer = MockDependencyContainer()
        viewModel = StandardMainViewModel(dependencyContainer: mockDependencyContainer)
    }
    
    override func tearDown() {
        super.tearDown()
        mockDependencyContainer = nil
        viewModel = nil
    }
    
    func test_init_SHOULD_subscribe_audioChange() {
        XCTAssertEqual(mockDependencyContainer.mockAudioMixer.numOfSubscribeChangesCalled, 1)
    }
    
    func test_mixerVolumeChange_SHOULD_setStreamer() {
        mockDependencyContainer.mockAudioMixer.onSubscribeChanges = [AudioChanel.voice: 100]
        _ = StandardMainViewModel(dependencyContainer: mockDependencyContainer)
        XCTAssertEqual(mockDependencyContainer.mockMicStreamer.numOfVolumeSet, 1)
    }
    
    func test_onAppear_SHOULD_startMicStreaming() {
        viewModel.onAppear()
        XCTAssertEqual(mockDependencyContainer.mockMicStreamer.numOfStartStreamingCalled, 1)
    }
    
    func test_SHOULD_NOT_showFirstDonationView_ON_10thSong() {
        var result = 0
        viewModel.onPresentDonationView = { _ in
            result += 1
        }
        for _ in 0..<10 {
            NotificationCenter.default.post(name: .queuePop, object: nil)
        }
        NotificationCenter.default.post(name: .addSong, object: nil)
        XCTAssertEqual(result, 0)
    }
    
    func test_SHOULD_showFirstDonationView_ON_11thSong() {
        var result = 0
        viewModel.onPresentDonationView = { _ in
            result += 1
        }
        for _ in 0..<11 {
            NotificationCenter.default.post(name: .queuePop, object: nil)
        }
        NotificationCenter.default.post(name: .addSong, object: nil)
        XCTAssertEqual(result, 1)
    }
    
    func test_SHOULD_showSecondDonationView_ON_31stSong() {
        var result = 0
        viewModel.onPresentDonationView = { _ in
            result += 1
        }
        for _ in 0..<11 {
            NotificationCenter.default.post(name: .queuePop, object: nil)
        }
        NotificationCenter.default.post(name: .addSong, object: nil)
        XCTAssertEqual(result, 1)
        
        for _ in 0..<20 {
            NotificationCenter.default.post(name: .queuePop, object: nil)
        }
        NotificationCenter.default.post(name: .addSong, object: nil)
        XCTAssertEqual(result, 2)
    }
    
}
