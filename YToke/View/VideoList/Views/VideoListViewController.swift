//
//  VideoListViewController.swift
//  YToke
//
//  Created by Lyt on 2020/7/17.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa

final class VideoListViewController: NSViewController {
    
    private var viewModel: VideoListViewModel
    
    private lazy var loadingSpinner: NSProgressIndicator = {
        let indicator = NSProgressIndicator()
        indicator.style = .spinning
        indicator.isHidden = true
        return indicator
    }()
    
    private lazy var searchField: NSSearchField = {
        let searchField = NSSearchField()
        searchField.placeholderString = NSLocalizedString("search_for_a_song",
                                                          comment: "Search for a song")
        searchField.centersPlaceholder = true
        searchField.delegate = self
        return searchField
    }()
    
    private lazy var searchButton: NSButton = {
        let button = NSButton(title: NSLocalizedString("search", comment: "Search"),
                              target: self,
                              action: #selector(onTapSearchButton))
        button.bezelStyle = .regularSquare
        return button
    }()
    
    private lazy var donationButton: NSButton = {
        let button = NSButton(title: NSLocalizedString("support_us", comment: "Support us"),
                              target: self,
                              action: #selector(onTapDonationButton))
        button.imagePosition = .noImage
        button.isBordered = false
        return button
    }()
    
    private lazy var noItemLabel: NSTextField = {
        let title = NSLocalizedString("start_by_search_a_song", comment: "Start by search a song")
        let textField = NSTextField(labelWithString: title)
        textField.isEditable = false
        textField.textColor = .lightGray
        textField.isHidden = false
        return textField
    }()
    
    private lazy var errorLabel: NSTextField = {
        let title = NSLocalizedString("error_view_text", comment: "There's an error fetch this list, please try again.")
        let textField = NSTextField(labelWithString: title)
        textField.isEditable = false
        textField.textColor = .lightGray
        textField.isHidden = true
        return textField
    }()
    
    private let videoCellIdentifier = NSUserInterfaceItemIdentifier.init("VideoListCell")
    private let loadingCellIdentifier = NSUserInterfaceItemIdentifier.init("LoadingCell")
    private lazy var collectionViewLayout: NSCollectionViewFlowLayout = {
        let layout = NSCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16.0
        layout.minimumLineSpacing = 32.0
        return layout
    }()
    private lazy var collectionView: NSCollectionView = {
        let collectionView = NSCollectionView()
        collectionView.autoresizesSubviews = true
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.register(VideoListCellItem.self, forItemWithIdentifier: videoCellIdentifier)
        collectionView.register(VideoListLoadingCellItem.self, forItemWithIdentifier: loadingCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.allowsMagnification = false
        scrollView.postsBoundsChangedNotifications = true
        return scrollView
    }()
    
    init(viewModel: VideoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollViewBoundDidChange),
                                               name: NSView.boundsDidChangeNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        collectionViewLayout.invalidateLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinding() {
        viewModel.onUpdate = { [weak self] in
            self?.collectionView.reloadData()
            self?.noItemLabel.isHidden = !(self?.viewModel.videos.isEmpty ?? true)
        }
        
        viewModel.onLoadingSpinnerHiddenChange = { [weak self] isHidden in
            if isHidden {
                self?.stopLoadingSpinner()
            } else {
                self?.startLoadingSpinner()
            }
        }
        
        viewModel.onLoadingSectionHiddenChange = { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.onErrorLabelHiddenChange = { [weak self] isHidden in
            self?.errorLabel.isHidden = isHidden
        }
    }
    
    private func startLoadingSpinner() {
        noItemLabel.isHidden = true
        loadingSpinner.isHidden = false
        loadingSpinner.startAnimation(nil)
    }
    
    private func stopLoadingSpinner() {
        loadingSpinner.isHidden = true
        loadingSpinner.stopAnimation(nil)
    }
    
    // swiftlint:disable:next function_body_length
    private func setupLayout() {
        view.wantsLayer = true
        view.layer?.backgroundColor = .clear
        
        view.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchField.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            searchField.heightAnchor.constraint(equalToConstant: 32),
            searchField.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: searchField.trailingAnchor, constant: 8),
            searchButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            searchButton.heightAnchor.constraint(equalTo: searchField.heightAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 86)
        ])
        
        view.addSubview(donationButton)
        donationButton.translatesAutoresizingMaskIntoConstraints = false
        donationButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        NSLayoutConstraint.activate([
            donationButton.leadingAnchor.constraint(greaterThanOrEqualTo: searchButton.trailingAnchor),
            donationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            donationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            donationButton.bottomAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: -4),
            donationButton.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
        ])
        
        view.addSubview(scrollView)
        scrollView.documentView = collectionView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsets = NSEdgeInsets(top: 0, left: 8, bottom: 76, right: 8)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            scrollView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 8),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(loadingSpinner)
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(noItemLabel)
        noItemLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noItemLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noItemLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    @objc private func onTapSearchButton() {
        viewModel.onTapSearch(keyword: searchField.stringValue)
    }
    
