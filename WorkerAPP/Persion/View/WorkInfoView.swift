//
//  WorkInfoView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 17/10/2023.
//

import UIKit
import UIComponents
import Utils

class WorkInfoView: UIView {
    
    private var mainStackView = UIStackView()
    private var workTypeView = LeftRightLabelView()
    private var matetialView = LeftRightLabelView()
    
    struct Action {
        var workTypeAction: () -> Void
        var materialAction: () -> Void
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
        
        mainStackView.addArrangedSubview(workTypeView)
        mainStackView.addArrangedSubview(matetialView)
        
        workTypeView.leftText = "Thể loại việc"
        workTypeView.leftIcon = ImageConstant.category
        workTypeView.rightIcon = ImageConstant.chevronRight
        workTypeView.isHidden = true
        
        matetialView.leftText = "Quản lý vật liệu"
        matetialView.leftIcon = ImageConstant.coin
        matetialView.rightIcon = ImageConstant.chevronRight
        

        mainStackView.backgroundColor = ColorConstant.ink05
        mainStackView.squircle()
        
        workTypeView.isUseActionButton = true
        matetialView.isUseActionButton = true
        
        workTypeView.action = { [weak self] in
            self?.action?.workTypeAction()
        }
        matetialView.action = { [weak self] in
            self?.action?.materialAction()
        }
    }
}
