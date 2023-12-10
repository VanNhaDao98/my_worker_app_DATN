//
//  BottomSheetListDataSource.swift
//  UIComponents
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import UIKit
import Utils

class BottomSheetListDataSource<T>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private struct FilteredItem {
        let index: Int
        let item: BottomSheetListItem<T>
    }
    
    private var items: [BottomSheetListItem<T>] {
        didSet {
            emptyStateDidChanged?(displayItems.isEmpty, filteredItems != nil)
        }
    }
    private var filteredItems: [FilteredItem]? {
        didSet {
            emptyStateDidChanged?(displayItems.isEmpty, filteredItems != nil)
        }
    }
    private let config: BottomSheetListConfig<T>
    
    private var keyword: String?
    private var displayItems: [BottomSheetListItem<T>] {
        filteredItems?.map { $0.item } ?? items
    }
    
    private var isSelectedAll: Bool {
        items.allSatisfy({ $0.isSelected })
    }
    
    private var isSelectedSome: Bool {
        let count = items.filter({ $0.isSelected }).count
        return count > 0 && count < items.count
    }
    
    private let enableSelectAll: Bool
    
    var selectedItemsDidChanged: (() -> Void)?
    var emptyStateDidChanged: ((_ isEmpty: Bool, _ isFiltering: Bool) -> Void)?
    var reloadData: (() -> Void)?
    
    var useLocalSearch: Bool = true
    
    var selectedItems: BottomSheetListConfig<T>.SelectedInfo {
        let selectedItems = items.enumerated().filter { $0.element.isSelected }
        return (selectedItems.map { $0.offset }, selectedItems.map { $0.element })
    }
    
    init(items: [BottomSheetListItem<T>], config: BottomSheetListConfig<T>) {
        self.items = items
        self.config = config
        self.enableSelectAll = config.enableSelectAll && config.allowMultipleSelections
    }
    
    func invalidateEmptyState() {
        emptyStateDidChanged?(displayItems.isEmpty, filteredItems != nil)
    }
    
    func removeSelectedItem(at index: Int) {
        /// convert index in `items` from index of selected items
        let realIndex = items.enumerated().filter({ $0.element.isSelected })[index].offset
        
        items[realIndex].isSelected = false
        
        if filteredItems != nil {
            filterItems(by: keyword)
        }
        
        reloadData?()
        selectedItemsDidChanged?()
    }
    
    func insert(items: [BottomSheetListItem<T>],
                validation: @escaping ([BottomSheetListItem<T>]) -> Bool = { _ in true }) {
        if !validation(self.items) {
            return
        }
        
        self.items.insert(contentsOf: items, at: 0)
        filterItems(by: keyword)
        reloadData?()
        selectedItemsDidChanged?()
    }
    
    func append(items: [BottomSheetListItem<T>],
                validation: @escaping ([BottomSheetListItem<T>]) -> Bool = { _ in true }) {
        if !validation(self.items) {
            return
        }
        
        self.items.append(contentsOf: items)
        filterItems(by: keyword)
        reloadData?()
    }
    
    func replace(items: [BottomSheetListItem<T>]) where T: BottomSheetListIdentifiableItem {
        var items = items
        
        // keep currently selected items
        if self.items.notEmpty {
            for i in items.indices {
                if let existed = self.items.first(where: { $0.rawData.id == items[i].rawData.id }) {
                    items[i].isSelected = existed.isSelected
                }
            }
        }
        self.items = items
        filterItems(by: keyword)
        reloadData?()
    }
    
    func reload(item: BottomSheetListItem<T>, at index: Int) {
        self.items[index] = item
    }
    
    private func config(cell: BottomSheetListCell, index: Int) {
        cell.update(item: displayItems[index],
                    useCheckbox: config.allowMultipleSelections,
                    checkboxStyle: .full,
                    separatorEnabled: false)
    }
    
    private func config(tableView: UITableView, customCell: UITableViewCell, index: Int) {
        config.customCellConfig?.cellConfig((customCell, displayItems[index], index, { [weak self] in
            if let indexPath = tableView.indexPath(for: customCell) {
                self?.tableView(tableView, didSelectRowAt: indexPath)
            }
        }))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayItems.count + (enableSelectAll ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if enableSelectAll && indexPath.row == 0 {
            return tableView
                .dequeueReusableCell(type: BottomSheetListCell.self, for: indexPath)
                .then { cell in
                    cell.updateSelectAllItem(isSelected: isSelectedSome || isSelectedAll,
                                             isPartial: isSelectedSome)
                }
        }
        
        let index = enableSelectAll ? indexPath.row - 1 : indexPath.row
        if let customCellConfig = config.customCellConfig {
            let cell = tableView.dequeueReusableCell(type: customCellConfig.cellType,
                                                     for: indexPath)
            config(tableView: tableView, customCell: cell, index: index)
            return cell
        }
        
        return tableView
            .dequeueReusableCell(type: BottomSheetListCell.self, for: indexPath)
            .then { cell in
                self.config(cell: cell, index: index)
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if enableSelectAll && indexPath.row == 0 {
            return 56.0
        }
        
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        handleSelectRow(tableView, at: indexPath)
    }
    
    private func handleSelectRow(_ tableView: UITableView, at indexPath: IndexPath) {
        if enableSelectAll && indexPath.row == 0 {
            let isSelected = !isSelectedAll
            for index in items.indices where items[index].isEditable {
                items[index].isSelected = isSelected
                replaceItemIfNeeded(at: index)
            }
            
            tableView.reloadSection(0)
            selectedItemsDidChanged?()
            return
        }
        
        let itemIndex = enableSelectAll ? indexPath.row - 1 : indexPath.row
        _handleSelectRow(tableView: tableView, at: itemIndex, indexPath: indexPath)
    }
    
    private func _handleSelectRow(tableView: UITableView,
                                  at index: Int,
                                  indexPath: IndexPath) {
        let selectedIndex: Int
        
        if let filteredItems = filteredItems {
            selectedIndex = filteredItems[index].index
        } else {
            selectedIndex = index
        }
        
        guard items[selectedIndex].isEditable else {
            return
        }
        
        defer {
            selectedItemsDidChanged?()
        }
        
        items[selectedIndex].isSelected.toggle()
        replaceItemIfNeeded(at: selectedIndex)
        
        filterItems(by: keyword)
        
        if let cell = tableView.cellForRow(at: indexPath) as? BottomSheetListCell {
            config(cell: cell, index: index)
        } else if let cell = tableView.cellForRow(at: indexPath) {
            config(tableView: tableView, customCell: cell, index: index)
        } else {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        if enableSelectAll {
            tableView.reloadRow(0, inSection: 0, animated: false)
        }
        
        let isSelected = displayItems[index].isSelected
        if !config.allowMultipleSelections && isSelected {
            var indexPathsToReload: [IndexPath] = []
            
            for index in items.indices where index != selectedIndex && items[index].isSelected {
                items[index].isSelected = false
                replaceItemIfNeeded(at: index)
                filterItems(by: keyword)
                
                let idxPath: IndexPath
                
                if let filteredIndex = filteredItems?.firstIndex(where: { $0.index == index }) {
                    idxPath = IndexPath(row: filteredIndex, section: 0)
                } else {
                    idxPath = IndexPath(row: index, section: 0)
                }
                
                if let cell = tableView.cellForRow(at: idxPath) as? BottomSheetListCell {
                    config(cell: cell, index: idxPath.row)
                } else if let cell = tableView.cellForRow(at: idxPath) {
                    config(tableView: tableView, customCell: cell, index: idxPath.row)
                } else {
                    indexPathsToReload.append(idxPath)
                }
            }
            
            if !indexPathsToReload.isEmpty {
                tableView.reloadRows(at: indexPathsToReload, with: .automatic)
            }
        }
        
        let selectedItems = items.enumerated().filter { $0.element.isSelected }
        
        // if show confirm button, callback only when press confirm
        if !config.showConfirmButton {
            DispatchQueue.main.async {
                self.config.didSelectItems(
                    (
                        selectedItems.map { $0.offset },
                        selectedItems.map { $0.element }
                    )
                )
            }
            
            // dismiss if only allow single selection
            if !config.allowMultipleSelections && config.autoDismiss {
                BottomSheet.hide()
            }
        }
    }
    
    private func replaceItemIfNeeded(at index: Int) {
        if let newItem = config.itemSelectionChangedHandler(items[index]) {
            items[index] = newItem
        }
    }
    
    func filterItems(by keyword: String?) {
        guard useLocalSearch else {
            return
        }
        
        self.keyword = keyword
        
        guard String.notBlank(keyword) else {
            filteredItems = nil
            return
        }
        
        filteredItems = items
            .enumerated()
            .map { ($0.offset, $0.element) }
            .filter(by: keyword, comparingBy: { $1.title.string })
            .map { .init(index: $0.0, item: $0.1) }
    }
}

