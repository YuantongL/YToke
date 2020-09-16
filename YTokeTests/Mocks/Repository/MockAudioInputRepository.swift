//
//  MockAudioInputRepository.swift
//  YTokeTests
//
//  Created by Lyt on 9/4/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

@testable import YToke

final class MockAudioInputRepository: AudioInputRepository {
    
    var numOfDevicesCalled = 0
    var devicesResult: [AudioDevice] = []
    func devices() -> [AudioDevice] {
        numOfDevicesCalled += 1
        return devicesResult
    }
    
    var numOfSetActiveDevicesCalled = 0
    var setActiveDevicesResult: Result<Void, Error> = .success(())
    func setActiveDevices(_: AudioDevice, completion: @escaping (Result<Void, Error>) -> Void) {
        numOfSetActiveDevicesCalled += 1
        completion(setActiveDevicesResult)
    }
    
}
