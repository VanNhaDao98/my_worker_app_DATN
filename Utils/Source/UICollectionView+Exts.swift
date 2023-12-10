//
//  UICollectionView+Exts.swift
//  Utils
//
//  Created by Dao Van Nha on 16/10/2023.
//

import Foundation
import UIKit

public extension UICollectionView {

    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type,
                                                      withIdentifier identifier: String? = nil,
                                                      for indexPath: IndexPath) -> T {
        let reuseId = identifier ?? type.reuseId
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? T else {
            fatalError("\(String(describing: self)) could not dequeue cell with identifier: \(reuseId)")
        }
        return cell
    }
    
    func dequeueReusableHeaderView<T: UICollectionReusableView>(type: T.Type,
                                                                withIdentifier identifier: String? = nil,
                                                                for indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                         type: type,
                                         withIdentifier: identifier,
                                         for: indexPath)
    }
    
    func dequeueReusableFooterView<T: UICollectionReusableView>(type: T.Type,
                                                                withIdentifier identifier: String? = nil,
                                                                for indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                         type: type,
                                         withIdentifier: identifier,
                                         for: indexPath)
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind: String,
                                                                       type: T.Type,
                                                                       withIdentifier identifier: String? = nil,
                                                                       for indexPath: IndexPath) -> T {
        let reuseId = identifier ?? type.reuseId
        guard let view = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: reuseId, for: indexPath) as? T else {
            fatalError("\(String(describing: self)) could not dequeue reusable supplementary view with identifier: \(reuseId)")
        }
        return view
    }
}

public extension UICollectionView {
    func reloadVisibleItems() {
        guard !indexPathsForVisibleItems.isEmpty else {
            return
        }
        
        reloadItems(at: indexPathsForVisibleItems)
    }
}

