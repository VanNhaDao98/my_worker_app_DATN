//
//  BorderedView.swift
//  UIComponents
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import UIKit
import Utils

@IBDesignable
public class BorderedView: UIView {
    
    @IBInspectable public var topBorder: Bool = true {
        didSet {
            topBorderView.isHidden = !topBorder
            bringSubviewToFront(topBorderView)
        }
    }
    
    @IBInspectable public var topBorderWidth: CGFloat = 1.0 {
        didSet {
            topBorderViewHeight.constant = topBorderWidth
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var topBorderMargin: CGFloat = 0 {
        didSet {
            topBorderViewLeading.constant = topBorderMargin
            topBorderViewTrailing.constant = -topBorderMargin
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var topBorderColor: UIColor = ColorConstant.lineView {
        didSet {
            topBorderView.backgroundColor = topBorderColor
        }
    }
    
    @IBInspectable public var bottomBorder: Bool = true {
        didSet {
            bottomBorderView.isHidden = !bottomBorder
            bringSubviewToFront(bottomBorderView)
        }
    }
    
    @IBInspectable public var bottomBorderWidth: CGFloat = 1.0 {
        didSet {
            bottomBorderViewHeight.constant = bottomBorderWidth
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var bottomBorderMargin: CGFloat = 0 {
        didSet {
            bottomBorderViewLeading.constant = bottomBorderMargin
            bottomBorderViewTrailing.constant = -bottomBorderMargin
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var bottomBorderColor: UIColor = ColorConstant.lineView {
        didSet {
            bottomBorderView.backgroundColor = bottomBorderColor
        }
    }
    
    private var topBorderView: UIView!
    private var topBorderViewHeight: NSLayoutConstraint!
    private var topBorderViewLeading: NSLayoutConstraint!
    private var topBorderViewTrailing: NSLayoutConstraint!
    
    private var bottomBorderView: UIView!
    private var bottomBorderViewHeight: NSLayoutConstraint!
    private var bottomBorderViewLeading: NSLayoutConstraint!
    private var bottomBorderViewTrailing: NSLayoutConstraint!
    
    public init(top: Bool, bottom: Bool) {
        super.init(frame: .zero)
        
        setupSubviews(top: top, bottom: bottom)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews(top: true, bottom: true)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupSubviews(top: true, bottom: true)
    }
    
    private func setupSubviews(top: Bool, bottom: Bool) {
        topBorderView = buildTopBorderView()
        bottomBorderView = buildBottomBorderView()
        
        topBorder = top
        bottomBorder = bottom
    }
    
    private func buildTopBorderView() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = topBorderColor
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        topBorderViewLeading = view.leadingAnchor.constraint(equalTo: leadingAnchor)
        topBorderViewTrailing = view.trailingAnchor.constraint(equalTo: trailingAnchor)
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topBorderViewHeight = view.heightAnchor.constraint(equalToConstant: topBorderWidth)
        [topBorderViewLeading, topBorderViewTrailing, topBorderViewHeight].forEach({ $0?.isActive = true })
        return view
    }
    
    private func buildBottomBorderView() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = bottomBorderColor
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderViewLeading = view.leadingAnchor.constraint(equalTo: leadingAnchor)
        bottomBorderViewTrailing = view.trailingAnchor.constraint(equalTo: trailingAnchor)
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorderViewHeight = view.heightAnchor.constraint(equalToConstant: bottomBorderWidth)
        [bottomBorderViewLeading, bottomBorderViewTrailing, bottomBorderViewHeight].forEach({ $0?.isActive = true })
        return view
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if topBorder {
            bringSubviewToFront(topBorderView)
        }
        
        if bottomBorder {
            bringSubviewToFront(bottomBorderView)
        }
    }
    
    open override func removeSubviews() {
        for subview in subviews where subview != topBorderView && subview != bottomBorderView {
            subview.removeFromSuperview()
        }
    }
}

extension UIView {
    @objc open func removeSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
}
