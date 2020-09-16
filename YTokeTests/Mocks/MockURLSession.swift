//
//  MockURLSession.swift
//  YTokeTests
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

final class MockURLSession: URLSession {
    var numOfDataTaskCalled = 0
    var requestURL: URL?
    var response: URLResponse?
    var data: Data?
    var error: Error?
    var httpBody: Data?
    
    override func dataTask(with request: URLRequest,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        numOfDataTaskCalled += 1
        requestURL = request.url
        httpBody = request.httpBody
        completionHandler(data, response, error)
        return URLSessionDataTaskMock {}
    }
    
    override func dataTask(with request: URLRequest) -> URLSessionDataTask {
        numOfDataTaskCalled += 1
        requestURL = request.url
        httpBody = request.httpBody
        return URLSessionDataTaskMock {}
    }
    
    init(response: URLResponse?) {
        self.response = response
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}
