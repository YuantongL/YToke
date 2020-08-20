//
//  RatingView.swift
//  YToke
//
//  Created by Lyt on 2020/7/21.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa
import Foundation

/// This class is not currently used
final class RatingView: NSView {
    var upVote: Int {
        didSet {
            upNumber.stringValue = "\(upVote)"
        }
    }
    
    var downVote: Int {
        didSet {
            upNumber.stringValue = "\(downVote)"
        }
    }
    
    private let upIcon: NSView = {
        let textField = NSTextField(labelWithString: "Up")
        textField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return textField
    }()
    
    private lazy var upNumber: NSTextField = {
        let textField = NSTextField(labelWithString: "0")
        textField.isEditable = false
        return textField
    }()
    
    private let downIcon: NSView = {
        let textField = NSTextField(labelWithString: "Down")
        textField.isEditable = false
        textField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return textField
    }()
    
    private lazy var downNumber: NSView = {
        let textField = NSTextField(labelWithString: "0")
        textField.isEditable = false
        return textField
    }()
    
    private lazy var stackView: NSStackView = {
        let stackView = NSStackView(views: [upIcon, upNumber, downIcon, downNumber])
        stackView.alignment = .centerX
        stackView.orientation = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(upVote: Int, downVote: Int) {
        self.upVote = upVote
        self.downVote = downVote
        
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            topAnchor.constraint(equalTo: stackView.topAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Previews

import SwiftUI

private struct RatingViewPresentable: NSViewRepresentable {
    func makeNSView(context: Context) -> RatingView {
        RatingView(upVote: 30, downVote: 50)
    }
    
    func updateNSView(_ nsView: RatingView, context: Context) {}
}

struct RatingViewPreviews: PreviewProvider {
    @available(OSX 10.15.0, *)
    static var previews: some View {
        Group {
            RatingViewPresentable()
                .frame(width: 300, height: 100, alignment: .leading)
        }
    }
}
