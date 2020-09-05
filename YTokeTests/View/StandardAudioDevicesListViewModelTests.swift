//
//  StandardAudioDevicesListViewModelTests.swift
//  YTokeTests
//
//  Created by Lyt on 9/4/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class StandardAudioDevicesListViewModelTest: XCTestCase {
    
    private var viewModel: StandardAudioDevicesListViewModel!
    private var audioInputRepository: MockAudioInputRepository!
    
    override func setUp() {
        super.setUp()
        audioInputRepository = MockAudioInputRepository()
        viewModel = StandardAudioDevicesListViewModel(audioInputRepository: audioInputRepository)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_init_SHOULD_setItems() {
        XCTAssertTrue(audioInputRepository.numOfDevicesCalled == 1)
    }
    
    func test_onSystemDeviceChange_SHOULD_updateItems() {
        audioInputRepository.numOfDevicesCalled = 0
        NotificationCenter.default.post(name: .audioInputDevicesChanged, object: nil)
        XCTAssertEqual(audioInputRepository.numOfDevicesCalled, 1)
    }
    
    func test_onDeviceStateChange_SHOULD_setActiveDevice_ifSucceed() {
        audioInputRepository.numOfDevicesCalled = 0
        viewModel.onDeviceStateChange(device: AudioDevice(id: 1, uid: "1", name: "name", isOn: false),
                                      isToggled: true)
        XCTAssertEqual(audioInputRepository.numOfDevicesCalled, 1)
    }
    
    func test_onDeviceStateChange_SHOULD_reset_ifNotToggled() {
        audioInputRepository.numOfDevicesCalled = 0
        viewModel.onDeviceStateChange(device: AudioDevice(id: 1, uid: "1", name: "name", isOn: false),
                                      isToggled: false)
        XCTAssertEqual(audioInputRepository.numOfDevicesCalled, 1)
    }
    
    func test_onDeviceStateChange_SHOULD_reset_ifFailed() {
        audioInputRepository.numOfDevicesCalled = 0
        audioInputRepository.setActiveDevicesResult = .failure(AudioInputManagerError.unableToStream)
        viewModel.onDeviceStateChange(device: AudioDevice(id: 1, uid: "1", name: "name", isOn: false),
                                      isToggled: true)
        XCTAssertEqual(audioInputRepository.numOfDevicesCalled, 1)
    }
}
