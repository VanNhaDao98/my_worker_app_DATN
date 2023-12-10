//
//  MeterialHeaderShowMoreView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils

class MeterialHeaderShowMoreView: UIView {
    
    private var mainStackView = UIStackView()
    private var titleLabel = UILabel()
    private var createButton = AppBaseButton()
    
    public var createAction: (() -> Void)? {
        get {createButton.action }
        set { createButton.action = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(mainStackView)
        mainStackView.axis = .horizontal
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().priority(.init(999))
        }
        titleLabel.text = "Giá vật liệu"
        titleLabel.font = Fonts.boldFont(ofSize: .title)
        titleLabel.textColor = .text
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(createButton)
        createButton.setContentHuggingPriority(.required, for: .horizontal)
        createButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        createButton.setTitle("Thêm vật liệu", for: .normal)
        createButton.setTitleColor(.primary, for: .normal)
        
        createButton.titleLabel?.font = Fonts.defaultFont(ofSize: .subtitle)
    }

}
