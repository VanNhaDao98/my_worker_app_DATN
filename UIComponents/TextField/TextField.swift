//
//  TextField.swift
//  UIComponents
//
//  Created by Dao Van Nha on 10/10/2023.
//

import Foundation
import SnapKit
import UIKit
import Utils

open class TextField: UIControl {
    
    private var mainStackView = UIStackView()
    
    private var textField = InsetTextField()

    private var rightIconView: UIImageView?
    
    private var leftButton: AppBaseButton?
    
    private var originalBackgroundColor: UIColor?
    
    public var dismissOnReturn: Bool = false
    
    public var textFieldDidReturn: ((String?) -> Void)?
    public var textFieldDidBeginEditing: ((TextField) -> Void)?
    public var textFieldDidEndEditing: ((TextField) -> Void)?
    
    public var textDidChanged: ((String?) -> Void)?
    public var selectAction: (() -> Void)?
    public var validationForTextChange: ((_ old: String?, _ new: String?) -> (isValid: Bool, newText: String?))?
    
    private var heightConstraint: CGFloat = 54.4 {
        didSet {
            snp.updateConstraints {
                $0.height.equalTo(heightConstraint)
            }
        }
    }
    
    public var padding: UIEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8) {
        didSet {
            mainStackView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview().inset(UIEdgeInsets(top: padding.top,
                                                                                 left: padding.left,
                                                                                 bottom: padding.bottom,
                                                                                 right: padding.right))
            }
        }
    }
    
    public var maxCharacterCount: Int?
    
    public var placeholder: String? {
        didSet {
            self.textField.placeholder = placeholder
        }
    }
    
    public var isUseBorderColor: Bool = true
    
    public var text: String? {
        get { self.textField.text }
        set { update(text: newValue)}
    }
    
    public var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set {
            textField.keyboardType = newValue
            textField.reloadInputViews()
        }
    }
    
    public var isSelectable: Bool = false {
        didSet {
            textField.isEnabled = !isSelectable
            textField.isUserInteractionEnabled = !isSelectable
        }
    }
    
    public var isRequired: Bool = false {
        didSet {
            if isRequired != oldValue {
                setupPlaceholerView()
            }
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            textField.isEnabled = isEnabled
        }
    }
    
    public var rightIconMode: IconMode = .none {
        didSet {
            leftButton?.removeFromSuperview()
            if let icon = rightIconMode.image {
                if leftButton == nil {
                    leftButton = .init(type: .system)
                }
                
                leftButton?.setImage(icon, for: .normal)
                leftButton?.setContentHuggingPriority(.required, for: .horizontal)
                leftButton?.setContentCompressionResistancePriority(.required, for: .horizontal)
                leftButton?.action = rightIconMode.action
                leftButton?.tintColor = .gray
                mainStackView.addArrangedSubview(leftButton!)
                leftButton?.snp.makeConstraints({
                    $0.height.equalTo(mainStackView.snp.height)
                    $0.width.equalTo(40)
                })
            }
        }
    }
    
    public var leftIcon: UIImage? = nil {
        didSet {
            if let image = leftIcon {
                if rightIconView == nil {
                    rightIconView = .init()
                }
                
                rightIconView?.image = image
                mainStackView.insertArrangedSubview(rightIconView!, at: 0)
                rightIconView?.snp.makeConstraints({
                    $0.height.width.equalTo(40)
                })
                rightIconView?.squircle(radius: 20)
            } else {
                rightIconView?.removeFromSuperview()
                setNeedsLayout()
            }
        }
    }
    
    public var isSecureTextEntry: Bool {
        get { textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue }
    }
    
    public var textAlignment: NSTextAlignment {
        get { textField.textAlignment }
        set { textField.textAlignment = newValue }
    }
    
    public func setbacgroundColor(color: UIColor) {
        backgroundColor = color
    }
    
    public var attributedPlaceholder: NSAttributedString? {
        didSet {
            setupPlaceholerView()
        }
    }

    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        squircle(radius: bounds.height / 2)
        
    }
    
    private func setupView() {
        
        backgroundColor = .ink05
        snp.makeConstraints {
            $0.height.equalTo(heightConstraint)
        }
        addSubview(mainStackView)
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.spacing = 4
        mainStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.top.equalToSuperview().inset(UIEdgeInsets(top: padding.top,
                                                                             left: padding.left,
                                                                             bottom: padding.bottom,
                                                                             right: padding.right))
        }
        
        mainStackView.addArrangedSubview(textField)
        textField.snp.makeConstraints {
            $0.height.equalTo(mainStackView.snp.height)
        }
        
        textField.delegate = self
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.textColor = ColorConstant.text
        textField.font = Fonts.defaultFont(ofSize: .subtitle)
        
        textField.addTarget(self, action: #selector(textFieldEditDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldEditingDidEnd), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        setupPlaceholerView()

    }
    
    private func setupPlaceholerView() {
        let (attributedPlaceholder, attributedFloatPlaceholder) = buildPlaceholder()
        
        textField.placeholder = nil
        textField.attributedPlaceholder = attributedPlaceholder
        
    }
    
    private func buildPlaceholder() -> (NSAttributedString?, NSAttributedString?) {
        let attributedPlaceholder: NSAttributedString?
        let attributedFloatPlaceholder: NSAttributedString?
        
        if self.attributedPlaceholder != nil {
            attributedPlaceholder = self.attributedPlaceholder
            attributedFloatPlaceholder = self.attributedPlaceholder
        } else {
            let require: String? = isRequired ? "*" : nil
            let string = [self.placeholder, require].compactMap({ $0 }).joined(separator: " ")
            
            attributedPlaceholder = string.attributedMaker
                .color(ColorConstant.text50)
                .last(match: require, maker: {
                    $0.color(.red)
                })
                .build()
            
            attributedFloatPlaceholder = string.attributedMaker
                .color(isFirstResponder ? ColorConstant.primary : ColorConstant.text50)
                .last(match: require, maker: {
                    $0.color(.red)
                })
                .build()
        }
        
        return (attributedPlaceholder, attributedFloatPlaceholder)
    }
    
    @objc private func textFieldEditDidBegin() {
        if isUseBorderColor {
            border(width: 2, color: ColorConstant.lineView)
        }
    }
    
    @objc private func textFieldEditingDidEnd() {
        if self.textField.text?.isEmpty ?? false && isUseBorderColor {
            border(width: 0)
        }
    }
    
    @objc private func textFieldEditingChanged() {
        textDidChanged?(self.textField.text)
     
    }
    
    private func setColor() {
        if isUseBorderColor {
            if textField.text?.isEmpty ?? false {
                border(width: 0)
            } else {
                border(width: 2, color: .lineView)
            }
        }
    }
    private typealias TextChangeValidateResult = ( shouleChange: Bool, replaceText: String?)
    private func shouldChangeText(newText: String?, oldText: String?) -> TextChangeValidateResult {
        if let maxCharacterCount, let newText, newText.count > maxCharacterCount {
            return (false, newText.prefix(maxCharacterCount))
        }
        
        if let validationForTextChange {
            let result = validationForTextChange(oldText, newText)
            return (result.isValid, result.newText)
        }
        return (true, nil)
    }
    
    private func update(text: String?, validate: Bool = true) {
        func update(newText: String?) {
            textField.text = newText
            DispatchQueue.main.async {
                self.textField.moveToEnd()
            }
        }
        
        guard validate else {
            update(newText: text)
            return
        }
        let result = shouldChangeText(newText: text, oldText: textField.text)
        if result.shouleChange {
            update(newText: text)
        } else if let replaceText = result.replaceText {
            update(newText: replaceText)
        }
    }
    
