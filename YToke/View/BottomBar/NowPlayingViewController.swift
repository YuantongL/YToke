//
//  NowPlayingViewController.swift
//  YToke
//
//  Created by Lyt on 2020/8/3.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

final class NowPlayingViewController: NSViewController {
    
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
        let textField = NSTextField(labelWithString: NSLocalizedString("now_playing", comment: "Now playing"))
        textField.maximumNumberOfLines = 1
        textField.cell?.truncatesLastVisibleLine = true
        textField.cell?.lineBreakMode = .byTruncatingTail
        return textField
    }()
    
    private lazy var titleLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "")
        textField.placeholderString = "..."
        textField.maximumNumberOfLines = 2
        return textField
    }()
    
    private lazy var showLyricsViewButton: NSButton = {
        let button = NSButton(title: NSLocalizedString("lyrics", comment: "Lyrics"),
                              target: self,
                              action: #selector(onShowLyricsViewButtonTap))
        button.bezelStyle = .regularSquare
        return button
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
        let button = NSButton(title: NSLocalizedString("skip", comment: "Skip"),
                              target: self,
                              action: #selector(onRightButtonTap))
        button.bezelStyle = .regularSquare
        return button
    }()
    
    init(viewModel: NowPlayingViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        setupLayout()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NSView()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        viewModel.onAppear()
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
        
        viewModel.isShowLyricsButtonHidden = { [weak self] isHidden in
            self?.showLyricsViewButton.isHidden = isHidden
        }
    }
    
    // swiftlint:disable:next function_body_length
    private func setupLayout() {
        view.addSubview(leftImageView)
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            leftImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            leftImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            leftImageView.widthAnchor.constraint(equalToConstant: 80),
            leftImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        view.addSubview(nowPlayingLabel)
        nowPlayingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nowPlayingLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 8),
            nowPlayingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)
        ])
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: nowPlayingLabel.bottomAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -8),
            titleLabel.heightAnchor.constraint(equalTo: nowPlayingLabel.heightAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 350)
        ])
        
        view.addSubview(showLyricsViewButton)
        showLyricsViewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showLyricsViewButton.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor,
                                                         constant: 8),
            showLyricsViewButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            showLyricsViewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            showLyricsViewButton.widthAnchor.constraint(equalToConstant: 80),
            showLyricsViewButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        view.addSubview(showVideoViewButton)
        showVideoViewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showVideoViewButton.leadingAnchor.constraint(equalTo: showLyricsViewButton.trailingAnchor,
                                                         constant: 8),
            showVideoViewButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            showVideoViewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            showVideoViewButton.widthAnchor.constraint(equalToConstant: 80),
            showVideoViewButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        view.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            skipButton.leadingAnchor.constraint(equalTo: showVideoViewButton.trailingAnchor,
                                                constant: 8),
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
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
    
    @objc private func onShowLyricsViewButtonTap() {
        viewModel.onTapShowLyrics()
    }
}
