//
//  PopUpAlertProvider.swift
//  YToke
//
//  Created by Lyt on 8/29/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

protocol PopUpAlertProvider {
    func show(error: Error)
    func show(message: String)
}
