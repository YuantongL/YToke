//
//  NSImage+Extensions.swift
//  YToke
//
//  Created by Lyt on 2020/8/4.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa
import Foundation

extension NSImage {
    convenience init(color: NSColor, size: NSSize) {
        self.init(size: size)
        lockFocus()
        color.drawSwatch(in: NSRect(origin: .zero, size: size))
        unlockFocus()
    }
}
