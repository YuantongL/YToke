//
//  MixerViewController.swift
//  YToke
//
//  Created by Lyt on 2020/7/28.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

final class MixerViewController: NSViewController {
    
    private var viewModel: MixerViewModel
    
    private lazy var audioPermissionView: AudioPermissionInformationView = {
        AudioPermissionInformationView(viewModel: viewModel.permissionInformationViewModel)
    }()
    
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
    
    private lazy var audioDevicesListView: AudioDevicesListView = {
        let view = AudioDevicesListView(viewModel: viewModel.audioDevicesListViewModel)
        return view
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
    
    private lazy var stackView: NSStackView = {
        let stackView = NSStackView(views: [
            audioPermissionView,
            audioDevicesListView,
            videoVolumeText,
            videoVolumeSlider,
            micVolumeText,
            micVolumeSlider
        ])
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        stackView.orientation = .vertical
        return stackView
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
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -32)
        ])
    }
    
    private func setupBinding() {
        videoVolumeSlider.doubleValue = Double(viewModel.videoVolume)
        micVolumeSlider.doubleValue = Double(viewModel.voiceVolume)
        audioPermissionView.isHidden = viewModel.isPermissionInformationHidden
        audioDevicesListView.isHidden = viewModel.isAudioDevicesListHidden
        micVolumeSlider.isHidden = viewModel.isMicrophoneVolumeControlHidden
        micVolumeText.isHidden = viewModel.isMicrophoneVolumeControlHidden
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
}
