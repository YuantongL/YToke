//
//  AddButton.swift
//  YToke
//
//  Created by Lyt on 2020/8/4.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

/// The customized button for add a song
final class AddButton: NSControl {
    
    private var isUserInteractionEnabled = true
    private let onTap: () -> Void
    private let imageView: NSImageView = {
        let imageView = NSImageView()
        imageView.alignment = .center
        imageView.imageScaling = .scaleProportionallyUpOrDown
        return imageView
    }()
    
    init(onTap: @escaping () -> Void) {
        self.onTap = onTap
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(isAdded: Bool) {
        imageView.image = isAdded ?
            NSImage(named: NSImage.Name("CheckMarkGreen")) : NSImage(named: NSImage.Name("AddMarkRed"))
        isUserInteractionEnabled = !isAdded
    }
    
    private func setupLayout() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func mouseUp(with event: NSEvent) {
        imageView.image = NSImage(named: NSImage.Name("CheckMarkGreen"))
        if isUserInteractionEnabled {
            onTap()
            isUserInteractionEnabled = false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.sd_cancelCurrentImageLoad()
    }
}
