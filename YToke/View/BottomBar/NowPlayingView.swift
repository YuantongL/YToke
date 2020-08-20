//
//  NowPlayingViewController.swift
//  MyKTV
//
//  Created by Lyt on 2020/8/3.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

final class NowPlayingViewController: NSBox {
    
    private var viewModel: NowPlayingViewModel
    
    private lazy var leftImageView: NSImageView = {
        let imageView = NSImageView()
        imageView.wantsLayer = true
        imageView.imageAlignment = .alignCenter
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.layer?.cornerRadius = 4.0
        imageView.layer?.masksToBounds = true
        return imageView
    }()
    
    private lazy var nowPlayingLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "Now playing")
        textField.maximumNumberOfLines = 1
        return textField
    }()
    
    private lazy var titleLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "")
        textField.placeholderString = "..."
        textField.maximumNumberOfLines = 2
        return textField
    }()
    
    private lazy var showVideoViewButton: NSButton = {
        let button = NSButton(title: "KTV",
                              target: self,
                              action: #selector(onShowVideoViewButtonTap))
        button.bezelStyle = .regularSquare
        button.isHidden = true
        return button
    }()
    
    private lazy var skipButton: NSButton = {
        let button = NSButton(title: "Skip",
                              target: self,
                              action: #selector(onRightButtonTap))
        button.bezelStyle = .regularSquare
        return button
    }()
    
    init(viewModel: NowPlayingViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        setupLayout()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinding() {
        leftImageView.image = NSImage(color: .darkGray, size: .init(width: 80, height: 60))
        
        viewModel.title = { [weak self] title in
            self?.titleLabel.stringValue = title
        }
        
        viewModel.image = { [weak self] url in
            self?.leftImageView.sd_setImage(with: url, completed: nil)
        }
        
        viewModel.isShowVideoButtonHidden = { [weak self] isHidden in
            self?.showVideoViewButton.isHidden = isHidden
        }
    }
    
    // swiftlint:disable:next function_body_length
    private func setupLayout() {
        titlePosition = .noTitle
        
        addSubview(leftImageView)
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            leftImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            leftImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            leftImageView.widthAnchor.constraint(equalToConstant: 80),
            leftImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        addSubview(nowPlayingLabel)
        nowPlayingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nowPlayingLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 8),
            nowPlayingLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: nowPlayingLabel.bottomAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8),
            titleLabel.heightAnchor.constraint(equalTo: nowPlayingLabel.heightAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 350)
        ])
        
        addSubview(showVideoViewButton)
        showVideoViewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showVideoViewButton.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor,
                                                         constant: 8),
            showVideoViewButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            showVideoViewButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            showVideoViewButton.widthAnchor.constraint(equalToConstant: 80),
            showVideoViewButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            skipButton.leadingAnchor.constraint(equalTo: showVideoViewButton.trailingAnchor,
                                                constant: 8),
            skipButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            skipButton.widthAnchor.constraint(equalToConstant: 80),
            skipButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func onRightButtonTap() {
        viewModel.onTapNext()
    }
    
    @objc private func onShowVideoViewButtonTap() {
        viewModel.onTapShowVideo()
    }
}
