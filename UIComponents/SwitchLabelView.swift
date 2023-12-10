//
//  SwitchLabelView.swift
//  UIComponents
//
//  Created by Dao Van Nha on 16/10/2023.
//

import Foundation
import UIKit
import Utils

public class SwitchLabelView: UIControl {
    
    private var mainStackView = UIStackView(frame: .init(x: 0, y: 0, width: 350, height: 48))
    private var switchControl = UISwitch()
    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public var padding: UIEdgeInsets = .zero {
        didSet {
            mainStackView.snp.updateConstraints {
                $0.edges.equalToSuperview().inset(padding)
            }
        }
    }
    
    public var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    public var subtitle: String? {
        get { subtitleLabel.text }
        set { subtitleLabel.text = newValue }
    }
    
    public var isOn: Bool {
        get { switchControl.isOn }
        set { switchControl.isOn = newValue}
    }
    
    public func setOn(_ isOn: Bool, animated: Bool) {
        switchControl.setOn(isOn, animated: animated)
    }
    
    public var valueDidChange: ((Bool) -> Void)?
    
    private func setupView() {
        addSubview(mainStackView)
        mainStackView.spacing = 8
        mainStackView.axis = .horizontal
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(padding)
        }
        mainStackView.alignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.spacing = 6
        stackView.axis = .vertical
        
        mainStackView.addArrangedSubview(stackView)
        mainStackView.addArrangedSubview(switchControl)
        
        switchControl.setContentHuggingPriority(.required, for: .horizontal)
        switchControl.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        titleLabel.font = Fonts.semiboldFont(ofSize: .title)
        titleLabel.textColor = ColorConstant.text
        
        subtitleLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        subtitleLabel.textColor = ColorConstant.grayText
        subtitleLabel.numberOfLines = 2
        subtitle = nil
        
        switchControl.onTintColor = ColorConstant.primary
        
        switchControl.addTarget(self, action: #selector(didTapSwitchControl), for: .valueChanged)
    }
    
    @objc private func didTapSwitchControl() {
        sendActions(for: .valueChanged)
        valueDidChange?(switchControl.isOn)
    }
}
