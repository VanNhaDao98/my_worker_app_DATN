//
//  UIScrollView+Exts.swift
//  UIComponents
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import UIKit
import UIScrollView_InfiniteScroll

public extension UIScrollView {
    
    enum ScrollPosition {
        case top
        case bottom
        case left
        case right
    }
    
    func isScrolledToMax(_ position: ScrollPosition) -> Bool {
        let offset = contentOffset
        
        switch position {
        case .top:
            return offset.y == -contentInset.top
        case .left:
            return offset.x == -contentInset.left
        case .bottom:
            let y = contentSize.height + contentInset.bottom - bounds.size.height
            return offset.y == y
        case .right:
            let x = contentSize.width + contentInset.right - bounds.size.width
            return offset.x == x
        }
    }
    
    /// Do nothing if already scrolled to max position
    ///
    func scrollToMax(_ position: ScrollPosition, animated: Bool = true) {
        var offset = contentOffset
        
        switch position {
        case .top:
            if offset.y == -contentInset.top { return }
            offset.y = -contentInset.top
        case .left:
            if offset.x == -contentInset.left { return }
            offset.x = -contentInset.left
        case .bottom:
            let y = contentSize.height + contentInset.bottom - bounds.size.height
            if offset.y == y { return }
            offset.y = max(0, y)
        case .right:
            let x = contentSize.width + contentInset.right - bounds.size.width
            if offset.x == x { return }
            offset.x = x
        }
        
        setContentOffset(offset, animated: animated)
    }
    
    func initView(parent: UIView, top: CGFloat, height: CGFloat, contentSize: CGSize) {
        self.frame = CGRect.init(x: 0, y: top, width: parent.frame.width, height: height)
        self.contentSize = contentSize
        parent.addSubview(self)
    }
    
    /// Do nothing if already scrolled to max position
    ///
    func scrollToPage(_ page: Int,
                      direction: UICollectionView.ScrollDirection = .horizontal,
                      animated: Bool = true) {
        if page == 0 {
            scrollToMax(direction == .horizontal ? .left : .top,
                        animated: animated)
            return
        }
        
        let numberOfPages = direction == .horizontal
        ? Int(contentSize.width / bounds.width)
        : Int(contentSize.height / bounds.height)
        
        if page >= numberOfPages - 1 {
            scrollToMax(direction == .horizontal ? .right : .bottom,
                        animated: animated)
            return
        }
        
        var offset = self.contentOffset
        
        if direction == .horizontal {
            offset.x = CGFloat(page) * bounds.width
        } else {
            offset.y = CGFloat(page) * bounds.height
        }
        
        setContentOffset(offset, animated: animated)
    }
    
    var currentPage: Int {
        pageForOffset(contentOffset)
    }
    
    func pageForOffset(_ offset: CGPoint,
                       direction: UICollectionView.ScrollDirection = .horizontal) -> Int {
        switch direction {
        case .horizontal:
            return Int(offset.x / self.bounds.width)
        case .vertical:
            return Int(offset.y / self.bounds.height)
        @unknown default:
            return Int(offset.x / self.bounds.width)
        }
    }
    
    func scrollToViewVisible(view: UIView, offset: CGFloat = 0, animated: Bool = true) {
        guard view.isDescendant(of: self) else {
            return
        }
        
        if var rect = view.superview?.convert(view.frame, to: self) {
            rect.origin.y += offset
            scrollRectToVisible(rect, animated: animated)
        }
    }
}

public func associatedObject<ValueType>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    defaultValue: ValueType)
-> ValueType {
    if let associated = objc_getAssociatedObject(base, key)
        as? ValueType { return associated }
    let associated = defaultValue
    objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
    return associated
}

public func associateObject<ValueType>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: ValueType) {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
    }

extension UIScrollView {
    struct AssociatedKeys {
        static var refreshHandler: UInt8 = 0
    }
}

public extension UIScrollView {
    
    typealias RefreshHandler = () -> Void
    
    func addRefreshHandler(_ handler: @escaping RefreshHandler) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
        associateObject(base: self, key: &AssociatedKeys.refreshHandler, value: handler)
    }
    
    @objc private func refreshControlValueChanged(_ refreshControl: UIRefreshControl) {
        let handler: RefreshHandler? = associatedObject(base: self, key: &AssociatedKeys.refreshHandler, defaultValue: nil)
        handler?()
    }
    
    func beginRefreshing() {
        guard let refreshControl = refreshControl, !refreshControl.isRefreshing else {
            return
        }
        
        refreshControl.beginRefreshing()
        
        let contentOffset = CGPoint(x: 0, y: -refreshControl.bounds.height)
        setContentOffset(contentOffset, animated: true)
    }
    
    /// endRefreshing
    /// - Parameter delay: milliseconds
    func endRefreshing(after delay: Int = 0, completion: (() -> Void)? = nil) {
        guard let refreshControl = refreshControl, refreshControl.isRefreshing else {
            completion?()
            return
        }
        
        if delay <= 0 {
            refreshControl.endRefreshing()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
                completion?()
            }
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            refreshControl.endRefreshing()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
                completion?()
            }
        }
    }
    
    func addLoadMoreHandler(_ handler: @escaping () -> Void) {
        infiniteScrollIndicatorMargin = 16
        infiniteScrollTriggerOffset = 128
        addInfiniteScroll(handler: { _ in
            handler()
        })
    }
    
    func enableLoadMore(_ isEnable: Bool) {
        if isEnable {
            shouldLoadMore({ _ in true })
        } else {
            shouldLoadMore({ _ in false })
        }
    }
    
    func shouldLoadMore(_ check: @escaping (UIScrollView) -> Bool) {
        setShouldShowInfiniteScrollHandler(check)
    }
    
    func finishLoadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.finishInfiniteScroll()
        }
    }
}

