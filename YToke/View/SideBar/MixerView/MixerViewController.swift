//
//  MixerViewController.swift
//  YToke
//
//  Created by Lyt on 2020/7/28.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

final class MixerViewController: NSViewController {
    
    private let viewModel: MixerViewModel
    
    private lazy var videoVolumeText: NSTextField = {
        NSTextField(labelWithString: NSLocalizedString("video_volume", comment: "Video Volume"))
    }()
    
    private lazy var videoVolumeSlider: NSSlider = {
        let slider = NSSlider()
        slider.minValue = 0
        slider.maxValue = 100
        slider.isContinuous = true
        slider.target = self
        slider.action = #selector(onVideoVolumnChange)
        return slider
    }()
    
    private lazy var micVolumeText: NSTextField = {
        NSTextField(labelWithString: NSLocalizedString("microphone_volume", comment: "Microphone Volume"))
    }()
    
    private lazy var micVolumeSlider: NSSlider = {
        let slider = NSSlider()
        slider.minValue = 0
        slider.maxValue = 100
        slider.isContinuous = true
        slider.target = self
        slider.action = #selector(onMicVolumnChange)
        return slider
    }()
    
    private lazy var toggle: NSButton = {
        let title = NSLocalizedString("microphone_stream", comment: "Microphone Stream")
        let toggle = NSButton(checkboxWithTitle: title,
                              target: self,
                              action: #selector(onToggleTapped))
        return toggle
    }()
    
    init(viewModel: MixerViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBinding()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        viewModel.onAppear()
    }
    
    private func setupLayout() {
        view.addSubview(videoVolumeText)
        videoVolumeText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoVolumeText.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            videoVolumeText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            videoVolumeText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(videoVolumeSlider)
        videoVolumeSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoVolumeSlider.topAnchor.constraint(equalTo: videoVolumeText.bottomAnchor, constant: 8),
            videoVolumeSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            videoVolumeSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(micVolumeText)
        micVolumeText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            micVolumeText.topAnchor.constraint(equalTo: videoVolumeSlider.bottomAnchor, constant: 32),
            micVolumeText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            micVolumeText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(micVolumeSlider)
        micVolumeSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            micVolumeSlider.topAnchor.constraint(equalTo: micVolumeText.bottomAnchor, constant: 8),
            micVolumeSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            micVolumeSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(toggle)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toggle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            toggle.topAnchor.constraint(equalTo: micVolumeSlider.bottomAnchor, constant: 32),
            toggle.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            toggle.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
        ])
    }
    
    private func setupBinding() {
        videoVolumeSlider.doubleValue = Double(viewModel.videoVolume)
        micVolumeSlider.doubleValue = Double(viewModel.voiceVolume)
        toggle.state = viewModel.toggleState ? .on : .off
    }
    
    @objc private func onVideoVolumnChange(sender: Any) {
        guard let slider = (sender as? NSSlider)?.cell else {
            return
        }
        let value = slider.floatValue
        viewModel.setVideoVolume(to: value)
    }
    
    @objc private func onMicVolumnChange(sender: Any) {
        guard let slider = (sender as? NSSlider)?.cell else {
            return
        }
        let value = slider.floatValue
        viewModel.setVoiceVolume(to: value)
    }
    
    @objc private func onToggleTapped() {
        let isEnabled = toggle.state == .on
        viewModel.setToggleState(state: isEnabled)
    }
}
