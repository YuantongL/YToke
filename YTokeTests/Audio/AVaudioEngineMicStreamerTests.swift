//
//  AVaudioEngineMicStreamerTests.swift
//  YTokeTests
//
//  Created by Lyt on 8/30/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import XCTest

@testable import YToke

final class AVaudioEngineMicStreamerTests: XCTestCase {
    
    private var sut: AVAudioEngineMicStreamer!
    private var permissionRepository: MockPrivacyPermissionRepository!
    
    override func setUp() {
        super.setUp()
        permissionRepository = MockPrivacyPermissionRepository()
        sut = AVAudioEngineMicStreamer(privacyPermissionRepository: permissionRepository)
    }
    
    override func tearDown() {
        super.tearDown()
        permissionRepository = nil
        sut = nil
    }
    
    func test_startStreaming_SHOULD_askForPermission() {
        sut.startStreaming { _ in }
        XCTAssertEqual(permissionRepository.numOfStatusCalled, 1)
    }
    
    func test_startStreaming_SHOULD_failIfNotGranted() {
        permissionRepository.statusResult = .notGranted
        sut.startStreaming { result in
            guard case .failure = result else {
                XCTFail("Should return failure with error")
                return
            }
        }
    }
    
    func test_startStreaming_SHOULD_askForPermissionIfNotDetermined() {
        permissionRepository.statusResult = .notDetermined
        permissionRepository.askForPermissionResult = true
        sut.startStreaming { result in
            guard case .success = result else {
                XCTFail("Should return success")
                return
            }
            XCTAssertEqual(self.permissionRepository.numOfAskForPermissionCalled, 1)
        }
    }
}
