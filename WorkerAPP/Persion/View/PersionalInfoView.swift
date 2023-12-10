//
//  PersionalInfoView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 17/10/2023.
//

import UIKit
import UIComponents
import Utils

class PersionalInfoView: UIView {
    
    private var mainStackView = UIStackView()
    private var infoView = LeftRightLabelView()
    private var addressView = LeftRightLabelView()
    private var degreeView = LeftRightLabelView()
    
//    private var infoButton = AppBaseButton()
//    private var addressButton = AppBaseButton()
//    private var degreeButton = AppBaseButton()
    
    struct Action {
        var infoAction: () -> Void
        var addressAction: () -> Void
        var degreeAction: () -> Void
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
        
        mainStackView.addArrangedSubview(infoView)
        mainStackView.addArrangedSubview(addressView)
        mainStackView.addArrangedSubview(degreeView)
        
        infoView.leftText = "Thông tin cá nhân"
        infoView.leftIcon = ImageConstant.user
        
        infoView.isUseActionButton = true
        
        addressView.leftText = "Địa chỉ làm việc"
        addressView.leftIcon = ImageConstant.locationPin
        addressView.isUseActionButton = true
        
        addressView.isHidden = true
        
        degreeView.leftText = "Bằng cấp"
        degreeView.leftIcon = ImageConstant.bookOpen
        degreeView.isUseActionButton = true
        
        degreeView.isHidden = true
        
        [infoView, addressView, degreeView].forEach({
            $0.rightIcon = ImageConstant.chevronRight
        })
        
        mainStackView.backgroundColor = ColorConstant.ink05
        mainStackView.squircle()
        
        infoView.action = { [weak self] in
            self?.action?.infoAction()
        }
        addressView.action = { [weak self] in
            self?.action?.addressAction()
        }
        degreeView.action = { [weak self] in
            self?.action?.degreeAction()
        }
        
    }
}
