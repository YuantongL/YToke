//
//  MockVideoQueue.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

@testable import YToke

final class MockVideoQueue: VideoQueue {
    var numOfAddCalled = 0
    override func add(_ video: Video) {
        numOfAddCalled += 1
    }
    
    var numOfNextCalled = 0
    var nextResult: Video?
    override func next() -> Video? {
        numOfNextCalled += 1
        return nextResult
    }
    
    var numOfMoveToTopCalled = 0
    override func moveToTop(_ video: Video) {
        numOfMoveToTopCalled += 1
    }
    
    var numOfGetQueueCalled = 0
    override var queue: [Video] {
        get {
            numOfGetQueueCalled += 1
            return memory
        }
        set {
            memory = newValue
        }
    }
    private var memory: [Video] = []
    
    var numOfIndexOfCalled = 0
    var indexOfResult: Int?
    override func index(of video: Video) -> Int? {
        numOfIndexOfCalled += 1
        return indexOfResult
    }
    
    var numOfDeleteCalled = 0
    override func delete(_ video: Video) {
        numOfDeleteCalled += 1
    }
    
}
