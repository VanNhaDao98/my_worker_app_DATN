//
//  Button.swift
//  UIComponents
//
//  Created by Dao Van Nha on 09/10/2023.
//

import Foundation
import UIKit
import Utils

open class AppBaseButton: UIButton {
    
    public var action: (() -> Void)? {
        didSet {
            removeTarget(self, action: nil, for: .touchUpInside)
            addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        }
    }
    
    @objc private func didTapButton() {
        action?()
    }
    
    @IBInspectable
    public var enableHightLightBackground: Bool = false {
        didSet {
            if enableHightLightBackground {
                setBacgroundColor(.init(white: 0, alpha: 0.075), .highlighted)
            } else {
                setBacgroundColor(nil, .highlighted)
            }
        }
    }
}

open class Button: AppBaseButton {
    
    private let stackView = UIStackView()
    private let leftImageView = UIImageView()
    private let rightImageView = UIImageView()
    private let label = UILabel()
    
    static public var fixedHeight: CGFloat = 48
    
    public lazy var config: Config = Config(button: self)
    
    public enum Alignment {
        case fill
        case leading
        case trailing
        case center
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        loadConfigFromInterfaceBuilder()
    }
    
    // load config from Interface Builder, if not set programmatically
    private func loadConfigFromInterfaceBuilder() {
        for state in State.allCases {
            if config.title(for: state) == nil {
                config.titles[state] = title(for: state.uiButtonState)
            }
            
            if config.titleColor(for: state) == nil {
                config.titleColors[state] = titleColor(for: state.uiButtonState)
            }
        }
    }
    
    public var axis: NSLayoutConstraint.Axis = .horizontal {
        didSet {
            stackView.axis = axis
        }
    }
    
    public var spacing: CGFloat = 8.0 {
        didSet {
            stackView.spacing = spacing
        }
    }
    
    public var leftIconSpacing: CGFloat = 8.0 {
        didSet {
            stackView.setCustomSpacing(leftIconSpacing, after: leftImageView)
        }
    }
    
    public var rightIconSpacing: CGFloat = 8.0 {
        didSet {
            stackView.setCustomSpacing(rightIconSpacing, after: label)
        }
    }
    
    public var alignment: Alignment = .fill {
        didSet { reloadAlignmentAndPadding() }
    }
    
