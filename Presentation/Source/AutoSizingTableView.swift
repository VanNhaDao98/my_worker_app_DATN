//
//  AutoSizingTableView.swift
//  Presentation
//
//  Created by Dao Van Nha on 09/10/2023.
//

import Foundation
import UIKit

open class AutoSizingTableView: BaseTableView {

    private var heightConstraint: NSLayoutConstraint?
    private var contentSizeObserver: NSKeyValueObservation?

    private var extraHeight: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    private var minHeight: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    private var maxHeight: CGFloat = .greatestFiniteMagnitude {
        didSet {
            setNeedsLayout()
        }
    }

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        bounces = false
        alwaysBounceVertical = false
        alwaysBounceHorizontal = false

        contentSizeObserver = observe(\.contentSize, options: [.new, .old], changeHandler: { (tableView, change) in
            guard let new = change.newValue else { return }
            var constain = max(self.minHeight, new.height + self.extraHeight + 1)

            if constain > self.maxHeight {
                constain = self.maxHeight
            }

            guard let old = change.oldValue else {
                self.heightConstraint?.constant = constain
                return
            }

            if new.height != old.height {
                self.heightConstraint?.constant = constain
            }
        })
    }

    deinit {
        contentSizeObserver = nil
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if heightConstraint == nil {
            heightConstraint = self.heightAnchor.constraint(equalToConstant: 0)
            heightConstraint?.isActive = true
        }
    }

    public override func removeFromSuperview() {
        super.removeFromSuperview()

        heightConstraint = nil
    }
}

