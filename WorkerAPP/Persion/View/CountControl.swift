//
//  CountControl.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/11/2023.
//


import Foundation
import UIKit
import SnapKit
import Utils
import UIComponents

public class CountControl: UIControl {
    
    private let valueTextField = TextField()
    private let increaseButton = AppBaseButton()
    private let decreaseButton = AppBaseButton()
    
    public var currentValue: Double? = 0 {
        didSet {
            UIView.performWithoutAnimation { [self] in
                if let currentValue = currentValue {
                    valueTextField.text = currentValue.currencyFormat()
                } else {
                    valueTextField.text = "---"
                }
            }
            
            if let currentValue {
                increaseButton.isEnabled = currentValue < maxValue
                decreaseButton.isEnabled = currentValue > minValue
            } else {
                increaseButton.isEnabled = false
                decreaseButton.isEnabled = false
            }
            
            sendActions(for: .valueChanged)
        }
    }
    
    public var maxValue: Double = 999_999_999_999
    public var minValue: Double = 0
    
    public var valueDidChanged: ((Double) -> Void)?
    public var editValueAction: ((Double) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        valueTextField.isUseBorderColor = false
        valueTextField.setbacgroundColor(color: .white)
        valueTextField.textAlignment = .center
        valueTextField.enableCurrencyInput()
        valueTextField.textDidChanged = { [weak self] value in
            guard let self = self else { return }
            let quantity = Formatter.shared.number(from: value)
            if quantity < self.minValue {
                valueDidChanged?(self.minValue)
                self.currentValue = self.minValue
            } else if quantity > maxValue {
                valueDidChanged?(self.maxValue)
                self.currentValue = self.maxValue
            } else {
                valueDidChanged?(quantity)
                self.currentValue = quantity
            }
            
        }
        
        backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [
            decreaseButton, valueTextField, increaseButton
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 2.0
        
        addSubview(stackView)
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
//        valueButton.titleLabel?.font = Fonts.defaultFont(ofSize: .default)
//        valueButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        valueButton.titleLabel?.minimumScaleFactor = 0.8
//        valueButton.setTitleColor(.text, for: .normal)
//        valueButton.setTitleColor(.text.withAlphaComponent(0.2), for: .highlighted)
//        valueButton.setTitleColor(.text50, for: .disabled)
        valueTextField.setContentCompressionResistancePriority(.init(999), for: .horizontal)
        valueTextField.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        [increaseButton, decreaseButton].forEach({
            $0.widthAnchor.constraint(equalTo: $0.heightAnchor, multiplier: 1.0).isActive = true
            $0.heightAnchor.constraint(greaterThanOrEqualToConstant: 32.0).isActive = true
            $0.setContentHuggingPriority(.required, for: .horizontal)
        })
        
        increaseButton.setImage(ImageConstant.icPlus24pt, for: .normal)
        decreaseButton.setImage(ImageConstant.icMinus24pt, for: .normal)
                
        currentValue = 0
        
//        valueButton.action = { [weak self] in
//            self?.editValueAction?(self?.currentValue ?? 0.0)
//        }
        
        increaseButton.action = { [weak self] in
            self?.increaseCurrentValue()
        }
        
        decreaseButton.action = { [weak self] in
            self?.decreaseCurrentValue()
        }
    }
    
    private func increaseCurrentValue() {
        guard var value = currentValue else {
            return
        }
        
        value = min(maxValue, value + 1)
        valueDidChanged?(value)
        self.currentValue = value
    }
    
    private func decreaseCurrentValue() {
        guard var value = currentValue else {
            return
        }
        
        value = max(minValue, value - 1)
        valueDidChanged?(value)
        self.currentValue = value
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async { [self] in
            increaseButton.roundedCorner()
            decreaseButton.roundedCorner()
        }
    }
}
