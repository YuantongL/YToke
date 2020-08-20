//
//  SideBarView.swift
//  YToke
//
//  Created by Lyt on 2020/8/3.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

final class SideBarViewController: NSViewController {

    private let tabView: TabView
    
    init(dependencyContainer: DependencyContainer) {
        let videoQueueViewModel = StandardVideoQueueViewModel(dependencyContainer: dependencyContainer)
        let queueViewController = VideoQueueViewController(viewModel: videoQueueViewModel)
        
        let mixerViewModel = StandardMixerViewModel(dependencyContainer: dependencyContainer)
        let mixerViewController = MixerViewController(viewModel: mixerViewModel)
        
        tabView = TabView(tabs: [
            .init(title: NSLocalizedString("queue", comment: "Queue"),
                  view: queueViewController.view),
            .init(title: NSLocalizedString("mixer", comment: "Mixer"),
                  view: mixerViewController.view)
        ])
        
        super.init(nibName: nil, bundle: nil)
        
        addChild(queueViewController)
        addChild(mixerViewController)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = NSView()
    }
    
    private func setupLayout() {
        view.addSubview(tabView)
        tabView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabView.topAnchor.constraint(equalTo: view.topAnchor),
            tabView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }

}
