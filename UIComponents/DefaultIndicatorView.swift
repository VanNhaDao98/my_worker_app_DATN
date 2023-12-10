//
//  DefaultIndicatorView.swift
//  UIComponents
//
//  Created by Dao Van Nha on 05/11/2023.
//

import Foundation
import UIKit
import Utils
public protocol LoadingIndicator: UIView {
    func startAnimating()
    func stopAnimating()
}

public class DefaultIndicatorView: UIActivityIndicatorView, LoadingIndicator {
    private let minDurationBeforeVisible: TimeInterval
    private let minShowDuration: TimeInterval
    
    private var showTime: Date?
    
    private var timer: Timer?
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    public init(minDurationBeforeVisible: TimeInterval = 0.2,
                minShowDuration: TimeInterval = 0) {
        self.minDurationBeforeVisible = minDurationBeforeVisible
        self.minShowDuration = minShowDuration
        
        super.init(style: .medium)
        
        translatesAutoresizingMaskIntoConstraints = false
        widthConstraint = widthAnchor.constraint(equalToConstant: 80)
        widthConstraint?.isActive = true
        heightConstraint = heightAnchor.constraint(equalToConstant: 80)
        heightConstraint?.isActive = true
        backgroundColor = .init(white: 0.97, alpha: 1)
        
        layer.shadowOpacity = 0.15
        layer.shadowOffset = .zero
        layer.shadowRadius = 2
        layer.cornerRadius = 20
        layer.masksToBounds = false
        
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(visible: Bool) {
        if visible {
            show()
        } else {
            hide()
        }
    }
    
    public func show(duration: TimeInterval = 0.2) {
        timer?.invalidate()
        
        guard minDurationBeforeVisible > 0 else {
            __show(duration: duration)
            return
        }
        
        timer = .scheduledTimer(withTimeInterval: minDurationBeforeVisible,
                                repeats: false,
                                block: { [weak self] _ in
            self?.__show(duration: duration)
        })
    }
    
    private func __show(duration: TimeInterval) {
        guard isHidden else { return }
        startAnimating()
        showTime = Date()
        animateScaleFadeIn(duration: duration)
    }
    
    public func hide(duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        timer?.invalidate()
        
        guard minShowDuration > 0 else {
            __hide(duration: duration, completion: completion)
            return
        }
        
        let now = Date().timeIntervalSinceReferenceDate
        let show = showTime?.timeIntervalSinceReferenceDate ?? 0
        if now - show < minShowDuration {
            timer = .scheduledTimer(withTimeInterval: minShowDuration - (now - show),
                                    repeats: false,
                                    block: { [weak self] _ in
                self?.__hide(duration: duration, completion: completion)
            })
        } else {
            __hide(duration: duration, completion: completion)
        }
    }
    
    private func __hide(duration: TimeInterval, completion: (() -> Void)?) {
        animateScaleFadeOut(duration: duration) { _ in
            self.stopAnimating()
            completion?()
        }
    }
}