    @objc private func onTapDonationButton() {
        viewModel.onTapDonation()
    }
    
    @objc private func scrollViewBoundDidChange() {
        // If scrollView has a distance of < 50 to the bottom, fetch the next page
        guard let documentHeight = scrollView.documentView?.bounds.height else {
            return
        }
        let scrollBottomY = scrollView.documentVisibleRect.maxY
        let distanceToBottom = documentHeight - scrollBottomY
        
        if distanceToBottom < 50.0 {
            viewModel.onScrollToBottom()
        }
    }
}

extension VideoListViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSCollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> NSSize {
        if indexPath.section == 1 {
            // size of loadingCell
            return NSSize(width: collectionView.bounds.width, height: 68)
        }
        
        // We want to fit as many columns as possible (while should not exceed 5)
        // The minimum width of a cell is set to 200.
        let cellMaxWidth: CGFloat = 200
        let marginSpacing: CGFloat = 8.0
        let cellSpacing: CGFloat = 16.0
        let availableWidth = collectionView.bounds.width - marginSpacing * 2
        let numOfColumns = floor((availableWidth - cellSpacing) / (cellMaxWidth + cellSpacing))
        let numOfColumnsActual = min(5, numOfColumns)
        let cellWidth = ((availableWidth - cellSpacing) / numOfColumnsActual) - cellSpacing
        return NSSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSCollectionViewLayout,
                        insetForSectionAt section: Int) -> NSEdgeInsets {
        if collectionView.numberOfSections == 1 {
            return NSEdgeInsets(top: 0.0, left: 8.0, bottom: 76.0, right: 12.0)
        } else {
            if section == 0 {
                return NSEdgeInsets(top: 0.0, left: 8.0, bottom: 8.0, right: 12.0)
            } else {
                return NSEdgeInsets(top: 0.0, left: 8.0, bottom: 76.0, right: 12.0)
            }
        }
    }
}

extension VideoListViewController: NSCollectionViewDelegate {}

extension VideoListViewController: NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        viewModel.isLoadingSectionHidden ? 1 : 2
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            // video cell section
            return viewModel.videos.count
        } else {
            // loading section
            return 1
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView,
                        itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if indexPath.section == 0,
            let videoCellItem = self.collectionView.makeItem(withIdentifier: videoCellIdentifier,
                                                             for: indexPath) as? VideoListCellItem {
            return configureAsVideoCell(item: videoCellItem, itemIndex: indexPath.item)
        } else if indexPath.section == 1,
            let loadingCellItem = self.collectionView.makeItem(withIdentifier: loadingCellIdentifier,
                                                               for: indexPath) as? VideoListLoadingCellItem {
            return configureAsLoadingCell(item: loadingCellItem)
        }
        
        return NSCollectionViewItem()
    }
    
    private func configureAsLoadingCell(item: VideoListLoadingCellItem) -> NSCollectionViewItem {
        item
    }
    
    private func configureAsVideoCell(item: VideoListCellItem, itemIndex: Int) -> NSCollectionViewItem {
        let video = viewModel.videos[itemIndex]
        item.configure(title: video.video.title,
                             imageURL: video.video.thumbnail,
                             isAdded: video.isAdded,
                             onAddVideoTap: { [weak self] in
                                self?.viewModel.onTapAddVideo(video.video)
        })
        return item
    }
}

extension VideoListViewController: NSSearchFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            viewModel.onTapSearch(keyword: searchField.stringValue)
            return true
        }
        return false
    }
}
