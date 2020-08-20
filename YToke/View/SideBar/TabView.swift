//
//  TabView.swift
//  YToke
//
//  Created by Lyt on 2020/8/3.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

final class TabView: NSView {
    
    struct TabConfig {
        let title: String
        let view: NSView
    }
    
    private var views: [NSView] = []
    private let buttonStack: NSStackView = {
        let stackView = NSStackView(frame: .zero)
        stackView.alignment = .centerX
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init(tabs: [TabConfig]) {
        super.init(frame: .zero)
        
        for i in 0..<tabs.count {
            let tab = tabs[i]
            let button = NSButton()
            button.target = self
            button.action = #selector(onTabTap(sender:))
            button.title = tab.title
            button.bezelStyle = .regularSquare
            (button.cell as? NSButtonCell)?.isBordered = false
            button.setButtonType(.toggle)
            buttonStack.addArrangedSubview(button)
            
            if i == 0 {
                button.state = .on
            } else {
                button.state = .off
            }
        }
        
        buttonStack.orientation = .horizontal
        addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            buttonStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            buttonStack.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        for subView in buttonStack.arrangedSubviews {
            subView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                subView.heightAnchor.constraint(equalTo: buttonStack.heightAnchor)
            ])
        }
        
        for i in 0..<tabs.count {
            let view = tabs[i].view
            addSubview(view)
            views.append(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            if i != 0 {
                view.isHidden = true
            }
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.topAnchor.constraint(equalTo: buttonStack.bottomAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onTabTap(sender: NSButton) {
        for i in buttonStack.arrangedSubviews.enumerated() {
            if i.element == sender {
                let index = i.offset
                guard views.count > index else {
                    return
                }
                for j in views.enumerated() {
                    if j.offset == index {
                        j.element.isHidden = false
                    } else {
                        j.element.isHidden = true
                    }
                }
                sender.state = .on
            } else {
                (i.element as? NSButton)?.state = .off
            }
        }
    }
}