    public var padding: UIEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 12) {
        didSet { reloadAlignmentAndPadding() }
    }
    
    public var numberOfLines: Int {
        get { label.numberOfLines }
        set { label.numberOfLines = newValue }
    }
    
    public var leftIconContentMode: UIView.ContentMode {
        get { leftImageView.contentMode }
        set {
            leftImageView.contentMode = newValue
            leftImageView.setContentCompressionResistancePriority(newValue == .center ? .required : .defaultHigh,
                                                                  for: .horizontal)
        }
    }
    
    public var rightIconContentMode: UIView.ContentMode {
        get { rightImageView.contentMode }
        set {
            rightImageView.contentMode = newValue
            rightImageView.setContentCompressionResistancePriority(newValue == .center ? .required : .defaultHigh,
                                                                   for: .horizontal)
        }
    }
    
    public var leftIconSize: CGFloat = 24 {
        didSet {
            leftImageView.snp.updateConstraints({
                $0.width.equalTo(leftIconSize).priority(999)
            })
        }
    }
    
    public var rightIconSize: CGFloat = 24 {
        didSet {
            rightImageView.snp.updateConstraints({
                $0.width.equalTo(leftIconSize).priority(999)
            })
        }
    }
    
    private func setup() {
        // fix ambiguous constraints
        frame = CGRect(x: 0, y: 0, width: 56, height: 48)
        
        addSubview(stackView)
        
        stackView.isUserInteractionEnabled = false
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.addArrangedSubview(leftImageView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(rightImageView)
        
        switch contentHorizontalAlignment {
        case .center:
            label.textAlignment = .center
        case .leading, .left:
            label.textAlignment = .left
        case .trailing, .right:
            label.textAlignment = .right
        case .fill:
            label.textAlignment = .justified
        @unknown default:
            label.textAlignment = .natural
        }
        
        leftIconContentMode = .center
        rightIconContentMode = .center
        
        leftImageView.isHidden = true
        rightImageView.isHidden = true
        
        leftImageView.snp.makeConstraints({
            $0.width.equalTo(leftIconSize).priority(999)
        })
        rightImageView.snp.makeConstraints({
            $0.width.equalTo(rightIconSize).priority(999)
        })
        
        reloadAlignmentAndPadding()
        
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.numberOfLines = 0
        
        UIView.performWithoutAnimation { [self] in
            config.style = .filled
            config.titles[.normal] = currentTitle
        }
    }
    
    private func animateChanges(stateOnly: Bool = false) {
        if stateOnly {
            transitionCrossDissolve {
                self.reloadState()
                self.reloadPrimaryColor()
            }
        } else {
            self.reloadConfigs()
        }
    }
    
    private func reloadAlignmentAndPadding() {
        switch alignment {
        case .fill:
            stackView.snp.remakeConstraints({
                $0.edges.equalToSuperview().inset(padding)
            })
        case .leading:
            stackView.snp.remakeConstraints({
                $0.leading.top.bottom.equalToSuperview().inset(padding)
                $0.trailing.lessThanOrEqualToSuperview().inset(padding)
            })
        case .trailing:
            stackView.snp.remakeConstraints({
                $0.trailing.top.bottom.equalToSuperview().inset(padding)
                $0.leading.lessThanOrEqualToSuperview().inset(padding)
            })
        case .center:
            stackView.snp.remakeConstraints({
                $0.center.equalToSuperview()
            })
        }
    }
    
    private func reloadConfigs() {
        reloadState()
        reloadPrimaryColor()
        
        layoutIfNeeded()
    }
    
    private func reloadState() {
        let state: State
        
        if isHighlighted {
            state = .highlighted
        } else {
            state = isEnabled ? .normal : .disabled
        }
        
        label.textColor = config.titleColor(for: state)
        config.title(for: state)?.update(into: label)
        
        let isEmptyTitle = label.text == nil || label.text == ""
        label.isHidden.setIfChanged(isEmptyTitle)
        
        leftImageView.image = config.leftIcon(for: state)
        rightImageView.image = config.rightIcon(for: state)
        
        if config.style == .plain {
            leftImageView.alpha = isHighlighted ? 0.15 : 1.0
            rightImageView.alpha = isHighlighted ? 0.15 : 1.0
        }
        
        leftImageView.isHidden.setIfChanged(leftImageView.image == nil)
        rightImageView.isHidden.setIfChanged(rightImageView.image == nil)
    }
    
    private func reloadPrimaryColor() {
        let color = config.primaryColor
        
        let borderColor: UIColor?
        let iconTint: UIColor
        
        switch config.style {
        case .filled:
            borderColor = nil
            iconTint = config.titleColor(for: isEnabled ? .normal : .disabled) ?? .white
        case .outline:
            borderColor = isEnabled ? color : color.withAlphaComponent(0.6)
            iconTint = isEnabled ? color : color.withAlphaComponent(0.6)
        case .plain:
            borderColor = nil
            iconTint = isEnabled ? color : color.withAlphaComponent(0.6)
        }
        
        layer.borderColor = borderColor?.cgColor
        layer.borderWidth = borderColor == nil ? 0.0 : 1.0
        
        leftImageView.tintColor = iconTint
        rightImageView.tintColor = iconTint
    }
    
    public override var isHighlighted: Bool {
        didSet { animateChanges(stateOnly: true) }
    }
    
    public override var isEnabled: Bool {
        didSet { animateChanges(stateOnly: true) }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if titleLabel?.superview != nil {
            titleLabel?.removeFromSuperview()
        }
    }
    
    open override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle("", for: state)
        
        config.titles[.init(buttonState: state)] = title
    }
    
    open override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(nil, for: state)
        
        config.titleColors[.init(buttonState: state)] = color
    }
    
    open override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(nil, for: state)
        
        config.leftIcons[.init(buttonState: state)] = image
    }
    
    open override func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        super.setContentCompressionResistancePriority(priority, for: axis)
        
        label.setContentCompressionResistancePriority(priority, for: axis)
    }
    
    open override func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        super.setContentHuggingPriority(priority, for: axis)
        
        label.setContentHuggingPriority(priority, for: axis)
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                config.reloadPrimaryColor()
                animateChanges()
            }
        }
    }
}

