//
//  StandardMixerViewModelTests.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/12.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class StandardMixerViewModelTests: XCTestCase {
    
    private var viewModel: StandardMixerViewModel!
    private var dependencyContainer: MockDependencyContainer!
    
    override func setUp() {
        super.setUp()
        dependencyContainer = MockDependencyContainer()
        viewModel = StandardMixerViewModel(dependencyContainer: dependencyContainer)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencyContainer = nil
        viewModel = nil
    }
    
    func test_onAppear_SHOULD_setVolume() {
        viewModel.onAppear()
        XCTAssertEqual(dependencyContainer.mockAudioMixer.numOfValueCalled, 2)
    }
    
    func test_onAppear_SHOULD_setToggleState() {
        dependencyContainer.mockMicStreamer.isEnabled = true
        dependencyContainer.mockPrivacyPermissionRepository.statusResult = .granted
        viewModel.onAppear()
        XCTAssertEqual(viewModel.toggleState, true)
    }
    
    func test_onAppear_SHOULD_setToggleState_micIsNotEnabled() {
        dependencyContainer.mockMicStreamer.isEnabled = false
        dependencyContainer.mockPrivacyPermissionRepository.statusResult = .granted
        viewModel.onAppear()
        XCTAssertEqual(viewModel.toggleState, false)
    }
    
    func test_onAppear_SHOULD_setToggleState_noPermission() {
        dependencyContainer.mockMicStreamer.isEnabled = true
        dependencyContainer.mockPrivacyPermissionRepository.statusResult = .notGranted
        viewModel.onAppear()
        XCTAssertEqual(viewModel.toggleState, false)
    }
    
    func test_setVideoVolume_SHOULD_setMixer() {
        viewModel.setVideoVolume(to: 98)
        XCTAssertEqual(dependencyContainer.mockAudioMixer.numOfSetChanelCalled, 1)
    }
    
    func test_setVoiceVolume_SHOULD_set_Mixer() {
        viewModel.setVoiceVolume(to: 98)
        XCTAssertEqual(dependencyContainer.mockAudioMixer.numOfSetChanelCalled, 1)
    }
    
    func test_toggle_SHOULD_startMicSteramer() {
        viewModel.setToggleState(state: true)
        XCTAssertEqual(dependencyContainer.mockMicStreamer.numOfStartStreamingCalled, 1)
    }
    
    func test_startMicStreamer_SHOULD_showAlertIfFailed() {
        // swiftlint:disable:next line_length
        dependencyContainer.mockMicStreamer.startStreamingResult = .failure(AVAudioEngineMicStreamerError.permissionNotGranted)
        viewModel.setToggleState(state: true)
        XCTAssertEqual(dependencyContainer.mockPopupAlertManager.numOfShowMessageCalled, 1)
    }
    
    func test_toggle_SHOULD_stopMicSteramer() {
        viewModel.setToggleState(state: false)
        XCTAssertEqual(dependencyContainer.mockMicStreamer.numOfStopStreamingCalled, 1)
    }
    
}
