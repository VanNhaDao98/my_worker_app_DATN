//
//  UIView+Exts.swift
//  Utils
//
//  Created by Dao Van Nha on 10/10/2023.
//

import Foundation
import UIKit

public extension UIView {
    static var reuseId: String {
        String(describing: self)
    }
    
    static func nib(in bundle: Bundle) -> UINib {
        UINib(nibName: String(describing: self), bundle: bundle)
    }
}

public extension UIView {
    func pinEdgesToSuperview(insets: UIEdgeInsets = .zero) {
        guard let superview = superview else {
            fatalError("superview must not be nil")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right).isActive = true
        topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = true
    }
    
    @inlinable
    func border(width: CGFloat, color: UIColor?) {
        layer.borderWidth = width
        layer.borderColor = color?.cgColor
    }
    
    @inlinable
    func border(width: CGFloat) {
        layer.borderWidth = width
    }
    
    struct ViewCorners: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let topLeft = ViewCorners(rawValue: 1 << 0)
        public static let topRight = ViewCorners(rawValue: 1 << 1)
        public static let bottomLeft = ViewCorners(rawValue: 1 << 2)
        public static let bottomRight = ViewCorners(rawValue: 1 << 3)
        
        public static let all: ViewCorners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        
        public var cornerMask: CACornerMask {
            var masks: [CACornerMask] = []
            
            if contains(.topLeft) {
                masks.append(.layerMinXMinYCorner)
            }
            if contains(.topRight) {
                masks.append(.layerMaxXMinYCorner)
            }
            if contains(.bottomLeft) {
                masks.append(.layerMinXMaxYCorner)
            }
            if contains(.bottomRight) {
                masks.append(.layerMaxXMaxYCorner)
            }
            
            return CACornerMask(masks)
        }
        
        public var rectCorners: UIRectCorner {
            if self == .all {
                return .allCorners
            }
            
            var corners: [UIRectCorner] = []
            
            if contains(.topLeft) {
                corners.append(.topLeft)
            }
            if contains(.topRight) {
                corners.append(.topRight)
            }
            if contains(.bottomLeft) {
                corners.append(.bottomLeft)
            }
            if contains(.bottomRight) {
                corners.append(.bottomRight)
            }
            
            return UIRectCorner(corners)
        }
    }
    
    func makeCorner(radius: CGFloat, corners: ViewCorners) {
        if #available(iOS 13.0, *) {
            self.layer.cornerCurve = .continuous
        }
        
        layer.maskedCorners = corners.cornerMask
        layer.cornerRadius = radius
    }
    
    @inlinable
    func corner(radius: CGFloat = 8.0) {
        layer.cornerRadius = radius
        if radius > 0 {
            layer.masksToBounds = true
        }
    }
    
    @inlinable
    func roundedCorner() {
        corner(radius: bounds.height / 2.0)
    }
    
    @inlinable
    func squircle(radius: CGFloat = 8.0) {
        corner(radius: radius)
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
    }
}

public extension CALayer {
    @inlinable
    func squircle(radius: CGFloat) {
        cornerRadius = radius
        if #available(iOS 13.0, *) {
            cornerCurve = .continuous
        }
    }
}

public extension UIView {
    enum FadeInOrOut {
        case `in`
        case out
    }
    
    func animateFade(_ inOrOut: FadeInOrOut,
                     duration: TimeInterval,
                     completion: ((_ finished: Bool) -> Void)? = nil) {
        switch inOrOut {
        case .in:
            guard isHidden else { return }
            animateFadeIn(duration: duration, completion: completion)
        case .out:
            guard !isHidden else { return }
            animateFadeOut(duration: duration, completion: completion)
        }
    }
    
    func animateFadeIn(duration: TimeInterval,
                       completion: ((_ finished: Bool) -> Void)? = nil) {
        self.alpha = 0.0
        self.isHidden = false
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func animateFadeOut(duration: TimeInterval,
                        completion: ((_ finished: Bool) -> Void)? = nil) {
        if self.isHidden {
            return
        }
        
        self.isHidden = false
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }, completion: { finished in
            self.isHidden = true
            completion?(finished)
        })
    }
    
    func animateScaleFadeIn(duration: TimeInterval,
                            scale: CGFloat = 0.93,
                            completion: ((_ finished: Bool) -> Void)? = nil) {
        self.alpha = 0.0
        self.isHidden = false
        self.transform = .init(scaleX: scale, y: scale)
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
            self.transform = .identity
        }, completion: completion)
    }
    
    func animateScaleFadeOut(duration: TimeInterval,
                             scale: CGFloat = 0.93,
                             completion: ((_ finished: Bool) -> Void)? = nil) {
        if self.isHidden {
            return
        }
        
        self.isHidden = false
        self.transform = .identity
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
            self.transform = .init(scaleX: scale, y: scale)
        }, completion: { finished in
            self.isHidden = true
            self.transform = .identity
            completion?(finished)
        })
    }
    
    func animateSlideFadeIn(duration: TimeInterval,
                            offset: CGFloat = 8.0,
                            completion: ((_ finished: Bool) -> Void)? = nil) {
        self.alpha = 0.0
        self.isHidden = false
        
        let of = frame
        let f = CGRect(x: frame.origin.x,
                       y: frame.origin.y + offset,
                       width: frame.width,
                       height: frame.height)
        self.frame = f
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
            self.frame = of
        }, completion: completion)
    }
    
    func animateSlideFadeOut(duration: TimeInterval,
                             offset: CGFloat = 8.0,
                             completion: ((_ finished: Bool) -> Void)? = nil) {
        if self.isHidden {
            return
        }
        
        self.isHidden = false
        
        let of = frame
        let f = CGRect(x: frame.origin.x,
                       y: frame.origin.y + offset,
                       width: frame.width,
                       height: frame.height)
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
            self.frame = f
        }, completion: { finished in
            self.isHidden = true
            self.frame = of
            completion?(finished)
        })
    }
    
    static func animateDefaultSpring(duration: TimeInterval,
                                     animation: @escaping () -> Void,
                                     completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [.beginFromCurrentState, .curveLinear, .allowUserInteraction],
                       animations: animation) { _ in
            completion?()
        }
    }
    
    func animateShow(duration: TimeInterval = 0.25) {
        UIView.animate(withDuration: duration, delay: 0, options: []) {
            self.alpha = 1
            self.isHidden = false
        } completion: { _ in
            
        }
    }
    
    func animateHide(duration: TimeInterval = 0.25) {
        UIView.animate(withDuration: duration, delay: 0, options: []) {
            self.alpha = 0
            self.isHidden = true
        } completion: { _ in
            
        }
    }
    
    func transitionCrossDissolve(duration: TimeInterval = 0.1,
                                 animation: @escaping () -> Void) {
        UIView.transition(with: self,
                          duration: duration,
                          options: [
                            .transitionCrossDissolve,
                            .allowUserInteraction
                          ],
                          animations: animation)
    }
}

