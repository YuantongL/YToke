//
//  DonationView.swift
//  YToke
//
//  Created by Lyt on 2020/8/10.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

final class DonationView: NSView {
    
    private let viewModel: DonationViewModel
    
    private lazy var titleField: NSTextField = {
        let textField = NSTextField(labelWithString: viewModel.title)
        textField.font = .boldSystemFont(ofSize: 32)
        textField.alignment = .center
        textField.maximumNumberOfLines = 1
        textField.isEditable = false
        textField.isSelectable = false
        return textField
    }()
    
    private lazy var hiddenTitleField: NSTextField = {
        let textField = NSTextField(labelWithString: viewModel.hiddenTitle)
        textField.font = .boldSystemFont(ofSize: 64)
        textField.alignment = .center
        textField.maximumNumberOfLines = 1
        textField.isEditable = false
        textField.isSelectable = false
        textField.isHidden = true
        return textField
    }()
    
    private lazy var subtitleField: NSTextField = {
        let textField = NSTextField(labelWithString: viewModel.subTitle)
        textField.font = .systemFont(ofSize: 16)
        textField.alignment = .center
        textField.isEditable = false
        textField.isSelectable = false
        textField.lineBreakMode = .byWordWrapping
        return textField
    }()
    
    private lazy var imageView: NSImageView = {
        let imageView = NSImageView()
        imageView.image = viewModel.image
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.alignment = .center
        return imageView
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
    
    private lazy var button: NSButton = {
        let button = NSButton(image: viewModel.buttonImage, target: self, action: #selector(onButtonTap))
        button.imageScaling = .scaleProportionallyDown
        button.imagePosition = .imageOnly
        button.isBordered = false
        return button
    }()
    
    private var onDismiss: () -> Void
    
    init(viewModel: DonationViewModel, onDismiss: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onDismiss = onDismiss
        
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // swiftlint:disable:next function_body_length
    private func setupLayout() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 700),
            heightAnchor.constraint(equalToConstant: 700)
        ])
        
        addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        addSubview(titleField)
        titleField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: topAnchor, constant: 64),
            titleField.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleField.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        addSubview(hiddenTitleField)
        hiddenTitleField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hiddenTitleField.centerYAnchor.constraint(equalTo: centerYAnchor),
            hiddenTitleField.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        addSubview(subtitleField)
        subtitleField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 16),
            subtitleField.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subtitleField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: subtitleField.bottomAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor, constant: 8),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 100),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    @objc func onCloseButtonTap() {
        onDismiss()
    }
    
    @objc func onButtonTap() {
        viewModel.onTapButton()
        imageView.isHidden = true
        titleField.isHidden = true
        subtitleField.isHidden = true
        hiddenTitleField.isHidden = false
    }
}

// MARK: - Previews

import SwiftUI

private struct DonationViewPresentable: NSViewRepresentable {
    func makeNSView(context: Context) -> DonationView {
        DonationView(viewModel: StandardDonationViewModel(), onDismiss: {
            // no-op
        })
    }
    
    func updateNSView(_ nsView: DonationView, context: Context) {}
}

struct DonationViewPreviews: PreviewProvider {
    @available(OSX 10.15.0, *)
    static var previews: some View {
        Group {
            DonationViewPresentable()
        }
    }
}
