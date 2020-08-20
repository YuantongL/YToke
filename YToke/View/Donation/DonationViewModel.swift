//
//  DonationViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/8/10.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa
import Foundation

protocol DonationViewModel {
    var image: NSImage { get }
    var title: String { get }
    var subTitle: String { get }
    var hiddenTitle: String { get }
    var buttonImage: NSImage { get }
    func onTapButton()
}
