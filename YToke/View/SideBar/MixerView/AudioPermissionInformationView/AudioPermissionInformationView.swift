//
//  AudioPermissionInformationView.swift
//  YToke
//
//  Created by Lyt on 8/29/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AppKit
import Foundation

final class AudioPermissionInformationView: NSView {
    
    private let viewModel: AudioPermissionInformationViewModel
    
    private lazy var descriptionLabel: NSTextField = {
        let textField = NSTextField(labelWithString: viewModel.description)
        textField.cell?.wraps = true
        return textField
    }()
    
    private lazy var button: NSButton = {
        let button = NSButton(title: NSLocalizedString("go_to_settings", comment: "Go to Settings"),
                              target: self,
                              action: #selector(onButtonTap))
        button.bezelStyle = .regularSquare
        return button
    }()
    
    init(viewModel: AudioPermissionInformationViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setupBinding()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinding() {
        descriptionLabel.stringValue = viewModel.description
    }
    
    private func setupLayout() {
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func onButtonTap() {
        viewModel.onButtonTap()
    }
}
