//
//  AudioDevice.swift
//  YToke
//
//  Created by Lyt on 9/4/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

struct AudioDevice: Hashable {
    let id: UInt32
    let uid: String
    let name: String?
    var isOn: Bool
    
    static func == (lhs: AudioDevice, rhs: AudioDevice) -> Bool {
        lhs.id == rhs.id
    }
}