extension Button {
    public enum State: String, CaseIterable {
        case normal
        case highlighted
        case disabled
        
        var uiButtonState: UIButton.State {
            switch self {
            case .normal:
                return .normal
            case .highlighted:
                return .highlighted
            case .disabled:
                return .disabled
            }
        }
        
        init(buttonState: UIButton.State) {
            switch buttonState {
            case .normal:
                self = .normal
            case .highlighted:
                self = .highlighted
            case .disabled:
                self = .disabled
            default:
                self = .normal
            }
        }
    }
}

extension Button {
    public class Config {
        
        public enum Style {
            case filled
            case outline
            case plain
        }
        
        public var titles: [Button.State: TextProtocol] = [:] {
            didSet { button.reloadConfigs() }
        }
        
        public var titleColors: [Button.State: UIColor] = [:] {
            didSet { button.reloadConfigs() }
        }
        
        public var leftIcons: [Button.State: UIImage] = [:] {
            didSet { button.reloadConfigs() }
        }
        
        public var rightIcons: [Button.State: UIImage] = [:] {
            didSet { button.reloadConfigs() }
        }
        
        public var keepIconColor: Bool = false {
            didSet { button.reloadConfigs() }
        }
        
        public var backgroundColors: [Button.State: UIColor] = [:] {
            didSet {
                for state in Button.State.allCases {
                    button.setBackgroundImage(backgroundImage(for: state), for: state.uiButtonState)
                }
            }
        }
        
        public var style: Style = .filled {
            didSet {
                updatePrimaryColor(primaryColor)
                button.animateChanges()
            }
        }
        
        public var primaryColor: UIColor = ColorConstant.primary {
            didSet {
                updatePrimaryColor(primaryColor)
                button.animateChanges()
            }
        }
        
        func reloadPrimaryColor() {
            updatePrimaryColor(primaryColor)
        }
        
        private func updatePrimaryColor(_ color: UIColor) {
            updateBackgroundColor(from: color)
            updateTitleColor(from: color, force: false)
        }
        
        unowned var button: Button
        
        init(button: Button) {
            self.button = button
        }
        
        func titleColor(for state: Button.State) -> UIColor? {
            titleColors[state] ?? titleColors[.normal]
        }
        
        func title(for state: Button.State) -> TextProtocol? {
            titles[state] ?? titles[.normal]
        }
        
        func leftIcon(for state: Button.State) -> UIImage? {
            let image = leftIcons[state] ?? leftIcons[.normal]
            return keepIconColor ? image : image?.alwaysTemplate()
        }
        
        func rightIcon(for state: Button.State) -> UIImage? {
            let image = rightIcons[state] ?? rightIcons[.normal]
            return keepIconColor ? image : image?.alwaysTemplate()
        }
        
        func backgroundImage(for state: Button.State) -> UIImage? {
            if let color = backgroundColors[state] ?? backgroundColors[.normal] {
                return .from(color: color)
            }
            
            return nil
        }
        
