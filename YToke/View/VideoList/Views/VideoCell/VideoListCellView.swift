//
//  VideoListCellView.swift
//  YToke
//
//  Created by Lyt on 2020/7/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa
import SDWebImage

struct VideoListCellConfig {
    let title: String
    let imageURL: URL?
    let isAdded: Bool
    let onAddButtonTap: (() -> Void)?
    let tags: [(text: String, backgroundColor: NSColor)]
    let statsText: String?
}

final class VideoListCellView: NSView {
    
    private lazy var imageView: NSImageView = {
        let imageView = NSImageView()
        imageView.wantsLayer = true
        imageView.imageAlignment = .alignCenter
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.layer?.cornerRadius = 8.0
        imageView.layer?.masksToBounds = true
        return imageView
    }()
    
    private lazy var titleView: NSTextField = {
        let titleView = NSTextField(labelWithString: "")
        titleView.maximumNumberOfLines = 1
        titleView.isSelectable = false
        titleView.isEditable = false
        titleView.cell?.truncatesLastVisibleLine = true
        titleView.cell?.lineBreakMode = .byWordWrapping
        return titleView
    }()
    
    private lazy var tagsView: TagsView = {
        let tagsView = TagsView()
        return tagsView
    }()
    
    private lazy var button: AddButton = {
        let button = AddButton { [weak self] in
            self?.onButtonTap()
        }
        return button
    }()
    
    private lazy var statsLabel: NSTextField = {
        let statsLabel = NSTextField(labelWithString: "")
        statsLabel.maximumNumberOfLines = 1
        statsLabel.isSelectable = false
        statsLabel.isEditable = false
        statsLabel.cell?.truncatesLastVisibleLine = true
        statsLabel.cell?.lineBreakMode = .byWordWrapping
        statsLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        return statsLabel
    }()
    
    private var onAddButtonTap: (() -> Void)?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 3.0/4.0)
        ])
        
        addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.setContentCompressionResistancePriority(.required, for: .vertical)
        titleView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        imageView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 48),
            button.heightAnchor.constraint(equalToConstant: 48),
            button.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
            button.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8)
        ])
        
        addSubview(tagsView)
        tagsView.translatesAutoresizingMaskIntoConstraints = false
        tagsView.setContentCompressionResistancePriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            tagsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagsView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 4),
            tagsView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            tagsView.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        addSubview(statsLabel)
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        statsLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            statsLabel.topAnchor.constraint(equalTo: tagsView.bottomAnchor, constant: 4),
            statsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            statsLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            statsLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            statsLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    override func layout() {
        super.layout()
        button.layer?.cornerRadius = button.bounds.width / 2.0
    }
    
    func configure(_ config: VideoListCellConfig) {
        titleView.stringValue = config.title
        imageView.sd_setImage(with: config.imageURL)
        self.onAddButtonTap = config.onAddButtonTap
        button.configure(isAdded: config.isAdded)
        tagsView.configure(contents: config.tags)
        statsLabel.stringValue = config.statsText ?? ""
    }
    
    @objc private func onButtonTap() {
        onAddButtonTap?()
        button.isEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.sd_cancelCurrentImageLoad()
        button.prepareForReuse()
        tagsView.prepareForReuse()
        statsLabel.stringValue = ""
    }
}
