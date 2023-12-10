//
//  BottomSheetListInteractor.swift
//  UIComponents
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import UIKit

// Use to interact with list of bottom sheet
public class BottomSheetListInteractor<T> {
    private weak var view: BottomSheetListView<T>?
    
    public struct Callback {
        public var requestLoadItems: (_ query: String?,
                                      _ isRefresh: Bool) -> Void
        
        public init(requestLoadItems: @escaping (_ query: String?,
                                                 _ isRefresh: Bool) -> Void) {
            self.requestLoadItems = requestLoadItems
        }
    }
    
    public var callback: Callback?
    
    init(view: BottomSheetListView<T>) {
        self.view = view
    }
    
    /// Insert new items into top of list
    /// - Parameters:
    ///   - items: new items
    ///   - validation: validation block, validate against current items
    public func insert(items: [BottomSheetListItem<T>],
                       validation: @escaping ([BottomSheetListItem<T>]) -> Bool = { _ in true }) {
        view?.insert(items: items, validation: validation)
    }
    
    /// Append new items into list
    /// - Parameters:
    ///   - items: new items
    ///   - validation: validation block, validate against current items
    public func append(items: [BottomSheetListItem<T>],
                       validation: @escaping ([BottomSheetListItem<T>]) -> Bool = { _ in true }) {
        view?.append(items: items, validation: validation)
    }
    
    /// Replace all items. Item `rawData` must conforms to `BottomSheetListIdentifiableItem`
    /// so BottomSheet can keep currently select items when reload data.
    /// - Parameters:
    ///   - items: new items
    public func replace(items: [BottomSheetListItem<T>]) where T: BottomSheetListIdentifiableItem {
        view?.replace(items: items)
    }
    
    public func replace(item: BottomSheetListItem<T>, at index: Int,
                        reload: Bool = true,
                        animated: Bool = true) {
        view?.replace(item: item, at: index, reload: reload, animated: animated)
    }
}

