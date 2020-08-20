//
//  AnimatedCycleTextView.swift
//  YToke
//
//  Created by Lyt on 2020/8/6.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

/// This is a view that will show a moving text from right of the view to left, and repeat
final class AnimatedCycleTextView: NSView {
    
    private var textLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "")
        textField.isEditable = false
        textField.textColor = .white
        textField.font = .systemFont(ofSize: 40)
        textField.alphaValue = 0.5
        return textField
    }()
    
    private let acquireText: () -> String?
    
    private var timer: Timer?
    
    init(acquireText: @escaping () -> String?) {
        self.acquireText = acquireText
        super.init(frame: .zero)
        
        setupLyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var labelLeadingConstraint: NSLayoutConstraint?
    
    private func setupLyout() {
        wantsLayer = true
        layer?.backgroundColor = .clear
        
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        labelLeadingConstraint = NSLayoutConstraint(item: textLabel,
                                                    attribute: .leading,
                                                    relatedBy: .equal,
                                                    toItem: self,
                                                    attribute: .trailing,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        
        guard let constraint = labelLeadingConstraint else {
            return
        }
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: 300),
            textLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            constraint
        ])
    }
    
    override func layout() {
        super.layout()
        textLabel.font = .systemFont(ofSize: (window?.frame.height ?? 320.0) / 20.0)
    }
    
    /// Call this method to start the cycle text loop, normally called when a new song is added
    func scheduleRun() {
        if !(timer?.isValid ?? false) {
            scheduleNextRun()
        }
    }
    
    /// Animate the textField move from right to left
    private func animate() {
        timer?.invalidate()
        NSAnimationContext.runAnimationGroup({ [weak self] context in
            context.duration = 25
            let expectedConstant = -(self?.bounds.width ?? 0.0) - (self?.textLabel.bounds.width ?? 0.0)
            self?.labelLeadingConstraint?.animator().constant = expectedConstant
        }, completionHandler: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.labelLeadingConstraint?.constant = 0
            strongSelf.needsLayout = true
            strongSelf.scheduleNextRun()
        })
    }
    
    /// Set a 15s timer, animate textField when timer fires
    private func scheduleNextRun() {
        guard let text = acquireText() else {
            return
        }
        textLabel.stringValue = text
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { [weak self] _ in
            self?.animate()
        })
    }
}
