//
//  Video.swift
//  YToke
//
//  Created by Lyt on 2020/7/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

struct Video: Codable {
    let id: String
    let title: String
    let thumbnail: URL?
    let percentageFinished: Float?
    let tag: [VideoTag]?
}

extension Video: Equatable {
    static func == (lhs: Video, rhs: Video) -> Bool {
        lhs.id == rhs.id
    }
}
