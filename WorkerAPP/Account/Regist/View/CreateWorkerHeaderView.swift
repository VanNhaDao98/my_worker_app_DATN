//
//  CreateWorkerHeaderView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 15/10/2023.
//

import UIKit
import Utils

class CreateWorkerHeaderView: UIView {
    
    private var mainStackview = UIStackView()
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(mainStackview)
        mainStackview.axis = .vertical
        mainStackview.spacing = 8
        mainStackview.snp.makeConstraints {
            $0.edges.equalToSuperview().priority(.init(999))
        }
        mainStackview.addArrangedSubview(titleLabel)
        mainStackview.addArrangedSubview(subTitleLabel)
        
        titleLabel.font = Fonts.boldFont(ofSize: .title)
        titleLabel.textColor = ColorConstant.text
        
        subTitleLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        subTitleLabel.textColor = ColorConstant.grayText
        subTitleLabel.numberOfLines = 0
    }
    
    public func setValue(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    public func addView(_ view: UIView) {
        self.mainStackview.addArrangedSubview(view)
    }
    
}
