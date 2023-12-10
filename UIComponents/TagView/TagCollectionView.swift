//
//  TagCollectionView.swift
//  UIComponents
//
//  Created by Dao Van Nha on 16/10/2023.
//
import Foundation
import UIKit
import Utils
import SnapKit

public class TagCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private struct Tag {
        var title: String
        var isMoreTag: Bool = false
    }
    
    private var contentSizeObserver: NSObjectProtocol?
    private var heightConstraint: NSLayoutConstraint!
    
    public enum SizingMode: Equatable {
        case fixed
        case auto(min: CGFloat?, max: CGFloat?)
    }
    
    private var displayTags: [Tag] = []
    
    public private(set) var tags: [String] = []
    
    public var sizingMode: SizingMode = .fixed {
        didSet {
            switch sizingMode {
            case .fixed:
                heightConstraint.isActive = false
            case .auto(let min, let max):
                heightConstraint.isActive = true
                
                if let min = min, heightConstraint.constant < min {
                    updateHeightConstraint(min)
                }
                if let max = max, heightConstraint.constant > max {
                    updateHeightConstraint(max)
                }
            }
        }
    }
    
    public var heightDidChanged: ((CGFloat) -> Void)?
    
    public init(tags: [String]) {
        let layout = UICollectionViewLeftAlignedLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.tags = tags
        generateTags()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var tagConfig: ((Int, TagView) -> Void)? {
        didSet {
            reloadData()
        }
    }
    
    public var maxTagsCount: Int = .max {
        didSet {
            reloadData()
        }
    }
    
    public var didSelectTag: ((Int) -> Void)?
    public var shouldDeleteTag: (Int) -> Bool = { _ in true }
    public var didDeleteTag: ((Int) -> Void)?
    
    public var isEmpty: Bool {
        tags.isEmpty
    }

    public var direction: UICollectionView.ScrollDirection {
        get {
            (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection ?? .vertical
        }
        set {
            (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = newValue
        }
    }
    
    private func setup() {
        backgroundColor = .clear
        
        dataSource = self
        delegate = self
        
        allowsSelection = true
        
        register(TagCollectionItemCell.self,
                 forCellWithReuseIdentifier: TagCollectionItemCell.reuseId)
        
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = sizingMode != .fixed
        observeContentSizeChange()
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // allow tap to cell
        if indexPathForItem(at: point) != nil {
            return super.hitTest(point, with: event)
        }
        
        // ignore tap in the collectionview itself, to allow tap to the view under it
        return nil
    }
    
    private func observeContentSizeChange() {
        contentSizeObserver = observe(\.contentSize,
                                       options: [.old, .new],
                                       changeHandler: handleContentSizeChange)
    }

    private func handleContentSizeChange(view: TagCollectionView,
                                         change: NSKeyValueObservedChange<CGSize>) {
        guard let new = change.newValue, case .auto(let min, let max) = sizingMode else {
            return
        }

        var constant = new.height + view.contentInset.top + view.contentInset.bottom
        
        if let min = min, constant < min {
            constant = min
        }
        if let max = max, constant > max {
            constant = max
        }

        guard let old = change.oldValue else {
            updateHeightConstraint(constant)
            return
        }

        if old.height != new.height {
            updateHeightConstraint(constant)
        }
    }
    
    private func updateHeightConstraint(_ value: CGFloat) {
        heightConstraint.constant = value
        heightDidChanged?(heightConstraint.constant)
    }
    
    private func generateTags() {
        displayTags = tags.prefix(maxTagsCount).map({ .init(title: $0) })
        
        if tags.count > maxTagsCount {
            displayTags.append(.init(title: "+\(tags.count - maxTagsCount)",
                                      isMoreTag: true))
        }
    }
    
    private func addTags(from newTags: [String]) {
        tags.append(contentsOf: newTags)
        generateTags()
    }
    
    private func removeTag(at index: Int) {
        tags.remove(at: index)
        generateTags()
    }
    
    private func animateReloadTags(oldCount: Int) {
        performBatchUpdates {
            if oldCount > 0 {
                deleteItems(at: (0..<oldCount).map({ IndexPath(item: $0, section: 0) }))
            }
            if !displayTags.isEmpty {
                insertItems(at: (0..<displayTags.count).map({ IndexPath(item: $0, section: 0) }))
            }
        }
    }
    
    public func setTags(_ items: [String], animated: Bool = false) {
        let oldCount = self.displayTags.count
        
        self.tags = items
        generateTags()
        
        if !animated {
            self.reloadData()
            return
        }
        
        animateReloadTags(oldCount: oldCount)
    }
    
    public func addTags(_ items: [String], animated: Bool = false) {
        addTags(from: items)
        
        if !animated || displayTags.isEmpty {
            self.reloadData()
            return
        }
        
        let oldCount = displayTags.count - items.count
        if oldCount > 0 {
            insertItems(at: (oldCount..<displayTags.count).map({ IndexPath(item: $0, section: 0) }))
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        displayTags.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: TagCollectionItemCell.self, for: indexPath)
        cell.collectionView = collectionView
        
        let tag = displayTags[indexPath.item]
        
        tagConfig?(indexPath.item, cell.tagView)
        
        cell.tagView.text = tag.title
        cell.tagView.deleteAction = { [unowned cell] in
            self.handleDeleteTag(cell: cell)
        }
        
        if tag.isMoreTag {
            cell.tagView.showDelete = false
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        didSelectTag?(indexPath.item)
    }
    
    private func handleDeleteTag(cell: UICollectionViewCell) {
        guard let indexPath = self.indexPath(for: cell) else {
            return
        }
        
        guard shouldDeleteTag(indexPath.item) else {
            return
        }
        
        let oldCount = displayTags.count
        removeTag(at: indexPath.item)
        animateReloadTags(oldCount: oldCount)
        didDeleteTag?(indexPath.item)
    }
}

private class TagCollectionItemCell: UICollectionViewCell {
    let tagView: TagView = .init()
    
    weak var collectionView: UICollectionView?
    
    private var maxWidth: CGFloat {
        guard let collectionView else {
            return UIScreen.main.bounds.width
        }
        
        var width = collectionView.bounds.width
        - collectionView.contentInset.left
        - collectionView.contentInset.right
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            width -= (layout.sectionInset.left + layout.sectionInset.right)
        }
        
        return width
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tagView)
        tagView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attrs = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        if attrs.size.width <= maxWidth {
            return attrs
        }
        
        attrs.size.width = maxWidth
        return attrs
    }
}
