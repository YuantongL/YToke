//
//  AudioDevicesListViewModel.swift
//  YToke
//
//  Created by Lyt on 8/31/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol AudioDevicesListViewModel {
    var items: [AudioDevice] { get }
    var onItemsUpdate: (() -> Void)? { get set }
    
    func onDeviceStateChange(device: AudioDevice, isToggled: Bool)
}
