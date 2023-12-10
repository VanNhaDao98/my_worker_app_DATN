//
//  BottomSheetEditView.swift
//  UIComponents
//
//  Created by Dao Van Nha on 16/10/2023.
//

import Foundation
import UIKit
import SnapKit
import Utils

class BottomSheetEditView: UIView, BottomSheetContentView {
    
    private let titleLabel: UILabel = .init()
    private let descLabel: UILabel = .init()
    private let textField: TextField = .init()
    private let confirmButton: Button = .init()
    
    private var config: BottomSheetEditConfig
    
    var innerScrollView: UIScrollView? {
        nil
    }
    
    init(config: BottomSheetEditConfig) {
        self.config = config
        
        super.init(frame: .init(x: 0, y: 0, width: 320, height: 320))
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       descLabel,
                                                       textField,
                                                       confirmButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        addSubview(stackView)
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview().inset(16.0)
        })
        
        [titleLabel, descLabel].forEach({
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
            $0.setContentHuggingPriority(.required, for: .vertical)
            $0.textColor = ColorConstant.text
        })
        
        titleLabel.font = Fonts.mediumFont(ofSize: .title)
        titleLabel.text = config.title
        
        descLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        descLabel.text = config.description
        
        textField.dismissOnReturn = true
        textField.placeholder = config.placeholder
        textField.text = config.text
        textField.snp.makeConstraints({ $0.height.equalTo(48) })
        
        confirmButton.title = config.confirmTitle
        confirmButton.makePrimary(forceHeightUpdate: true)
        confirmButton.action = { [weak self] in
            self?.textField.resignFirstResponder()
            self?.config.confirmAction(self?.textField.text)
        }
    }
}

public struct BottomSheetEditConfig {
    public var title: String?
    public var description: String? = nil
    public var placeholder: String? = nil
    public var text: String? = nil
    public var confirmTitle: String = "OK"
    public var confirmAction: (String?) -> Void
    
    public init(title: String?,
                description: String? = nil,
                placeholder: String? = nil,
                text: String? = nil,
                confirmTitle: String = "OK",
                confirmAction: @escaping (String?) -> Void) {
        self.title = title
        self.description = description
        self.placeholder = placeholder
        self.text = text
        self.confirmTitle = confirmTitle
        self.confirmAction = confirmAction
    }
}