extension UIView {
    @objc open func removeSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
}

public extension UIStackView {
    @inlinable
    func removeArrangedSubviews(excludeTag: Int? = nil) {
        arrangedSubviews.forEach({
            if $0.tag != excludeTag {
                $0.removeFromSuperview()
            }
        })
    }
}

public extension UIView {
    func dropShadow(radius: CGFloat = 2,
                    offsetWidth: CGFloat = 0,
                    offsetHeight: CGFloat = 0,
                    opacity: Float = 0.2,
                    color: UIColor = .black) {
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: offsetWidth, height: offsetHeight)
        self.layer.shadowRadius = radius
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

public extension UIView {
    /// Render this view as `UIImage`
    /// - Parameter hasShadow: set to `true` if this view has shadow layer, may cause failed to render
    /// - Returns: rendered image
    func asImage(hasShadow: Bool = false) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            if hasShadow {
                self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            } else {
                layer.render(in: rendererContext.cgContext)
            }
        }
    }
}

public extension UIView {
    func removeConstraints(attribute: NSLayoutConstraint.Attribute) {
        let view = attribute == .width || attribute == .height ? self : superview
        
        let constraints = view?.constraints.filter({
            $0.firstItem === self && $0.firstAttribute == attribute
            || $0.secondItem === self && $0.secondAttribute == attribute
        }) ?? []
        
        constraints.forEach({
            view?.removeConstraint($0)
        })
    }
}

public extension UIView {
    func removeConstraintWithAttribute(_ attribute: NSLayoutConstraint.Attribute) {
        if attribute == .width || attribute == .height {
            for constraint in constraints
                where constraint.firstAttribute == attribute
                    && (constraint.firstItem as? UIView) == self
                    && constraint.secondItem == nil {
                        removeConstraint(constraint)
                        break
            }
            
            return
        }
        
        for constraint in superview?.constraints ?? [] {
            if let firstItem = constraint.firstItem as? UIView,
                firstItem == self,
                constraint.firstAttribute == attribute {
                superview?.removeConstraint(constraint)
                break
            }
            
            if let secondItem = constraint.secondItem as? UIView,
                secondItem == self,
                constraint.secondAttribute == attribute {
                superview?.removeConstraint(constraint)
                break
            }
        }
    }
}

public extension UIView {
    // use to change hidden state of view inside UIStackView
    // because if a view is inside UIStackView and we set isHidden
    // when its value is not changed, sometimes that causes a visual bug.
    func setHiddenIfChange(_ hidden: Bool) {
        if isHidden != hidden {
            isHidden = hidden
        }
    }
}

extension CGRect {
    // use to set frame to fix temporary unsatisfy constraints during system layout
    public static var placeholder: CGRect {
        .init(x: 0, y: 0, width: 320, height: 64)
    }
}

extension UIView {
    private static let LOADING_INDICATOR_TAG = 99990
    
    public func addLoadingIndicator(style: UIActivityIndicatorView.Style = .medium,
                                    color: UIColor? = nil,
                                    insets: UIEdgeInsets = .zero) {
        let indicator = UIActivityIndicatorView(style: style)
        if let color {
            indicator.color = color
        }
        addSubview(indicator)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true
        indicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right).isActive = true
        indicator.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        indicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom).isActive = true
        
        indicator.tag = UIView.LOADING_INDICATOR_TAG
        indicator.isHidden = true
    }
    
    // @objc to make this overridable
    @objc public func startLoading() {
        guard let indicator = viewWithTag(UIView.LOADING_INDICATOR_TAG) as? UIActivityIndicatorView else {
            return
        }
        
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    // @objc to make this overridable
    @objc public func stopLoading() {
        guard let indicator = viewWithTag(UIView.LOADING_INDICATOR_TAG) as? UIActivityIndicatorView else {
            return
        }
        
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    
    public var isLoadingIndicatorAnimating: Bool {
        guard let indicator = viewWithTag(UIView.LOADING_INDICATOR_TAG) as? UIActivityIndicatorView else {
            return false
        }
        
        return indicator.isAnimating
    }
}
