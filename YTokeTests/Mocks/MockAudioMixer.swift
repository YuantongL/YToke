//
//  MockAudioMixer.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

@testable import YToke

final class MockAudioMixer: AudioMixer {
    
    var numOfSetChanelCalled = 0
    override func setChanel(_ chanel: AudioChanel, value: Float) {
        numOfSetChanelCalled += 1
    }
    
    var numOfSubscribeChangesCalled = 0
    var subscribeToken = 0
    var onSubscribeChanges: [AudioChanel: Float]?
    override func subscribeChanges(onChange: @escaping AudioMixer.ChangeHandler) -> Int {
        numOfSubscribeChangesCalled += 1
        
        if let changes = onSubscribeChanges {
            onChange(changes)
        }
        
        return subscribeToken
    }
    
    var numOfUnsubscribeCalled = 0
    override func unsubscribe(token: Int) {
        numOfUnsubscribeCalled += 1
    }
    
    var numOfValueCalled = 0
    var value: Float?
    override func value(of chanel: AudioChanel) -> Float? {
        numOfValueCalled += 1
        return value
    }
}
