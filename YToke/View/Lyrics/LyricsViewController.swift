//
//  LyricsViewController.swift
//  YToke
//
//  Created by Lyt on 9/28/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import AppKit
import Foundation
import SpotlightLyrics

struct LyricsViewConfig {
    let songName: String
    let singerName: String?
    let lyrics: String
}

final class LyricsViewController: NSViewController {
    
    private var viewModel: LyricsViewModel
    
    private lazy var lyricsView = LyricsView()
    
    private lazy var songNameField: NSSearchField = {
        let searchField = NSSearchField()
        searchField.placeholderString = NSLocalizedString("song_name",
                                                          comment: "Song name")
        searchField.centersPlaceholder = true
        return searchField
    }()
    
    private lazy var singerNameField: NSSearchField = {
        let searchField = NSSearchField()
        searchField.placeholderString = NSLocalizedString("singer_name",
                                                          comment: "Singer name")
        searchField.centersPlaceholder = true
        return searchField
    }()
    
    private lazy var searchButton: NSButton = {
        let button = NSButton(title: NSLocalizedString("search", comment: "Search"),
                              target: self,
                              action: #selector(onTapSearchButton))
        button.bezelStyle = .regularSquare
        return button
    }()
    
    private lazy var loadingSpinner: NSProgressIndicator = {
        let indicator = NSProgressIndicator()
        indicator.style = .spinning
        indicator.isHidden = true
        return indicator
    }()
    
    private lazy var statusLabel: NSTextField = {
        let title = "No lyric to display"
        let textField = NSTextField(labelWithString: title)
        textField.isEditable = false
        textField.textColor = .lightGray
        textField.isHidden = false
        textField.alignment = .center
        return textField
    }()
    
    init(viewModel: LyricsViewModel) {
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
    
    // swiftlint:disable:next function_body_length
    private func setupLayout() {
        view.addSubview(songNameField)
        songNameField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            songNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            songNameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 4)
        ])
        
        view.addSubview(singerNameField)
        singerNameField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            singerNameField.leadingAnchor.constraint(equalTo: songNameField.trailingAnchor, constant: 4),
            singerNameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            singerNameField.widthAnchor.constraint(equalTo: songNameField.widthAnchor),
            singerNameField.heightAnchor.constraint(equalTo: songNameField.heightAnchor)
        ])
        
        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: singerNameField.trailingAnchor, constant: 4),
            searchButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            searchButton.heightAnchor.constraint(equalTo: singerNameField.heightAnchor)
        ])
        
        view.addSubview(lyricsView)
        lyricsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lyricsView.widthAnchor.constraint(greaterThanOrEqualToConstant: 300),
            lyricsView.heightAnchor.constraint(greaterThanOrEqualToConstant: 500),
            lyricsView.topAnchor.constraint(equalTo: singerNameField.bottomAnchor, constant: 4),
            lyricsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lyricsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lyricsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(loadingSpinner)
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
            statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
            statusLabel.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            statusLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupBinding() {
        viewModel.onLyricsPlay = { [weak self] config in
            self?.lyricsView.lyrics = config.lyrics
            self?.songNameField.stringValue = config.songName
            self?.singerNameField.stringValue = config.singerName ?? ""
            self?.lyricsView.timer.reset()
            self?.lyricsView.timer.play()
        }
        
        viewModel.onLyricsDisplay = { [weak self] config in
            self?.lyricsView.timer.pause()
            self?.lyricsView.lyrics = config.lyrics
            self?.songNameField.stringValue = config.songName
            self?.singerNameField.stringValue = config.singerName ?? ""
            self?.lyricsView.timer.reset()
        }
        
        viewModel.onSeek = { [weak self] timeInterval in
            self?.lyricsView.timer.reset()
            self?.lyricsView.timer.play()
            self?.lyricsView.timer.seek(toTime: timeInterval)
        }
        
        viewModel.onPause = { [weak self] in
            self?.lyricsView.timer.pause()
        }
        
        viewModel.onLoadingSpinnerHiddenChange = { [weak self] isHidden in
            if isHidden {
                self?.stopLoadingSpinner()
            } else {
                self?.startLoadingSpinner()
            }
        }
        
        viewModel.onStatusLabelChange = { [weak self] statusString in
            if let statusString = statusString {
                self?.statusLabel.isHidden = false
                self?.statusLabel.stringValue = statusString
                self?.lyricsView.isHidden = true
            } else {
                self?.statusLabel.isHidden = true
                self?.statusLabel.stringValue = ""
                self?.lyricsView.isHidden = false
            }
        }
    }
    
    private func startLoadingSpinner() {
        lyricsView.isHidden = true
        statusLabel.isHidden = true
        loadingSpinner.isHidden = false
        loadingSpinner.startAnimation(nil)
    }
    
    private func stopLoadingSpinner() {
        lyricsView.isHidden = false
        loadingSpinner.isHidden = true
        loadingSpinner.stopAnimation(nil)
    }
    
    @objc private func onTapSearchButton() {
        viewModel.onSearchTapped(songName: songNameField.stringValue, singerName: singerNameField.stringValue)
    }
}
