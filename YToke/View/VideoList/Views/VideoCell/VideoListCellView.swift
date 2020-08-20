//
//  VideoListCellView.swift
//  YToke
//
//  Created by Lyt on 2020/7/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa
import SDWebImage

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
        titleView.maximumNumberOfLines = 2
        titleView.isSelectable = false
        titleView.isEditable = false
        titleView.cell?.truncatesLastVisibleLine = true
        titleView.cell?.lineBreakMode = .byWordWrapping
        return titleView
    }()
    
    private lazy var button: AddButton = {
        let button = AddButton { [weak self] in
            self?.onButtonTap()
        }
        return button
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
        titleView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        titleView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            titleView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        imageView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 48),
            button.heightAnchor.constraint(equalToConstant: 48),
            button.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
            button.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8)
        ])
    }
    
    override func layout() {
        super.layout()
        button.layer?.cornerRadius = button.bounds.width / 2.0
    }
    
    func configure(title: String, imageURL: URL?, isAdded: Bool, onAddButtonTap: (() -> Void)?) {
        titleView.stringValue = title
        imageView.sd_setImage(with: imageURL)
        self.onAddButtonTap = onAddButtonTap
        button.configure(isAdded: isAdded)
    }
    
    @objc private func onButtonTap() {
        onAddButtonTap?()
        button.isEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.sd_cancelCurrentImageLoad()
        button.prepareForReuse()
    }
}
