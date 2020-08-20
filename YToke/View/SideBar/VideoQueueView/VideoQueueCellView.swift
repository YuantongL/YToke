//
//  VideoQueueCellView.swift
//  YToke
//
//  Created by Lyt on 2020/7/29.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa
import Foundation
import SDWebImage

final class VideoQueueCellView: NSView {
    
    private var video: Video?
    private var onToTopButtonTapHandler: ((Video) -> Void)?
    private var onDeleteButtonTapHandler: ((Video) -> Void)?
    
    private let imageView: NSImageView = {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyDown
        imageView.imageAlignment = .alignCenter
        imageView.wantsLayer = true
        imageView.layer?.cornerRadius = 2.0
        return imageView
    }()
    
    private let titleField: NSTextField = {
        let textField = NSTextField(labelWithString: "")
        textField.maximumNumberOfLines = 1
        textField.cell?.truncatesLastVisibleLine = true
        textField.cell?.lineBreakMode = .byTruncatingTail
        return textField
    }()
    
    private lazy var moveToTopButton: NSButton = {
        let button = NSButton(image: NSImage(named: NSImage.Name("ToTopIcon")) ?? NSImage(),
                              target: self,
                              action: #selector(onMoveToTopButtonTap))
        button.isBordered = false
        button.imageScaling = .scaleProportionallyUpOrDown
        button.imagePosition = .imageOnly
        return button
    }()
    
    private lazy var deleteButton: NSButton = {
        let button = NSButton(image: NSImage(named: NSImage.Name("DeleteIcon")) ?? NSImage(),
                              target: self,
                              action: #selector(onDeleteButtonTap))
        button.isBordered = false
        button.imageScaling = .scaleProportionallyUpOrDown
        button.imagePosition = .imageOnly
        return button
    }()
    
    private lazy var bottomBoarderView: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        view.alphaValue = 0.5
        return view
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // swiftlint:disable:next function_body_length
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        addSubview(titleField)
        titleField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            titleField.widthAnchor.constraint(equalToConstant: 180),
            titleField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleField.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -4)
        ])
        
        addSubview(moveToTopButton)
        moveToTopButton.translatesAutoresizingMaskIntoConstraints = false
        moveToTopButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        NSLayoutConstraint.activate([
            moveToTopButton.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            moveToTopButton.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 8),
            moveToTopButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8),
            moveToTopButton.heightAnchor.constraint(equalToConstant: 20),
            moveToTopButton.heightAnchor.constraint(equalTo: moveToTopButton.widthAnchor)
        ])
        
        addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: moveToTopButton.trailingAnchor, constant: 8),
            deleteButton.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 8),
            deleteButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8),
            deleteButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -8),
            deleteButton.heightAnchor.constraint(equalToConstant: 20),
            deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor)
        ])
        
        addSubview(bottomBoarderView)
        bottomBoarderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomBoarderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBoarderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBoarderView.heightAnchor.constraint(equalToConstant: 0.5),
            bottomBoarderView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }
    
    func configure(video: Video,
                   onToTopButtonTapHandler: @escaping (Video) -> Void,
                   onDeleteButtonTapHandler: @escaping (Video) -> Void) {
        self.titleField.stringValue = video.title
        self.video = video
        self.onToTopButtonTapHandler = onToTopButtonTapHandler
        self.onDeleteButtonTapHandler = onDeleteButtonTapHandler
        if let imageURL = video.thumbnail {
            imageView.sd_setImage(with: imageURL, completed: nil)
        }
    }
    
    @objc private func onMoveToTopButtonTap() {
        guard let video = video else {
            return
        }
        onToTopButtonTapHandler?(video)
    }
    
    @objc private func onDeleteButtonTap() {
        guard let video = video else {
            return
        }
        onDeleteButtonTapHandler?(video)
    }
    
    override func prepareForReuse() {
        titleField.stringValue = ""
        video = nil
        onToTopButtonTapHandler = nil
        onDeleteButtonTapHandler = nil
        imageView.sd_cancelCurrentImageLoad()
    }
}
