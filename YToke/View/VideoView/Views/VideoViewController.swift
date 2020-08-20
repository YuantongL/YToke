//
//  VideoViewController.swift
//  YToke
//
//  Created by Lyt on 2020/7/15.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AVKit
import Cocoa

final class VideoViewController: NSViewController {
    
    private var viewModel: VideoViewModel

    private lazy var playerView: AVPlayerView = {
        let playerView = AVPlayerView()
        playerView.showsFullScreenToggleButton = true
        return playerView
    }()
    
    private lazy var loadingSpinner: NSProgressIndicator = {
        let indicator = NSProgressIndicator()
        indicator.style = .spinning
        indicator.isHidden = true
        return indicator
    }()
    
    private lazy var animatedTextView: AnimatedCycleTextView = {
        let textView = AnimatedCycleTextView(acquireText: { [weak self] in
            return self?.viewModel.cycleText
        })
        return textView
    }()
    
    init(viewModel: VideoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupLayout()
        setupBinding()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NSView()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        animatedTextView.scheduleRun()
        viewModel.onAppear()
    }
    
    private func setupBinding() {
        viewModel.streamURL = { [weak self] url in
            self?.playVideo(streamURL: url)
        }
        
        viewModel.volume = { [weak self] volume in
            self?.playerView.player?.volume = volume
        }
        
        viewModel.isLoadingSpinnerHidden = { [weak self] isHidden in
            self?.loadingSpinner.isHidden = isHidden
            if isHidden {
                self?.loadingSpinner.stopAnimation(nil)
            } else {
                self?.loadingSpinner.startAnimation(nil)
            }
        }
    }
    
    private func setupLayout() {
        view.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.topAnchor.constraint(equalTo: view.topAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(loadingSpinner)
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingSpinner.centerYAnchor.constraint(equalTo: playerView.centerYAnchor),
            loadingSpinner.centerXAnchor.constraint(equalTo: playerView.centerXAnchor)
        ])
        
        view.addSubview(animatedTextView)
        animatedTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animatedTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animatedTextView.topAnchor.constraint(equalTo: view.topAnchor),
            animatedTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // This is used as the initial window size
            view.widthAnchor.constraint(greaterThanOrEqualToConstant: 400),
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ])
    }
    
    func playVideo(streamURL: URL) {
        let item = AVPlayerItem(url: streamURL)
        let player = AVPlayer(playerItem: item)
        playerView.player = player
        player.volume = 1.0
        player.play()
        animatedTextView.scheduleRun()
    }
}
