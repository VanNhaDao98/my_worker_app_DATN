//
//  BottomSheetListView.swift
//  UIComponents
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import UIKit
import SnapKit
import Utils

class BottomSheetListView<T>: UIView, BottomSheetContentView {
    
    static var defaultRowHeight: CGFloat {
        52.0
    }
    
    private let listDataSource: BottomSheetListDataSource<T>
    private let listConfig: BottomSheetListConfig<T>
    
    private let tableView: UITableView
    private let searchView: UIView = .init()
    private let emptyView: UIView = .init()
    private let tagsContainerView: UIView = .init()
    private let tagsView: TagCollectionView = .init(tags: [])
    private let searchField: SearchField = .init()
    private let confirmButton: Button = .init().then({ $0.configCommon() })
    
    var interactor: BottomSheetListInteractor<T>?
    
    var innerScrollView: UIScrollView? {
        tableView
    }
    
    init(listDataSource: BottomSheetListDataSource<T>,
         tableStyle: UITableView.Style = .plain,
         config: BottomSheetListConfig<T>) {
        self.listDataSource = listDataSource
        self.listConfig = config
        self.tableView = InternalTableView(frame: .init(x: 0, y: 0,
                                                        width: UIScreen.main.bounds.width,
                                                        height: 0),
                                           style: tableStyle)
        
        super.init(frame: .init(x: 0, y: 0,
                                width: UIScreen.main.bounds.width,
                                height: 0))
        self.config()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil, let loadItems = interactor?.callback?.requestLoadItems {
            listDataSource.useLocalSearch = false
            searchField.debounceSearch = true
            tableView.addLoadMoreHandler { [weak self] in
                loadItems(self?.searchField.text, false)
            }
            
            loadItems(nil, true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func insert(items: [BottomSheetListItem<T>],
                validation: @escaping ([BottomSheetListItem<T>]) -> Bool = { _ in true }) {
        listDataSource.insert(items: items, validation: validation)
        tableView.finishLoadMore()
    }
    
    func append(items: [BottomSheetListItem<T>],
                validation: @escaping ([BottomSheetListItem<T>]) -> Bool = { _ in true }) {
        listDataSource.append(items: items, validation: validation)
        tableView.finishLoadMore()
    }
    
    func replace(items: [BottomSheetListItem<T>]) where T: BottomSheetListIdentifiableItem {
        listDataSource.replace(items: items)
        tableView.finishLoadMore()
    }
    
    func replace(item: BottomSheetListItem<T>, at index: Int, reload: Bool = true, animated: Bool = true) {
        listDataSource.reload(item: item, at: index)
        
        if reload {
            let tableIndex = listConfig.enableSelectAll ? index + 1 : index
            tableView.reloadRows([tableIndex], inSection: 0, animated: animated)
            
            if listConfig.enableSelectAll {
                tableView.reloadRows([0], inSection: 0, animated: animated)
            }
        }
    }
    
    private func config() {
        tableView.dataSource = listDataSource
        tableView.delegate = listDataSource
        tableView.estimatedRowHeight = BottomSheetListView.defaultRowHeight
        tableView.rowHeight = listConfig.customRowHeight ?? UITableView.automaticDimension
        tableView.register(BottomSheetListCell.self, forCellReuseIdentifier: BottomSheetListCell.reuseId)
        
        if let customCellConfig = listConfig.customCellConfig {
            if let nib = customCellConfig.cellNib {
                tableView.register(nib,
                                   forCellReuseIdentifier: customCellConfig.cellType.reuseId)
            } else {
                tableView.register(customCellConfig.cellType,
                                   forCellReuseIdentifier: customCellConfig.cellType.reuseId)
            }
            
            tableView.estimatedRowHeight = BottomSheetListView.defaultRowHeight
            tableView.rowHeight = listConfig.customRowHeight ?? UITableView.automaticDimension
        }
        
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        listDataSource.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }
        
        searchView.addSubview(searchField)
        searchField.snp.makeConstraints {
            $0.edges.equalToSuperview()
                .inset(UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12))
                .priority(.init(999))
        }
        
        searchView.isHidden = !listConfig.isSearchEnabled
        
        searchField.debounceSearch = false
        searchField.textDidChanged = { [weak self] text in
            if let loadItems = self?.interactor?.callback?.requestLoadItems {
                loadItems(text, true)
                return
            }
            
            self?.listDataSource.filterItems(by: text)
            self?.tableView.reloadData()
        }
        listConfig.searchFieldConfig?(searchField)
        
        confirmButton.title = "Hoàn tất"
        confirmButton.action = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.listConfig.didSelectItems(self.listDataSource.selectedItems)
            }
            if self.listConfig.autoDismiss {
                BottomSheet.hide()
            }
        }
        