//    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//         super.touchesBegan(touches, with: event)
//
//        if textField.isEnabled { return }
//        originalBackgroundColor = backgroundColor
//        animateBackgroundColor(view: self, color: .init(white: 0.9, alpha: 1))
//
//    }
//    
//    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        if textField.isEnabled { return }
//        animateBackgroundColor(view: self, color: originalBackgroundColor)
//        
//        // Check if touch up inside
//        guard let location = touches.first?.location(in: self) else { return }
//        guard let hitView = hitTest(location, with: event) else { return }
//        guard hitView.isDescendant(of: self) else { return }
//
//        sendActions(for: .touchUpInside)
//        selectAction?()
//    }
//
//    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesCancelled(touches, with: event)
//
//        if textField.isEnabled { return }
//        animateBackgroundColor(view: self, color: originalBackgroundColor)
//    }
//    
//    private func animateBackgroundColor(view: UIView, color: UIColor?) {
//        UIView.animate(withDuration: 0.1,
//                       delay: 0,
//                       options: .allowUserInteraction,
//                       animations: { view.backgroundColor = color },
//                       completion: nil)
//    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if dismissOnReturn {
            textField.resignFirstResponder()
        }
        
        textFieldDidReturn?(textField.text)
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDidBeginEditing?(self)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDidEndEditing?(self)
    }

}

