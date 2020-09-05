//
//  MockAudioDevicesProvider.swift
//  YTokeTests
//
//  Created by Lyt on 9/4/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

@testable import YToke

final class MockAudioDevicesProvider: AudioDevicesProvider {
    
    var onInputDevicesChange: (() -> Void)?
    
    var numOfInputDevicesCalled = 0
    var inputDevicesResult: [AudioDevice] = []
    func inputDevices() -> [AudioDevice] {
        numOfInputDevicesCalled += 1
        return inputDevicesResult
    }
    
    var numOfSetDeviceAsDefaultInputCalled = 0
    var setDeviceAsDefaultInputResult: Result<Void, Error> = .success(Void())
    func setDeviceAsDefaultInput(_: AudioDevice) throws {
        numOfSetDeviceAsDefaultInputCalled += 1
        if case .failure(let error) = setDeviceAsDefaultInputResult {
            throw error
        }
    }
    
}
