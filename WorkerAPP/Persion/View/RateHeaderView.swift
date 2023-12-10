//
//  RateHeaderView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/10/2023.
//

import UIKit
import Utils

class RateHeaderView: UIView {
    
    private var mainStackView = UIStackView()
    private var titleLabel = UILabel()
    private var rateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = ColorConstant.BGNhat
        mainStackView.axis = .vertical
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        mainStackView.spacing = 12
         addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(rateLabel)
        titleLabel.font = Fonts.semiboldFont(ofSize: .title)
        titleLabel.textColor = ColorConstant.text
        titleLabel.text = "Đánh giá"
        
        let lineView = UIView()
        lineView.backgroundColor = .hex(0xE8EAEB)
        
        addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().priority(.init(999))
            $0.height.equalTo(1)
            $0.top.equalTo(mainStackView.snp.bottom)
        }
        
        
    }
    
    public func updateView(data: [DetailPesionalViewModel.RateValue]) {
        if data.isEmpty {
            rateLabel.text = "Bạn chưa có đánh giá nào"
        } else {
            var totalRate: Double = 0
            for datum in data {
                totalRate += datum.rate
            }
            
            let rate: Double = round((totalRate / Double(data.count)) * 100) / 100
            rateLabel.attributedText = AttributedStringMaker(string: "\(rate.currencyFormat())/5 với \(data.count) lượt đánh giá")
                .font(Fonts.defaultFont(ofSize: .default)).color(ColorConstant.grayText).first(match: "\(rate.currencyFormat())", maker: {
                    $0.font(Fonts.boldFont(ofSize: .popupTitle))
                    $0.color(ColorConstant.text)
                }).build()
        }
    }

}
