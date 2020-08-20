//
//  VideoQueueViewController.swift
//  YToke
//
//  Created by Lyt on 2020/7/28.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

final class VideoQueueViewController: NSViewController {
    
    private let videoQueueCellIdentifier: NSUserInterfaceItemIdentifier = .init(rawValue: "VideoQueueCell")
    
    private var viewModel: VideoQueueViewModel
    
    private lazy var noItemLabel: NSTextField = {
        let textField = NSTextField(labelWithString: NSLocalizedString("no_song_in_queue", comment: "No song in queue"))
        textField.isEditable = false
        textField.textColor = .lightGray
        return textField
    }()
    
    private lazy var tableView: NSTableView = {
        let tableView = NSTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.usesAutomaticRowHeights = true
        tableView.selectionHighlightStyle = .none
        tableView.intercellSpacing = NSSize(width: 8, height: 8)
        tableView.headerView = nil
        return tableView
    }()
    
    private let scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    override func loadView() {
        view = NSView()
    }
    
    init(viewModel: VideoQueueViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    private func setupBinding() {
        let column = NSTableColumn(identifier: videoQueueCellIdentifier)
        tableView.addTableColumn(column)
        
        viewModel.onReload = { [weak self] in
            self?.tableView.reloadData()
            self?.noItemLabel.isHidden = !(self?.viewModel.videos.isEmpty ?? true)
        }
        
        viewModel.onMoveToTop = { [weak self] index in
            self?.tableView.moveRow(at: index, to: 0)
        }
        
        viewModel.onDeleteRow = { [weak self] index in
            self?.tableView.removeRows(at: [index], withAnimation: .slideLeft)
            self?.noItemLabel.isHidden = !(self?.viewModel.videos.isEmpty ?? true)
        }
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.documentView = tableView
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
        view.addSubview(noItemLabel)
        noItemLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noItemLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noItemLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension VideoQueueViewController: NSTableViewDelegate {}

extension VideoQueueViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        viewModel.videos.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: videoQueueCellIdentifier,
                                      owner: self) as? VideoQueueCellView ?? VideoQueueCellView()
        guard viewModel.videos.count > row else {
            return nil
        }
        let video = viewModel.videos[row]
        view.configure(video: video,
                       onToTopButtonTapHandler: { [weak self] video in
                        self?.viewModel.onMoveToTopTap(video: video)
                        
            },
                       onDeleteButtonTapHandler: { [weak self] video in
                        self?.viewModel.onDeleteTap(video: video)
        })
        return view
    }
}
