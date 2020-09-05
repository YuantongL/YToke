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
    
    func test_isPermissionInformationHidden() {
        dependencyContainer.mockPrivacyPermissionRepository.statusResult = .granted
        XCTAssertTrue(viewModel.isPermissionInformationHidden)
        
        dependencyContainer.mockPrivacyPermissionRepository.statusResult = .notDetermined
        XCTAssertFalse(viewModel.isPermissionInformationHidden)
        
        dependencyContainer.mockPrivacyPermissionRepository.statusResult = .notGranted
        XCTAssertFalse(viewModel.isPermissionInformationHidden)
    }
    
    func test_isAudioDevicesListHidden() {
        dependencyContainer.mockPrivacyPermissionRepository.statusResult = .granted
        XCTAssertFalse(viewModel.isAudioDevicesListHidden)
        
        dependencyContainer.mockPrivacyPermissionRepository.statusResult = .notDetermined
        XCTAssertTrue(viewModel.isAudioDevicesListHidden)
        
        dependencyContainer.mockPrivacyPermissionRepository.statusResult = .notGranted
        XCTAssertTrue(viewModel.isAudioDevicesListHidden)
    }
    
    func test_isMicrophoneVolumeControlHidden() {
        dependencyContainer.mockPrivacyPermissionRepository.statusResult = .granted
        XCTAssertFalse(viewModel.isMicrophoneVolumeControlHidden)
        
        dependencyContainer.mockPrivacyPermissionRepository.statusResult = .notDetermined
        XCTAssertTrue(viewModel.isMicrophoneVolumeControlHidden)
        
        dependencyContainer.mockPrivacyPermissionRepository.statusResult = .notGranted
        XCTAssertTrue(viewModel.isMicrophoneVolumeControlHidden)
    }
    
    func test_setVideoVolume_SHOULD_setMixer() {
        viewModel.setVideoVolume(to: 98)
        XCTAssertEqual(dependencyContainer.mockAudioMixer.numOfSetChanelCalled, 1)
    }
    
    func test_setVoiceVolume_SHOULD_set_Mixer() {
        viewModel.setVoiceVolume(to: 98)
        XCTAssertEqual(dependencyContainer.mockAudioMixer.numOfSetChanelCalled, 1)
    }
    
}
