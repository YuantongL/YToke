//
//  AudioDevicesListCellView.swift
//  YToke
//
//  Created by Lyt on 8/31/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

final class AudioDevicesListCellView: NSView {
    
    private var audioDevice: AudioDevice?
    private var onToggleStateChange: ((AudioDevice, Bool) -> Void)?
    
    private lazy var toggle: NSButton = {
        NSButton(checkboxWithTitle: audioDevice?.name ?? "",
                 target: self,
                 action: #selector(onToggleTapped))
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(toggle)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toggle.leadingAnchor.constraint(equalTo: leadingAnchor),
            toggle.trailingAnchor.constraint(equalTo: trailingAnchor),
            toggle.topAnchor.constraint(equalTo: topAnchor),
            toggle.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(audioDevice: AudioDevice, isOn: Bool, onToggleStateChange: @escaping (AudioDevice, Bool) -> Void) {
        self.audioDevice = audioDevice
        self.onToggleStateChange = onToggleStateChange
        
        toggle.title = audioDevice.name ?? "Unnamed device"
        toggle.state = isOn ? .on : .off
    }
    
    @objc private func onToggleTapped() {
        guard let audioDevice = audioDevice else {
            return
        }
        onToggleStateChange?(audioDevice, toggle.state == .on)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        audioDevice = nil
        onToggleStateChange = nil
    }
}
