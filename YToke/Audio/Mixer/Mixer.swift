//
//  Mixer.swift
//  YToke
//
//  Created by Lyt on 2020/7/28.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol Mixer: AnyObject {
    associatedtype Chanel: Hashable
    associatedtype Value
    associatedtype Token
    
    typealias ChangeHandler = ([Chanel: Value]) -> Void
    
    func setChanel(_ chanel: Chanel, value: Value)
    func subscribeChanges(onChange: @escaping ChangeHandler) -> Token
    func unsubscribe(token: Token)
    
    func value(of: Chanel) -> Value?
}
