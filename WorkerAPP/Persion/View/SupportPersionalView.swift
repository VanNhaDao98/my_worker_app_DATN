//
//  SupportPersionalView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 17/10/2023.
//

import UIKit
import UIComponents
import Utils

class SupportPersionalView: UIView {
    
    private var mainStackView = UIStackView()
    private var passwordView = LeftRightLabelView()
    private var supportView = LeftRightLabelView()
    
    struct Action {
        var passwordAction: () -> Void
        var supportAction: () -> Void
    }
    
    var action: Action?

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
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.spacing = 16
        mainStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        mainStackView.axis = .vertical
        mainStackView.snp.makeConstraints({
            $0.edges.equalToSuperview().priority(.init(999))
        })
        
        mainStackView.addArrangedSubview(passwordView)
        mainStackView.addArrangedSubview(supportView)
        
        passwordView.leftText = "Thay mật khẩu"
        passwordView.leftIcon = ImageConstant.lock
        passwordView.rightIcon = ImageConstant.chevronRight
        
        supportView.leftText = "Hỗ trợ"
        supportView.leftIcon = ImageConstant.lifeRing
        supportView.rightIcon = ImageConstant.chevronRight
        

        mainStackView.backgroundColor = ColorConstant.ink05
        mainStackView.squircle()
        
        passwordView.isUseActionButton = true
        supportView.isUseActionButton = true
        
        passwordView.action = { [weak self] in
            self?.action?.passwordAction()
        }
        supportView.action = { [weak self] in
            self?.action?.supportAction()
        }
        
    }
}
