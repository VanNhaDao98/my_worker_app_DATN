//
//  UITableView+Exts.swift
//  Utils
//
//  Created by Dao Van Nha on 09/10/2023.
//

import Foundation
import UIKit

public extension UITableView {
    
    func defauleSetup() {
        if style == .plain {
            tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: bounds.size.width, height: 1))
            tableFooterView = UIView(frame: .init(x: 0, y: 0, width: bounds.size.width, height: 1))
        }
        
        keyboardDismissMode = .interactive
        
        if #available(iOS 15, *) {
            #if swift(>=5.5)
            sectionHeaderTopPadding = 0
            #endif
        }
    }
}

public extension UITableView {

    func dequeueReusableCell<T: UITableViewCell>(type: T.Type,
                                                 withIdentifier identifier: String? = nil,
                                                 for indexPath: IndexPath) -> T {
        let reuseId = identifier ?? type.reuseId
        guard let cell = self.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? T else {
            fatalError("\(String(describing: self)) could not dequeue cell with identifier: \(reuseId)")
        }
        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(type: T.Type,
                                                                         withIdentifier identifier: String? = nil) -> T {
        let reuseId = identifier ?? type.reuseId
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: reuseId) as? T else {
            fatalError("\(String(describing: self)) could not dequeue view with identifier: \(reuseId)")
        }
        return view
    }
}

public extension UITableView {
//    convenience init(frame: CGRect = .zero,
//                     style: UITableView.Style = .plain,
//                     dataSource: UITableViewDataSource?,
//                     delegate: UITableViewDelegate?) {
//
//        self.init(frame: frame, style: style)
//
//        /// `commonSetup` sets `tableFooterView` to new value, it triggers dataSource methods
//        /// and cause infinite loop if we reference tableView inside dataSource methods,
//        /// so we have to set `dataSource` after `comonSetup`
//        defaultSetup()
//        
//        self.dataSource = dataSource
//        self.delegate = delegate
//    }
//
//    /// Setup some common properties for table view
//    func defaultSetup() {
//        /// Grouped table view doesn't need this to remove empty separator
//        /// Also if we set this in grouped tableview, section header and footer won't display properly
//        if style == .plain {
//            tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 1))
//            tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 1))
//        }
//
////        separatorColor = .tableSeparator
//        keyboardDismissMode = .interactive
//        
//        if #available(iOS 15.0, *) {
//            #if swift(>=5.5)
//            sectionHeaderTopPadding = 0
//            #endif
//        }
//    }

    func insertRows(_ rows: [Int], inSection section: Int, animated: Bool = true) {
        insertRows(at: rows.map { IndexPath(row: $0, section: section) }, with: animated ? .automatic : .none)
    }

    func deleteRow(_ row: Int, inSection section: Int, animated: Bool = true) {
        deleteRows(at: [IndexPath(row: row, section: section)], with: animated ? .automatic : .none)
    }

    func deleteRows(_ rows: [Int], inSection section: Int, animated: Bool = true) {
        deleteRows(at: rows.map { IndexPath(row: $0, section: section) }, with: animated ? .automatic : .none)
    }

    func reloadRow(_ row: Int, inSection section: Int, animated: Bool = true) {
        reloadRows(at: [IndexPath(row: row, section: section)], with: animated ? .automatic : .none)
    }

    func reloadRows(_ rows: [Int], inSection section: Int, animated: Bool = true) {
        reloadRows(at: rows.map { IndexPath(row: $0, section: section) }, with: animated ? .automatic : .none)
    }

    func reloadSection(_ section: Int, animated: Bool = true) {
        reloadSections(IndexSet(integer: section), with: animated ? .automatic : .none)
    }
    
    func batchUpdates(_ updates: (UITableView) -> Void, completion: ((Bool) -> Void)? = nil) {
        if #available(iOS 11.0, *) {
            performBatchUpdates({
                updates(self)
            }, completion: completion)
        } else {
            beginUpdates()
            updates(self)
            endUpdates()
            completion?(true)
        }
    }

    func alertRow(at indexPath: IndexPath) {
        scrollToRow(at: indexPath, at: .middle, animated: true)
        selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.deselectRow(at: indexPath, animated: true)
        }
    }

    func alertSection(_ section: Int) {
        let numberOfRows = self.numberOfRows(inSection: section)
        let indexPaths = (0..<numberOfRows).map({ IndexPath(row: $0, section: section) })

        guard let firstIndexPath = indexPaths.first else {
            return
        }

        scrollToRow(at: firstIndexPath, at: .middle, animated: true)

        for indexPath in indexPaths {
            selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}

