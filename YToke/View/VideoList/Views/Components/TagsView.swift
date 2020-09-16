//
//  TagsView.swift
//  YToke
//
//  Created by Lyt on 9/15/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AppKit
import Foundation

final class TagsView: NSView {
    
    private lazy var stackView: NSStackView = {
        let stackView = NSStackView(frame: .zero)
        stackView.alignment = .centerY
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configure(contents: [(text: String, backgroundColor: NSColor)]) {
        let arrangedSubViews = contents.map { TagPill(text: $0.text, backgroundColor: $0.backgroundColor) }
        for view in arrangedSubViews {
            stackView.addArrangedSubview(view)
        }
    }
    
    override func prepareForReuse() {
        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        super.prepareForReuse()
    }
    
}
