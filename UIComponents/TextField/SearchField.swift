//
//  SearchField.swift
//  UIComponents
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import UIKit
import SnapKit
import Utils

open class SearchField: UIControl {
    
    private let cancelButton = AppBaseButton(type: .system)
    private let mainStackView = UIStackView()
    private let textField = UITextField()
    private let searchImageView = UIImageView()
    
    private var actionButton: AppBaseButton?
    private var actionSeparatorView: UIView?
    
    private var timer: Timer?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [mainStackView, cancelButton])
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        addSubview(stackView)
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        cancelButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        cancelButton.setContentHuggingPriority(.required, for: .horizontal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.isHidden = !showCancelButton
        cancelButton.action = { [weak self] in
            self?.textField.text = nil
            self?.textField.resignFirstResponder()
            UIView.animate(withDuration: 0.3) {
                self?.cancelButton.isHidden = true
            }
        }
        
        mainStackView.addArrangedSubview(searchImageView)
        mainStackView.addArrangedSubview(textField)
        
        textField.snp.makeConstraints({
            $0.height.equalTo(40.0)
        })
        searchImageView.snp.makeConstraints({
            $0.width.equalTo(44.0)
        })
        
        searchImageView.contentMode = .center
        searchImageView.tintColor = ColorConstant.text50
        searchImageView.image = ImageConstant.searchIcon
        
        backgroundColor = ColorConstant.ink05
        corner(radius: 20.0)
        
        textField.addTarget(self, action: #selector(textFieldEditingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldEditingDidEnd), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        textField.delegate = self
        
        let clearButton = AppBaseButton(type: .system)
        clearButton.action = {
            self.textField.text = nil
            self.textFieldEditingChanged()
            self.reloadColors()
        }
        clearButton.setImage(ImageConstant.icClose!.withRenderingMode(.alwaysOriginal), for: .normal)
        clearButton.snp.makeConstraints({ $0.width.equalTo(40) })
        
        textField.rightViewMode = .always
        textField.rightView = clearButton
        textField.rightView?.isHidden = true
        textField.font = Fonts.defaultFont(ofSize: .subtitle)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        placeholder = "Tìm kiếm"
    }
    
    private func reloadColors() {
        let isEmpty = String.isEmpty(textField.text)
        
        UIView.animate(withDuration: 0.3) {
            if self.textField.isFirstResponder {
                self.layer.borderColor = ColorConstant.text50.cgColor
                self.layer.borderWidth = 1
                self.backgroundColor = nil
            } else {
                self.layer.borderColor = isEmpty ? nil : ColorConstant.grayText.cgColor
                self.layer.borderWidth = isEmpty ? 0 : 1
                self.backgroundColor = isEmpty ? ColorConstant.ink05 : nil
            }
            self.layoutIfNeeded()
        }

        if !isEnabled {
            backgroundColor = .gray
        }
        
        textField.textColor = isEnabled ? ColorConstant.text : ColorConstant.text50
    }
    
    @objc private func textFieldEditingDidBegin() {
        if showCancelButton {
            cancelButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
        
        reloadColors()
    }
    
    @objc private func textFieldEditingDidEnd() {
        textEditingDidEnd?()
        reloadColors()
    }
    
    @objc private func textFieldEditingChanged() {
        handleTextFieldTextChanged(immediately: false)
    }
    
    private func handleTextFieldTextChanged(immediately: Bool) {
        textField.rightView?.isHidden = String.isEmpty(textField.text)
        let text = textField.text
        
        textFieldValueDidChanged?(text)
        
        if !immediately && debounceSearch && !String.isEmpty(text) {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] timer in
                timer.invalidate()
                self?.textDidChanged?(text)
            }
        } else {
            timer?.invalidate()
            textDidChanged?(text)
        }
    }
    
    public var placeholder: String? {
        didSet {
            textField.attributedPlaceholder = placeholder?.attributedMaker.color(ColorConstant.text50).build()
        }
    }
    
    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        self.textField.becomeFirstResponder()
    }
    
    public func isEditing() -> Bool {
        self.textField.isEditing
    }
    
    public var textDidChanged: ((String?) -> Void)?
    public var textEditingDidEnd: (() -> Void)?
    public var resignOnReturn: Bool = false
    
    // call when textField.text value changed, even when debounce timer does not fired yet
    public var textFieldValueDidChanged: ((String?) -> Void)?
    
    public func setAction(icon: UIImage?, action: @escaping () -> Void) {
        actionButton?.removeFromSuperview()
        actionSeparatorView?.removeFromSuperview()
        
        actionButton = AppBaseButton(type: .system)
        actionButton?.action = action
        actionButton?.setImage(icon, for: .normal)
        actionButton?.tintColor = ColorConstant.lineView
        
        actionSeparatorView = UIView()
        let line = UIView()
        line.backgroundColor = .gray
        actionSeparatorView?.addSubview(line)
        line.snp.makeConstraints({ $0.edges.equalToSuperview()
            .inset(UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)) })
        
        mainStackView.addArrangedSubview(actionSeparatorView!)
        mainStackView.addArrangedSubview(actionButton!)
        
        actionButton?.snp.makeConstraints({
            $0.width.equalTo(48.0)
        })
        actionSeparatorView?.snp.makeConstraints({
            $0.width.equalTo(1)
        })
    }
    
    public func removeAction() {
        actionButton?.removeFromSuperview()
        actionSeparatorView?.removeFromSuperview()
    }
    
    public var debounceSearch: Bool = true
    
    public var showCancelButton: Bool = false
    public var cancelButtonTitle: String? {
        get { cancelButton.currentTitle }
        set { cancelButton.setTitle(newValue, for: .normal) }
    }
    
    open override var isEnabled: Bool {
        didSet {
            UIView.transition(with: self, duration: 0.15) { [self] in
                textField.isEnabled = isEnabled
                reloadColors()
            }
        }
    }
}

extension SearchField: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if resignOnReturn {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

extension SearchField {
    public var text: String? {
        get { textField.text }
        set { setText(newValue, triggerSearch: true) }
    }
    
    public func setText(_ text: String?,
                        triggerSearch: Bool = true,
                        immediately: Bool = false) {
        textField.text = text
        
        if triggerSearch {
            handleTextFieldTextChanged(immediately: immediately)
        }
    }
    
    public var returnKeyType: UIReturnKeyType {
        get { textField.returnKeyType }
        set { textField.returnKeyType = newValue }
    }
}

