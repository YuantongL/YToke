//
//  AudioDevicesListView.swift
//  YToke
//
//  Created by Lyt on 8/31/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa
import Foundation

final class AudioDevicesListView: NSView {
    
    private let deviceCellIdentifier: NSUserInterfaceItemIdentifier = .init(rawValue: "DeviceCell")
    
    private var viewModel: AudioDevicesListViewModel
    
    private lazy var introView: NSTextField = {
        NSTextField(labelWithString: NSLocalizedString("select_input_device",
                                                       comment: "Select input device"))
    }()
    
    private lazy var tableView: NSTableView = {
        let tableView = NSTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.usesAutomaticRowHeights = true
        tableView.selectionHighlightStyle = .none
        tableView.intercellSpacing = NSSize(width: 8, height: 8)
        return tableView
    }()
    
    init(viewModel: AudioDevicesListViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        setupLayout()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(introView)
        introView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            introView.leadingAnchor.constraint(equalTo: leadingAnchor),
            introView.topAnchor.constraint(equalTo: topAnchor),
            introView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: introView.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupBinding() {
        let column = NSTableColumn(identifier: deviceCellIdentifier)
        tableView.addTableColumn(column)
        
        viewModel.onItemsUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension AudioDevicesListView: NSTableViewDelegate {}

extension AudioDevicesListView: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: deviceCellIdentifier,
                                      owner: self) as? AudioDevicesListCellView ?? AudioDevicesListCellView()
        
        guard viewModel.items.count > row else {
            return nil
        }

        view.configure(audioDevice: viewModel.items[row],
                       isOn: viewModel.items[row].isOn,
                       onToggleStateChange: { [weak self] device, state in
                        self?.viewModel.onDeviceStateChange(device: device, isToggled: state)
        })
        return view
    }
}
