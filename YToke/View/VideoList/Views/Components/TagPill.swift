//
//  TagPill.swift
//  YToke
//
//  Created by Lyt on 9/15/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AppKit
import Foundation

final class TagPill: NSView {
    
    private lazy var label: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.maximumNumberOfLines = 1
        label.isSelectable = false
        label.isEditable = false
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.alignment = .center
        label.usesSingleLineMode = false
        return label
    }()
    
    init(text: String, backgroundColor: NSColor) {
        super.init(frame: .zero)
        setupLayout()
        
        wantsLayer = true
        label.stringValue = text
        layer?.backgroundColor = backgroundColor.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6)
        ])
    }
    
    override func layout() {
        super.layout()
        layer?.cornerRadius = self.bounds.height / 2
    }
}
