//
//  LeftRightLabelView.swift
//  UIComponents
//
//  Created by Dao Van Nha on 17/10/2023.
//

import UIKit
import Utils

public class LeftRightLabelView: UIView {
    
    public enum IconPosition {
        case left
        case right
    }
    
    private let stackView: UIStackView = .init(frame: CGRect(x: 0, y: 0, width: 320, height: 48))
    private let leftLabel: UILabel = .init(frame: .zero)
    private let rightLabel: UILabel = .init(frame: .zero)
    private let spacingView: UIView = .init(frame: .zero)
    private let leftButton: AppBaseButton = .init(frame: .zero)
    private let rightButton: AppBaseButton = .init(frame: .zero)
    
    private var actionButton: AppBaseButton = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    public var isUseActionButton: Bool = false {
        didSet {
            if isUseActionButton {
                actionButton.removeFromSuperview()
                addSubview(actionButton)
                actionButton.snp.makeConstraints({
                    $0.edges.equalToSuperview()
                })
            }
        }
    }
    
    public var action: (() -> Void)? {
        get { actionButton.action }
        set { actionButton.action = newValue}
    }
    
    private func setup() {
        addSubview(stackView)
        stackView.snp.makeConstraints({
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
        })
        
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        stackView.addArrangedSubviews([
            leftLabel,
            spacingView,
            rightLabel
        ])
        
        [leftLabel, rightLabel].forEach({
            $0.font = Fonts.defaultFont(ofSize: .default)
            $0.textColor = ColorConstant.text
        })
        
        leftLabel.textAlignment = .left
        leftLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        leftLabel.setContentCompressionResistancePriority(.init(999), for: .horizontal)
        leftLabel.numberOfLines = 0
        
        rightLabel.textAlignment = .right
        rightLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        leftButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        leftButton.setContentHuggingPriority(.required, for: .horizontal)
        leftButton.isUserInteractionEnabled = false
        leftButton.imageView?.contentMode = .center
        
        rightButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        rightButton.setContentHuggingPriority(.required, for: .horizontal)
        rightButton.isUserInteractionEnabled = false
        rightButton.imageView?.contentMode = .center

        
        leftText = nil
        rightText = nil
        
        leftIcon = nil
        rightIcon = nil
    }
    
    private func layout(view: UIView?, position: IconPosition) {
        guard let view = view else {
            return
        }
        
        view.removeFromSuperview()
        
        if view === leftButton {
            switch position {
            case .left:
                stackView.insertArrangedSubview(view, at: 0)
                leftLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
            case .right:
                stackView.insertArrangedSubview(view, at: 1)
                leftLabel.setContentHuggingPriority(.required, for: .horizontal)
            }
        } else if view === rightButton {
            switch position {
            case .left:
                stackView.insertArrangedSubview(view,
                                                at: stackView.arrangedSubviews.count - 1)
                rightLabel.setContentHuggingPriority(.required, for: .horizontal)
            case .right:
                stackView.addArrangedSubview(view)
                rightLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
            }
        }
    }
    
    // - MARK: Public
    
    public var leftIconView: UIView {
        leftButton
    }
    
    public var rightIconView: UIView {
        rightButton
    }
    
    public var leftText: String? {
        get { leftLabel.text }
        set {
            leftLabel.text = newValue
            leftLabel.setHiddenIfChange(newValue == nil)
        }
    }
    
    public var rightText: TextProtocol? {
        get { rightLabel.text }
        set {
            newValue?.update(into: rightLabel)
            isRightTextHidden = newValue == nil
        }
    }
    
    public var leftIcon: UIImage? {
        get { leftButton.currentImage }
        set {
            leftButton.setImage(newValue, for: .normal)
            leftButton.setHiddenIfChange(newValue == nil)
            
            if newValue == nil {
                leftButton.removeFromSuperview()
            } else {
                layout(view: leftButton, position: leftIconPosition)
            }
        }
    }
    
    public var leftIconPosition: IconPosition = .left {
        didSet {
            layout(view: leftButton, position: leftIconPosition)
        }
    }
    
    public var leftIconTint: UIColor? {
        didSet {
            leftButton.tintColor = leftIconTint
            leftButton.setImage(leftIcon?.alwaysTemplate(), for: .normal)
        }
    }
    
    public var leftIconAction: (() -> Void)? {
        get { leftButton.action }
        set {
            leftButton.action = newValue
            leftButton.isUserInteractionEnabled = newValue != nil
        }
    }
    
    public var rightIcon: UIImage? {
        get { rightButton.currentImage }
        set {
            rightButton.setImage(newValue, for: .normal)
            rightButton.setHiddenIfChange(newValue == nil)
            
            if newValue == nil {
                rightButton.removeFromSuperview()
            } else {
                layout(view: rightButton, position: rightIconPosition)
            }
            
            let state = isRightTextHidden
            isRightTextHidden = state
        }
    }
    
    public var rightIconPosition: IconPosition = .right {
        didSet {
            layout(view: rightButton, position: rightIconPosition)
        }
    }
    
    public var rightIconTint: UIColor? {
        didSet {
            rightButton.tintColor = rightIconTint
            rightButton.setImage(rightIcon?.alwaysTemplate(), for: .normal)
        }
    }
    
    public var rightIconAction: (() -> Void)? {
        get { rightButton.action }
        set {
            rightButton.action = newValue
            rightButton.isUserInteractionEnabled = newValue != nil
        }
    }
    
    public var leftTextFont: UIFont? {
        get { leftLabel.font }
        set { leftLabel.font = newValue }
    }
    
    public var rightTextFont: UIFont? {
        get { rightLabel.font }
        set { rightLabel.font = newValue }
    }
    
    public var leftTextColor: UIColor? {
        get { leftLabel.textColor }
        set { leftLabel.textColor = newValue }
    }
    
    public var rightTextColor: UIColor? {
        get { rightLabel.textColor }
        set { rightLabel.textColor = newValue }
    }
    
    public var padding: UIEdgeInsets = .zero {
        didSet {
            stackView.snp.updateConstraints({
                $0.top.bottom.equalToSuperview().inset(padding)
                $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(padding)
            })
        }
    }
    
    public var leftSpacing: CGFloat {
        get {
            switch leftIconPosition {
            case .left:
                return stackView.customSpacing(after: leftButton)
            case .right:
                return stackView.customSpacing(after: leftLabel)
            }
        }
        set {
            switch leftIconPosition {
            case .left:
                stackView.setCustomSpacing(newValue, after: leftButton)
            case .right:
                stackView.setCustomSpacing(newValue, after: leftLabel)
            }
        }
    }
    
    public var rightSpacing: CGFloat {
        get {
            switch rightIconPosition {
            case .left:
                return stackView.customSpacing(after: rightButton)
            case .right:
                return stackView.customSpacing(after: rightLabel)
            }
        }
        set {
            switch rightIconPosition {
            case .left:
                stackView.setCustomSpacing(newValue, after: rightButton)
            case .right:
                stackView.setCustomSpacing(newValue, after: rightLabel)
            }
        }
    }
    
    public var isRightTextHidden: Bool {
        get { rightLabel.isHidden }
        set {
            rightLabel.isHidden = newValue
            spacingView.isHidden = newValue && leftIcon == nil && rightIcon == nil
        }
    }
}
