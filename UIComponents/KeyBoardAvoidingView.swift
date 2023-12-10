//
//  KeyBoardAvoidingView.swift
//  Presentation
//
//  Created by Dao Van Nha on 10/10/2023.
//
// copy nhưng không nhớ nguồn kkkkkkkkik

import Foundation
import UIKit

public protocol KeyboardAvoidingViewDelegate: AnyObject {
    func keyboardAvoidingViewWillChange(change: KeyboardAvoidingView.Change, userInfo: [AnyHashable: Any])
    func keyboardAvoidingViewDidChange(change: KeyboardAvoidingView.Change, userInfo: [AnyHashable: Any])
}

/// A view that adjusts it's height based on keyboard hide and show notifications.
/// Pin it to the bottom of the screen using Auto Layout and then pin views that
/// should avoid the keyboard to the top of it.
public class KeyboardAvoidingView: UIView {
    
    public enum Change {
        case show
        case hide
        case frame
    }
    
    public weak var delegate: KeyboardAvoidingViewDelegate?
    
    /// Typically, when a view controller is not being displayed, keyboard
    /// tracking should be paused to avoid responding to keyboard events
    /// caused by other view controllers or apps. Setting `isPaused = false` in
    /// `viewWillAppear` and `isPaused = true` in `viewWillDisappear` usually works. This class
    /// automatically pauses and resumes when the app resigns and becomes active, respectively.
    public var isPaused = false {
        didSet {
            if !isPaused {
                isAutomaticallyPaused = false
            }
        }
    }
    
    /// The margin to maintain between the keyboard and the top of the view.
    @IBInspectable public var topMargin: CGFloat = 0
    
    @IBInspectable public var minimumHeight: CGFloat = 0
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        postInit()
    }
    
    private var isAutomaticallyPaused = false
    private var heightConstraint: NSLayoutConstraint!
    
    private func postInit() {
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = heightAnchor.constraint(equalToConstant: minimumHeight)
        heightConstraint.isActive = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pause), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resume), name: UIApplication.didBecomeActiveNotification, object: nil)
        backgroundColor = .clear
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        show(change: .frame, notification)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        show(change: .show, notification)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard !(isPaused || isAutomaticallyPaused),
              let userInfo = notification.userInfo else { return }
        guard heightConstraint.constant != minimumHeight else { return }
        delegate?.keyboardAvoidingViewWillChange(change: .hide, userInfo: userInfo)
        animateKeyboardChange(change: .hide, height: minimumHeight, userInfo: userInfo)
    }
    
    @objc private func pause() {
        isAutomaticallyPaused = true
    }
    
    @objc private func resume() {
        isAutomaticallyPaused = false
    }
    
    private func show(change: Change, _ notification: Notification) {
        guard !(isPaused || isAutomaticallyPaused),
              let userInfo = (notification as NSNotification).userInfo,
              let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRect = value.cgRectValue
        let thisRect = convert(bounds, to: nil)
        let newHeight = max(0, thisRect.maxY - keyboardRect.minY) + topMargin
        guard heightConstraint.constant != newHeight else { return }
        delegate?.keyboardAvoidingViewWillChange(change: change, userInfo: userInfo)
        animateKeyboardChange(change: change, height: newHeight, userInfo: userInfo)
    }
    
    private func animateKeyboardChange(change: Change,
                                       height: CGFloat,
                                       userInfo: [AnyHashable: Any]) {
        self.heightConstraint.constant = height
        guard let durationNumber = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
              let curveNumber = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
        let _ = UIView.AnimationCurve(rawValue: curveNumber.intValue) else {
            return
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.delegate?.keyboardAvoidingViewDidChange(change: change, userInfo: userInfo)
        }
        UIView.animate(withDuration: durationNumber.doubleValue, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut]) {
            self.superview?.layoutIfNeeded()
        }
        CATransaction.commit()
    }
}

open class KeyboardAvoidingContainerView: PassthroughView {
    
    enum Change {
        case show
        case hide
        case frame
    }
    
    private var contentView: UIView?
    private var contentViewHeight: CGFloat = 0
    
    private var isAutomaticallyPaused = false
    private var heightConstraint: NSLayoutConstraint!
    
    /// margin between keyboard and bottom of this view
    @IBInspectable public var bottomMargin: CGFloat = 0
    
    typealias CallbackInfo = (change: Change, userInfo: [AnyHashable: Any])
    
    var willChangeCallback: ((CallbackInfo) -> Void)?
    var didChangeCallback: ((CallbackInfo) -> Void)?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        postInit()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        contentViewHeight = contentView?.frame.height ?? 0
        
        if heightConstraint.constant == 0 && contentViewHeight > 0 {
            heightConstraint.constant = contentViewHeight
        }
    }
    
    public func setContentView(_ view: UIView) {
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        contentView = view
        
        setNeedsLayout()
    }
    
    private func postInit() {
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pause),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resume),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        backgroundColor = .clear
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        show(change: .frame, notification)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        show(change: .show, notification)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard !isAutomaticallyPaused,
              let userInfo = notification.userInfo else { return }
        guard heightConstraint.constant != contentViewHeight else { return }
        willChangeCallback?((.hide, userInfo))
        animateKeyboardChange(change: .hide, height: contentViewHeight, userInfo: userInfo)
    }
    
    @objc private func pause() {
        isAutomaticallyPaused = true
    }
    
    @objc private func resume() {
        isAutomaticallyPaused = false
    }
    
    private func show(change: Change, _ notification: Notification) {
        guard !isAutomaticallyPaused,
              let userInfo = notification.userInfo,
              let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        willChangeCallback?((change, userInfo))
        let keyboardRect = value.cgRectValue
        let thisRect = convert(bounds, to: nil)
        let newHeight = max(0, thisRect.maxY - keyboardRect.minY) + contentViewHeight + bottomMargin
        guard heightConstraint.constant != newHeight else { return }
        animateKeyboardChange(change: change, height: newHeight, userInfo: userInfo)
    }
    
    private func animateKeyboardChange(change: Change, height: CGFloat, userInfo: [AnyHashable: Any]) {
        self.heightConstraint.constant = height
        if let durationNumber = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
           let _ = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.didChangeCallback?((change, userInfo))
            }
            
            UIView.animate(withDuration: durationNumber.doubleValue, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut]) {
                self.superview?.layoutIfNeeded()
            }
            CATransaction.commit()
        }
    }
}
