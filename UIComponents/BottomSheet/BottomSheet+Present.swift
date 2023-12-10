//
//  BottomSheet+Present.swift
//  UIComponents
//
//  Created by Dao Van Nha on 14/10/2023.
//

import Foundation
import Utils
import UIKit

public extension BottomSheet {
    private static var currentPanels: ContiguousArray<WeakRef<UIViewController>> = []
    
    @discardableResult
    static func show(contentView: BottomSheetContentView,
                     sheetConfig: BottomSheetConfig = .default,
                     from presenter: UIViewController) -> BottomSheet {
        let bottomSheet = BottomSheet()
        bottomSheet.setContentView(contentView,
                                   handleKeyboard: sheetConfig.keyboardHandlingMode == .updateHeight)
        bottomSheet.title = sheetConfig.title
        bottomSheet.showCloseButton = sheetConfig.showCloseButton
        
        if let titleAction = sheetConfig.titleAction {
            bottomSheet.configAction { button in
                button.title = titleAction.title
                button.leftIcon = titleAction.image
                button.action = {
                    bottomSheet.view.endEditing(false)
                    titleAction.action()
                }
            }
        }
        
        bottomSheet.showTitle = String.notBlank(sheetConfig.title) || sheetConfig.showCloseButton
        
        let panel = bottomSheet.showAsBottomSheet(config: sheetConfig, from: presenter)
        currentPanels.append(.init(object: panel))
        return bottomSheet
    }
    
    static func current() -> UIViewController? {
        currentPanels.last?.object
    }
    
    static func hide(animated: Bool = true,
                     completion: (() -> Void)? = nil) {
        if currentPanels.isEmpty {
            completion?()
            return
        }
        
        let panel = currentPanels.removeLast()
        panel.object?.dismiss(animated: animated, completion: completion)
    }
}

public extension BottomSheet {
    
    @discardableResult
    static func show<T>(items: [BottomSheetListItem<T>],
                        sheetConfig: BottomSheetConfig = .default,
                        listConfig: BottomSheetListConfig<T> = .default,
                        interactor interact: ((BottomSheetListInteractor<T>) -> Void)? = nil,
                        from presenter: UIViewController) -> BottomSheet {
        let dataSource = BottomSheetListDataSource(items: items, config: listConfig)
        let contentView = BottomSheetListView(listDataSource: dataSource, config: listConfig)
        let interactor = BottomSheetListInteractor(view: contentView)
        contentView.interactor = interactor
        interact?(interactor)
        return show(contentView: contentView, sheetConfig: sheetConfig, from: presenter)
    }
    
    @discardableResult
    static func show<T>(items: [BottomSheetListItem<T>],
                        config: BottomSheetConfig = .default,
                        title: String? = nil,
                        showCloseButton: Bool? = nil,
                        sizeFitItems: Bool = false,
                        sizes: [BottomSheetConfig.Size] = [.medium, .full],
                        customRowHeight: CGFloat? = nil,
                        allowMultipleSelections: Bool? = nil,
                        autoDismiss: Bool? = nil,
                        enableSelectAll: Bool? = nil,
                        searchable: Bool? = nil,
                        showTags: Bool? = nil,
                        interactor: ((BottomSheetListInteractor<T>) -> Void)? = nil,
                        customCellConfig: BottomSheetListCustomCellConfig<T>? = nil,
                        itemSelectionChangedHandler: ((BottomSheetListItem<T>) -> BottomSheetListItem<T>?)? = nil,
                        from presenter: UIViewController,
                        didSelectItems: @escaping ([Int], [T]) -> Void) -> BottomSheet {
        let listConfig = BottomSheetListConfig<T>.default.with({
            if let allowMultipleSelections {
                $0.allowMultipleSelections = allowMultipleSelections
            }
            if let enableSelectAll {
                $0.enableSelectAll = enableSelectAll
            }
            if let allowMultipleSelections {
                $0.showConfirmButton = allowMultipleSelections
            }
            if let searchable {
                $0.isSearchEnabled = searchable
            }
            if let showTags {
                $0.showTagsView = showTags
            }
            if let autoDismiss {
                $0.autoDismiss = autoDismiss
            }
            if let itemSelectionChangedHandler {
                $0.itemSelectionChangedHandler = itemSelectionChangedHandler
            }
            if let customRowHeight {
                $0.customRowHeight = customRowHeight
            }
            
            $0.customCellConfig = customCellConfig
            $0.didSelectItems = { result in
                let (indexes, items) = result
                didSelectItems(indexes, items.map({ $0.rawData }))
            }
        })
        
        let sheetConfig = config.with({
            $0.title = title
            
            if let showCloseButton {
                $0.showCloseButton = showCloseButton
            } else {
                $0.showCloseButton = title != nil
            }
            
            if sizeFitItems {
                $0.sizes = [.forItems(count: items.count,
                                      withTitle: title != nil || $0.showCloseButton,
                                      customRowHeight: listConfig.customRowHeight)]
            } else {
                $0.sizes = sizes
            }
        })
        
        return show(items: items,
                    sheetConfig: sheetConfig,
                    listConfig: listConfig,
                    interactor: interactor,
                    from: presenter)
    }
    
    @discardableResult
    static func showEdit(config: BottomSheetEditConfig,
                         sheetConfig: BottomSheetConfig = .default,
                         from presenter: UIViewController) -> BottomSheet {
        let contentView = BottomSheetEditView(config: config)
        let sheetConfig = sheetConfig.with({
            $0.sizes = [.intrinsic]
            $0.keyboardHandlingMode = .updateHeight
        })
        return show(contentView: contentView,
                    sheetConfig: sheetConfig,
                    from: presenter)
    }
}