        buildSelectedItemsView()
        buildEmptyView()
        
        let stackView = UIStackView(arrangedSubviews: [searchView, tagsContainerView, emptyView, tableView])
        stackView.axis = .vertical
        stackView.spacing = 0
        
        stackView.setCustomSpacing(8, after: searchView)
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        if listConfig.showConfirmButton {
            let line = UIView()
            line.backgroundColor = ColorConstant.lineView
            let confirmButtonContainer = UIView()
            confirmButtonContainer.addSubview(line)
            confirmButtonContainer.addSubview(confirmButton)
            stackView.addArrangedSubview(confirmButtonContainer)

            line.snp.makeConstraints({
                $0.height.equalTo(1)
                $0.top.leading.trailing.equalToSuperview()
            })
            confirmButton.snp.makeConstraints({
                $0.leading.trailing.equalToSuperview().inset(16.0).priority(.init(999))
                $0.top.equalToSuperview().inset(12.0)
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(16.0)
            })
        }
    }
    
    private func buildEmptyView() {
        let emptyLabel = UILabel()
        emptyLabel.textColor = ColorConstant.text
        emptyLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        
        emptyView.backgroundColor = .clear
        emptyView.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints({
            $0.edges.equalToSuperview()
                .inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
                .priority(.init(99))
        })
        
        listDataSource.emptyStateDidChanged = { [weak self] isEmpty, isFiltering in
            self?.emptyView.setHiddenIfChange(!isEmpty)
            emptyLabel.text = isFiltering
            ? "Không có kết quả trả về"
            : "Không có dữ liệu"
        }
        listDataSource.invalidateEmptyState()
    }
    
    private func buildSelectedItemsView() {
        tagsContainerView.isHidden = !listConfig.showTagsView
        
        guard listConfig.showTagsView else {
            return
        }
        
        let borderView = BorderedView()
        tagsContainerView.addSubview(tagsView)
        tagsContainerView.addSubview(borderView)
        borderView.backgroundColor = .systemBackground
        borderView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(tagsView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(8)
        })
        tagsView.snp.makeConstraints({
            $0.top.leading.trailing.equalToSuperview()
        })
        
        tagsContainerView.isHidden = true
        
        tagsView.sizingMode = .auto(min: nil, max: nil)
        tagsView.contentInset = .init(top: 8, left: 16, bottom: 0, right: 16)
        
        let reloadTags = { [weak self] (animated: Bool) in
            guard let self else { return }
            let items = self.listDataSource.selectedItems.items
            let tags = items.map({ $0.title.string })
            self.tagsView.setTags(tags, animated: animated)
            
            UIView.animate(withDuration: 0.2) {
                self.tagsContainerView.setHiddenIfChange(items.isEmpty)
            }
        }
        
        tagsView.maxTagsCount = 4
        tagsView.didDeleteTag = { [weak self] in
            guard let self else { return }
            self.listDataSource.removeSelectedItem(at: $0)
            if self.tagsView.tags.isEmpty {
                UIView.animate(withDuration: 0.2) {
                    self.tagsContainerView.isHidden = true
                }
            }
        }
        tagsView.tagConfig = { [weak self] index, tag in
            guard let self else { return }
            let items = self.listDataSource.selectedItems.items
            tag.showDelete = items[index].isEditable
            tag.maxCharactersCount = 20
            tag.style = .plain
            tag.textColor = ColorConstant.text
        }
        
        listDataSource.selectedItemsDidChanged = {
            reloadTags(true)
        }
        
        reloadTags(false)
    }
}

private class InternalTableView: UITableView {
    
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.config()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.config()
    }
    
    private func config() {
        delaysContentTouches = true
    }
    
    open override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }
}

