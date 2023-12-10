//
//  TagView.swift
//  UIComponents
//
//  Created by Dao Van Nha on 16/10/2023.
//

import Foundation
import UIKit
import SnapKit
import Utils

public class TagView: UIView {
    
    public enum Style {
        case bordered
        case plain
        case badge(UIColor)
    }
    
    private let label = UILabel()
    private let button = AppBaseButton(type: .system)
    private let stackView: UIStackView = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        
        addSubview(stackView)
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview().inset(padding)
            $0.width.greaterThanOrEqualTo(stackView.snp.height).priority(.init(999))
            $0.width.greaterThanOrEqualTo(12)
            $0.height.greaterThanOrEqualTo(16)
        })
        
        button.setImage(ImageConstant.xmark, for: .normal)
        button.imageEdgeInsets = .init(top: 3, left: 3, bottom: 3, right: 3)
        button.tintColor = ColorConstant.primary
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.init(999), for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.font = Fonts.defaultFont(ofSize: .subtitle)
        label.textAlignment = .center
        
        showDelete = false
        style = .bordered
    }
    
    private func updateStyle() {
//        switch style {
//        case .plain:
//            border(width: 0)
//            textColor = Colors.text.color
//            backgroundColor = Colors.primary10.color
//            button.tintColor = Colors.primary.color
//        case .bordered:
//            border(width: 1, color: Colors.primary.color)
//            textColor = Colors.primary.color
//            backgroundColor = Colors.primary10.color
//            button.tintColor = Colors.primary.color
//        case .badge(let color):
//            border(width: 0)
//            textColor = .white
//            backgroundColor = color
//            button.tintColor = .white
//        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if useRoundedCorner {
            corner(radius: bounds.height / 2.0)
        }
    }
    
    public override var isHidden: Bool {
        didSet {
            label.setContentHuggingPriority(isHidden ? .defaultLow : .init(999),
                                            for: .vertical)
        }
    }
    
    public override func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        super.setContentCompressionResistancePriority(priority, for: axis)
        
        label.setContentCompressionResistancePriority(priority, for: axis)
    }
    
    public override func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        super.setContentHuggingPriority(priority, for: axis)
        
        label.setContentHuggingPriority(priority, for: axis)
    }
    
    public var maxCharactersCount: Int?
    
    public var useRoundedCorner: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var style: Style = .bordered {
        didSet {
            updateStyle()
        }
    }
    
    public var text: String? {
        get { label.text }
        set {
            if let maxCharactersCount, let value = newValue, value.count > maxCharactersCount {
                label.text = value.prefix(maxCharactersCount) + "..."
            } else {
                label.text = newValue
            }
        }
    }
    
    public var textColor: UIColor? {
        get { label.textColor }
        set { label.textColor = newValue }
    }
    
    public var textFont: UIFont? {
        get { label.font }
        set { label.font = newValue }
    }
    
    public var textAlignment: NSTextAlignment {
        get { label.textAlignment }
        set { label.textAlignment = newValue }
    }
    
    public var numberOfLines: Int {
        get { label.numberOfLines }
        set { label.numberOfLines = newValue }
    }
    
    public var showDelete: Bool {
        get { !button.isHidden }
        set {
            button.isHidden = !newValue
            button.setContentCompressionResistancePriority(newValue ? .required : .defaultLow,
                                                           for: .vertical)
        }
    }
    
    public var deleteAction: (() -> Void)? {
        get { button.action }
        set { button.action = newValue }
    }
    
    public var padding: UIEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8) {
        didSet {
            stackView.snp.updateConstraints({
                $0.edges.equalToSuperview().inset(padding)
            })
        }
    }
}