extension TextField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let newText = (textField.text as? NSString)?.replacingCharacters(in: range, with: string) {
            let result = shouldChangeText(newText: newText, oldText: textField.text)
            if result.shouleChange {
                return true
            } else if let replaceText = result.replaceText {
                update(text: replaceText, validate: false)
                textDidChanged?(self.textField.text)
                return false
            }
        }
        return false
    }
    
}

extension TextField {
    
    public typealias Action = () -> Void
    
    public enum IconMode {
        case none
        case arrowDown(Action?)
        case arrowRight(Action?)
        case custom(Action? ,UIImage?)
        
        public var image: UIImage? {
            switch self {
            case .none:
                return nil
            case .arrowRight(_):
                return ImageConstant.chevronRight
            case .arrowDown(_):
                return ImageConstant.chevronDown
            case .custom(_, let image):
                return image
            }
        }
        
        public var action: Action? {
            switch self {
            case .none:
                return nil
            case .arrowRight(let action):
                return action
            case .arrowDown(let action):
                return action
            case .custom(let action, _):
                return action
            }
        }
    }
}

extension TextField {
    public func enableCurrencyInput() {
        keyboardType = .numberPad
        validationForTextChange = { old, new in
            self.handleTextChange(old: old,
                                  new: new,
                                  formatter: Formatter.shared.currencyFormatter,
                                  formatted: { $0.currencyFormat() })
        }
    }
    
    public func enableNumberInput() {
        keyboardType = .decimalPad
        validationForTextChange = { [unowned self] old, new in
            self.handleTextChange(old: old,
                                  new: new,
                                  formatter: Formatter.shared.defaultNumberFormatter!,
                                  formatted: { $0.format() })
        }
    }
    
    public func numberValue() -> Double {
        Formatter.shared.number(from: text?.trim(
            in: Formatter.shared.defaultNumberFormatter.decimalSeparator
        ))
    }
    
    private func handleTextChange(old: String?,
                                  new: String?,
                                  formatter: Foundation.NumberFormatter,
                                  formatted: (Double) -> String) -> (Bool, String?) {
        guard var text = new else {
            return (false, 0.format())
        }
        
        // if device's region is different from formatter preference
        // then decimal separator on keyboard might be the grouping separator of formatter
        // so we need to convert it to decimal separator here.
        if text.hasSuffix(formatter.groupingSeparator) {
            if let range = text.ranges(of: formatter.groupingSeparator).last {
                text = text.replacingOccurrences(of: formatter.groupingSeparator,
                                                 with: formatter.decimalSeparator,
                                                 range: range)
            }
        }
        
        let ranges = text.ranges(of: formatter.decimalSeparator)
        switch ranges.count {
        case 1:
            let numberOfDecimals = self.numberOfDecimalDigit(text, decimalSeparator: formatter.decimalSeparator)
            if numberOfDecimals > formatter.maximumFractionDigits {
                return (false, old)
            }
            
            return (false, text)
        case 2...:
            return (false, old)
        default:
            break
        }
        
        let numberText = text.replacingOccurrences(of: formatter.groupingSeparator,
                                                   with: "")
        let number = Formatter.shared.number(from: numberText)
        return (false, formatted(number))
    }
    
    private func numberOfDecimalDigit(_ numberString: String, decimalSeparator: String) -> Int {
        let range = (numberString as NSString).range(of: decimalSeparator)
        if range.length == 0 {
            return 0
        }
        
        return numberString.count - range.location - 1
    }
}
