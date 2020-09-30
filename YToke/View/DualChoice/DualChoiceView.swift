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
    
    private lazy var titleLabel: NSTextField = {
        let textField = NSTextField(labelWithString: viewModel.question)
        textField.font = .systemFont(ofSize: 16)
        textField.alignment = .center
        textField.isEditable = false
        textField.isSelectable = false
        textField.lineBreakMode = .byWordWrapping
        return textField
    }()
    
    private lazy var subtitleLabel: NSTextField = {
        let textField = NSTextField(labelWithString: viewModel.subtitle)
        textField.font = .systemFont(ofSize: 16)
        textField.alignment = .center
        textField.isEditable = false
        textField.isSelectable = false
        textField.lineBreakMode = .byWordWrapping
        return textField
    }()
    
    private lazy var buttonA: NSButton = {
        let button = NSButton(title: viewModel.titleA,
                              target: self,
                              action: #selector(aSelected))
        return button
    }()
    
    private lazy var buttonB: NSButton = {
        let button = NSButton(title: viewModel.titleB,
                              target: self,
                              action: #selector(bSelected))
        return button
    }()
    
    private lazy var closeButton: NSButton = {
        let button = NSButton(image: NSImage(named: NSImage.Name("Close")) ?? NSImage(),
                              target: self,
                              action: #selector(onCloseButtonTap))
        button.focusRingType = .none
        button.imageScaling = .scaleProportionallyDown
        button.imagePosition = .imageOnly
        button.isBordered = false
        return button
    }()
    
    private let viewModel: DualChoiceViewModel<T>
    
    private let onClose: () -> Void
    
    init(viewModel: DualChoiceViewModel<T>, onClose: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onClose = onClose
        
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
        addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
        
        addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
        
        addSubview(buttonA)
        buttonA.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonA.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            buttonA.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            buttonA.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            buttonA.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -8)
        ])
        
        addSubview(buttonB)
        buttonB.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonB.leadingAnchor.constraint(equalTo: buttonA.trailingAnchor, constant: 16),
            buttonB.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            buttonB.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            buttonB.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func aSelected() {
        viewModel.onASelect()
        onClose()
    }
    
    @objc private func bSelected() {
        viewModel.onBSelect()
        onClose()
    }
    
    @objc private func onCloseButtonTap() {
        onClose()
    }
}
