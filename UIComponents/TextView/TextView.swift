//
//  TextView.swift
//  UIComponent
//
//  Created by Dao Van Nha on 26/10/2023.
//

import Foundation
import UIKit
import SnapKit
import Utils

open class TextView: UIControl {
    
    private var mainStackView = UIStackView()
    private var textView = UITextView()
    private var countLabel = UILabel()
    
    public var textDidChanged: ((String?) -> Void)?
    
    public var maxCharactorCount: Int = 200 {
        didSet {
            setCountLabel()
        }
    }
    
    private var height: Double = 100 {
        didSet {
            snp.makeConstraints({
                $0.height.equalTo(height)
            })
        }
    }
    
    public var text: String? {
        get { textView.text }
        set {
            textView.text = newValue
            setCountLabel()
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
    
    private func setupView() {
        snp.makeConstraints({
            $0.height.equalTo(height)
        })
        
        textView.delegate = self
        backgroundColor = ColorConstant.ink05
        squircle(radius: 20)
        mainStackView.axis = .vertical
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints({
            $0.edges.equalToSuperview().priority(.init(999))
        })
        
        countLabel.textAlignment = .right
        countLabel.textColor = ColorConstant.text50
        countLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        
        textView.backgroundColor = .clear
        textView.font = Fonts.defaultFont(ofSize: .default)
        mainStackView.addArrangedSubview(textView)
        mainStackView.addArrangedSubview(countLabel)
        setCountLabel()
    }
    
    private func setCountLabel() {
        countLabel.text = "\((self.text ?? "").count)/\(maxCharactorCount)"
    }
    
    private func updateText(newText: String) {
        self.text = text
        setCountLabel()
    }
}

extension TextView: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count >= maxCharactorCount && !text.isEmpty {
            return false
        }
        return true
    }
    
    
    public func textViewDidChange(_ textView: UITextView) {
        textDidChanged?(textView.text)
        updateText(newText: textView.text)
    }
}
