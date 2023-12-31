//
//  UICollectionViewLeftAlignedLayout.swift
//  UIComponents
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import UIKit

/**
 *  Simple UICollectionViewFlowLayout that aligns the cells to the left rather than justify them
 *
 *  Based on https://stackoverflow.com/questions/13017257/how-do-you-determine-spacing-between-cells-in-uicollectionview-flowlayout
 */
class UICollectionViewLeftAlignedLayout: UICollectionViewFlowLayout {
    private var col: UICollectionView {
        collectionView!
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)?
            .compactMap { $0.representedElementKind == nil ? layoutAttributesForItem(at: $0.indexPath) : $0 }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)?.copy()
                as? UICollectionViewLayoutAttributes else {
            // should never happen
            return nil
        }
        
        let sectionInset = evaluatedSectionInsetForSection(at: indexPath.section)
        
        guard indexPath.item != 0 else {
            currentItemAttributes.leftAlignFrame(withSectionInset: sectionInset)
            return currentItemAttributes
        }
        
        guard let previousFrame = layoutAttributesForItem(at: IndexPath(item: indexPath.item - 1, section: indexPath.section))?.frame else {
            // should never happen
            return nil
        }
        
        // if the current frame, once left aligned to the left and stretched to the full collection view
        // width intersects the previous frame then they are on the same line
        guard previousFrame.intersects(CGRect(x: sectionInset.left, y: currentItemAttributes.frame.origin.y, width: col.frame.width - sectionInset.left - sectionInset.right, height: currentItemAttributes.frame.size.height)) else {
            // make sure the first item on a line is left aligned
            currentItemAttributes.leftAlignFrame(withSectionInset: sectionInset)
            return currentItemAttributes
        }
        
        currentItemAttributes.frame.origin.x = previousFrame.origin.x + previousFrame.size.width + evaluatedMinimumInteritemSpacingForSection(at: indexPath.section)
        return currentItemAttributes
    }
    
    func evaluatedMinimumInteritemSpacingForSection(at section: NSInteger) -> CGFloat {
        return (col.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(col, layout: self, minimumInteritemSpacingForSectionAt: section) ?? minimumInteritemSpacing
    }
    
    func evaluatedSectionInsetForSection(at index: NSInteger) -> UIEdgeInsets {
        return (col.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(col, layout: self, insetForSectionAt: index) ?? sectionInset
    }
}

extension UICollectionViewLayoutAttributes {
    func leftAlignFrame(withSectionInset sectionInset: UIEdgeInsets) {
        frame.origin.x = sectionInset.left
    }
}

