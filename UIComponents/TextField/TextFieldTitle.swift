//
//  TextFieldTitle.swift
//  UIComponent
//
//  Created by Dao Van Nha on 28/10/2023.
//

import Foundation
import UIKit
import Utils

open class TextFieldTitle: UIControl {
    private var titleLabel = UILabel()
    private var textField = TextField()
    
    public var textDidChanged: ((String?) -> Void)?
    public var selectAction: (() -> Void)?
    public var textFieldDidReturn: ((String?) -> Void)?
    
    public var dismissOnReturn: Bool = false {
        didSet { textField.dismissOnReturn = dismissOnReturn }
    }
    
    public var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    public var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    public var placeholder: String? {
        get { textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    public var isSelectable: Bool = false {
        didSet { textField.isSelectable = isSelectable }
    }
    
    public var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set {
            textField.keyboardType = newValue
            textField.reloadInputViews()
        }
    }
    
    public var maxCharacterCount: Int? {
        didSet { textField.maxCharacterCount = maxCharacterCount }
    }
    
    public var leftIcon: UIImage? {
        didSet {
            textField.leftIcon = leftIcon
        }
    }
    
    public var rightIconMode: TextField.IconMode = .none {
        didSet {
            textField.rightIconMode = rightIconMode
        }
    }
    
    public var isRequired: Bool = false {
        didSet {
            if isRequired != oldValue {
                setTitleLabel()
            }
        }
    }
    
    public var isSecureTextEntry: Bool {
        get { textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let mainStackView = UIStackView(arrangedSubviews: [titleLabel, textField])
        mainStackView.axis = .vertical
        mainStackView.spacing = 4
        titleLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        titleLabel.textColor = ColorConstant.text50
        
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        textField.textDidChanged = { [weak self] text in
            self?.textDidChanged?(text)
        }
        
        textField.selectAction = { [weak self] in
            self?.selectAction?()
        }
        
        textField.textFieldDidReturn = { [weak self] text in
            self?.textFieldDidReturn?(text)
        }
        
    }
    
    private func setTitleLabel() {
        let att = AttributedStringMaker(string: "\(title ?? "") *")
            .font(Fonts.defaultFont(ofSize: .subtitle))
            .color(ColorConstant.text50)
            .first(match: "*", maker: {
                $0.color(.red)
            }).build()
        titleLabel.text = nil
        titleLabel.attributedText = att
    }
}
