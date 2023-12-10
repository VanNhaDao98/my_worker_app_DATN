//
//  BottomSheetListConfig.swift
//  UIComponents
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import UIKit
import Utils

public class BottomSheetListCustomCellConfig<T> {
    
    typealias RawCellConfiguration = (cell: UITableViewCell,
                                      item: BottomSheetListItem<T>,
                                      index: Int,
                                      selectAction: () -> Void)
    
    public typealias CellConfiguration<C> = (cell: C,
                                             item: BottomSheetListItem<T>,
                                             index: Int,
                                             selectAction: () -> Void) where C: UITableViewCell
    
    let cellType: UITableViewCell.Type
    let cellNib: UINib?
    let cellConfig: (RawCellConfiguration) -> Void
    
    public init<C>(cellType: C.Type,
                   cellNib: UINib?,
                   cellConfig: @escaping (CellConfiguration<C>) -> Void) where C: UITableViewCell {
        self.cellType = cellType
        self.cellNib = cellNib
        
        // erase cell type
        self.cellConfig = { data in
            let (cell, item, index, selectAction) = data
            // swiftlint:disable force_cast
            cellConfig((cell as! C, item, index, selectAction))
            // swiftlint:enable force_cast
        }
    }
}

public struct BottomSheetListConfig<T> {
    public typealias SelectedInfo = (indexes: [Int], items: [BottomSheetListItem<T>])
    
    public var allowMultipleSelections: Bool = false
    public var enableSelectAll: Bool = false
    public var showConfirmButton: Bool = false
    public var isSearchEnabled: Bool = false
    public var searchFieldConfig: ((SearchField) -> Void)?
    public var showTagsView: Bool = false
    public var didSelectItems: (SelectedInfo) -> Void
    public var autoDismiss: Bool = true
    public var customRowHeight: CGFloat?
    
    public var interactor: BottomSheetListInteractor<T>?
    public var customCellConfig: BottomSheetListCustomCellConfig<T>?
    
    /// Add a opportunity to modify item when selected state changed. Return `nil` to keep original item.
    public var itemSelectionChangedHandler: (BottomSheetListItem<T>) -> BottomSheetListItem<T>? = { _ in nil }
    
    public init(didSelectItems: @escaping (SelectedInfo) -> Void) {
        self.didSelectItems = didSelectItems
    }
    
    public static var `default`: BottomSheetListConfig {
        .init(didSelectItems: { _ in })
    }
}

extension BottomSheetListConfig: Then {}

