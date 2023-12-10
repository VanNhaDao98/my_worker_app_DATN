//
//  DetailInfomationWorkerView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/10/2023.
//

import UIKit
import UIComponents
import Utils

class DetailInfomationWorkerView: UIView {
    
    private var mainStackView = UIStackView()
    private var typeJobView = LeftRightLabelView()
    private var addressView = LeftRightLabelView()
    private var jobPriceView = LeftRightLabelView()
    private var phoneNumberView = LeftRightLabelView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        squircle(radius: 8)
        backgroundColor = ColorConstant.BGNhat
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().priority(.init(999))
        }
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        mainStackView.addArrangedSubview(typeJobView)
        mainStackView.addArrangedSubview(addressView)
        mainStackView.addArrangedSubview(jobPriceView)
        mainStackView.addArrangedSubview(phoneNumberView)
        
        [typeJobView, addressView, jobPriceView, phoneNumberView].forEach {
            $0.rightText = "Ba Đình, Hà Nội"
        }
        
        typeJobView.leftText = "Thể loại việc"
        addressView.leftText = "Nơi làm việc"
        jobPriceView.leftText = "Giá giờ làm việc"
        phoneNumberView.leftText = "Số điện thoại"
        
        jobPriceView.leftIcon = ImageConstant.coin
        addressView.leftIcon = ImageConstant.locationPin
        typeJobView.leftIcon = ImageConstant.category
        phoneNumberView.leftIcon = ImageConstant.phone
    }
    
    public func setValue(data: DetailPesionalViewModel.Generic) {
        typeJobView.rightText = data.job
        addressView.rightText = data.address
        jobPriceView.rightText = data.price
        phoneNumberView.rightText = data.phoneNumber
    }

}
