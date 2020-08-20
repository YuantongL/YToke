//
//  VideoListLoadingCellView.swift
//  YToke
//
//  Created by Lyt on 2020/8/11.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

final class VideoListLoadingCellView: NSView {
    
    private lazy var loadingSpinner: NSProgressIndicator = {
        let spinner = NSProgressIndicator()
        spinner.style = .spinning
        spinner.startAnimation(nil)
        return spinner
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(loadingSpinner)
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingSpinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingSpinner.widthAnchor.constraint(equalToConstant: 38),
            loadingSpinner.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
}