        func updateBackgroundColor(from color: UIColor) {
            switch style {
            case .filled:
                backgroundColors[.normal] = color
                backgroundColors[.highlighted] = color.darken(0.3)
                backgroundColors[.disabled] = color.withAlphaComponent(0.35)
            case .outline:
                backgroundColors[.normal] = nil
                backgroundColors[.highlighted] = color.withAlphaComponent(0.15)
                backgroundColors[.disabled] = nil
            case .plain:
                backgroundColors[.normal] = nil
                backgroundColors[.highlighted] = nil
                backgroundColors[.disabled] = nil
            }
        }
        
        func updateTitleColor(from color: UIColor, force: Bool) {
            switch style {
            case .filled:
                if force {
                    titleColors[.normal] = color
                } else {
                    
                    titleColors[.normal] = color.isLight() ?? true ? .black : .white
                }
                
                titleColors[.highlighted] = nil
                titleColors[.disabled] = titleColors[.normal]?.withAlphaComponent(0.8)
            case .outline:
                titleColors[.normal] = color
                titleColors[.highlighted] = nil
                titleColors[.disabled] = color.withAlphaComponent(0.6)
            case .plain:
                titleColors[.normal] = color
                titleColors[.highlighted] = color.withAlphaComponent(0.15)
                titleColors[.disabled] = color.withAlphaComponent(0.6)
            }
        }
    }
}

extension Button {
    
    // convenience setter for normal state title
    public var title: TextProtocol? {
        get { config.titles[.normal] }
        set {
            config.titles.removeAll()
            config.titles[.normal] = newValue
        }
    }
    
    // convenience setter for normal state title
    public var titleColor: UIColor? {
        get { config.titleColors[.normal] }
        set {
            config.titleColors.removeAll()
            
            if let color = newValue {
                config.updateTitleColor(from: color, force: true)
            }
        }
    }
    
    // convenience setter for normal state left icon
    public var leftIcon: UIImage? {
        get { config.leftIcons[.normal] }
        set { config.leftIcons[.normal] = newValue }
    }
    
    // convenience setter for normal state right icon
    public var rightIcon: UIImage? {
        get { config.rightIcons[.normal] }
        set { config.rightIcons[.normal] = newValue }
    }
    
    public var labelFont: UIFont? {
        get { label.font }
        set { label.font = newValue }
    }
    
    public var textAlignment: NSTextAlignment {
        get { label.textAlignment }
        set { label.textAlignment = newValue }
    }
    
    public func fitToTitle() {
        label.setContentHuggingPriority(.required, for: .horizontal)
    }
}

public extension Button {
    
    @discardableResult
    func makePrimary(color: UIColor = ColorConstant.primary,
                     fontSize: FontSize = .default,
                     height: CGFloat = Button.fixedHeight,
                     forceHeightUpdate: Bool = false) -> Self {
        self.textAlignment = .center
        self.config.primaryColor = color
        self.labelFont = Fonts.mediumFont(ofSize: fontSize)
        self.config.style = .filled
        self.squircle(radius: 8)
        
        if forceHeightUpdate || !constraints.contains(where: { $0.firstItem === self && $0.firstAttribute == .height }) {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        return self
    }
    
    @discardableResult
    func makeSecondary(color: UIColor = ColorConstant.primary,
                       fontSize: FontSize = .default,
                       height: CGFloat = Button.fixedHeight,
                       forceHeightUpdate: Bool = false) -> Self {
        self.textAlignment = .center
        self.config.primaryColor = color
        self.labelFont = Fonts.mediumFont(ofSize: fontSize)
        self.config.style = .outline
        self.squircle(radius: 8)
        
        if forceHeightUpdate || !constraints.contains(where: { $0.firstItem === self && $0.firstAttribute == .height }) {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        return self
    }
}

extension Button {
    @discardableResult
    public func configCommon() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        squircle(radius: 8.0)
        return self
    }

//    @discardableResult
//    public func configDestructive() -> Self {
//        configCommon()
//
//        config.primaryColor = .red
//        config.keepIconColor = true
//        config.backgroundColors[.highlighted] = .red
//        leftIcon = Icons.icTrashAlt24pt.image
//
//        return self
//    }
}

