//
//  ViewController.swift
//  YToke
//
//  Created by Lyt on 2020/7/14.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

final class ViewController: NSViewController {
    
    let viewModel = StandardMainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    private func setupBinding() {
        viewModel.onPresentDonationView = { [weak self] viewModel in
            let viewController = NSViewController()
            viewController.view = DonationView(viewModel: viewModel, onDismiss: {
                self?.dismiss(viewController)
            })
            self?.presentAsSheet(viewController)
        }
        
        viewModel.onPresentDualChoiceView = { [weak self] viewModel in
            let viewController = NSViewController()
            viewController.view = DualChoiceView(viewModel: viewModel, onClose: {
                self?.dismiss(viewController)
            })
            self?.presentAsSheet(viewController)
        }
    }
    
    private func setupLayout() {
        let videoListViewController = VideoListViewController(viewModel: viewModel.videoListViewModel)
        addChild(videoListViewController)
        view.addSubview(videoListViewController.view)
        videoListViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoListViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoListViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            videoListViewController.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 300),
            videoListViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let sideBarViewController = SideBarViewController(dependencyContainer: viewModel.dependencyContainer)
        addChild(sideBarViewController)
        view.addSubview(sideBarViewController.view)
        sideBarViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sideBarViewController.view.leadingAnchor.constraint(equalTo: videoListViewController.view.trailingAnchor),
            sideBarViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            sideBarViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideBarViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let visualEffectView = NSVisualEffectView()
        visualEffectView.blendingMode = .withinWindow
        visualEffectView.state = .active
        view.addSubview(visualEffectView)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            visualEffectView.heightAnchor.constraint(equalToConstant: 76),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: sideBarViewController.view.leadingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let nowPlayingViewController = NowPlayingViewController(viewModel: viewModel.nowPlayingViewModel)
        addChild(nowPlayingViewController)
        visualEffectView.addSubview(nowPlayingViewController.view)
        nowPlayingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nowPlayingViewController.view.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
            nowPlayingViewController.view.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor),
            nowPlayingViewController.view.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor),
            nowPlayingViewController.view.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor)
        ])
    }
}
