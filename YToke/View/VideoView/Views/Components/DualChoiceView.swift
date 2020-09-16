//
//  DualChoiceView.swift
//  YToke
//
//  Created by Lyt on 9/14/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AppKit
import Foundation

final class DualChoiceView<T>: NSControl {
    
    struct Content {
        let title: String
        let content: T?
    }
    
    private let title: String
    private let contentA: Content
    private let contentB: Content
    
    private lazy var titleLabel: NSTextField = {
        let textField = NSTextField(labelWithString: title)
        textField.font = .systemFont(ofSize: 16)
        textField.alignment = .center
        textField.isEditable = false
        textField.isSelectable = false
        textField.lineBreakMode = .byWordWrapping
        return textField
    }()
    
    private lazy var buttonA: NSButton = {
        let button = NSButton(title: contentA.title,
                              target: self,
                              action: #selector(aSelected))
        return button
    }()
    
    private lazy var buttonB: NSButton = {
        let button = NSButton(title: contentB.title,
                              target: self,
                              action: #selector(bSelected))
        return button
    }()
    
    private let onSelect: (T?) -> Void
    
    init(title: String,
         contentA: Content,
         contentB: Content,
         onSelect: @escaping (T?) -> Void) {
        self.title = title
        self.contentA = contentA
        self.contentB = contentB
        self.onSelect = onSelect
        
        super.init(frame: .zero)
        
        setupLayout()
        
        layer?.cornerRadius = 10.0
        wantsLayer = true
        layer?.backgroundColor = .init(gray: 0.5, alpha: 0.7)
        layer?.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
        
        addSubview(buttonA)
        buttonA.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonA.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            buttonA.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
            buttonA.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            buttonA.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -4)
        ])
        
        addSubview(buttonB)
        buttonB.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonB.leadingAnchor.constraint(equalTo: buttonA.trailingAnchor, constant: 8),
            buttonB.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            buttonB.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -8),
            buttonB.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    @objc private func aSelected() {
        onSelect(contentA.content)
    }
    
    @objc private func bSelected() {
        onSelect(contentB.content)
    }
}
