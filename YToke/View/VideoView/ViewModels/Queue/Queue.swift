//
//  Queue.swift
//  YToke
//
//  Created by Lyt on 2020/7/22.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol Queue {
    associatedtype Value
    
    var queue: [Value] { get set }
    func next() -> Value?
    func add(_: Value)
    func moveToTop(_: Value)
    func delete(_: Value)
}
