//
//  PesionDetailSkillView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 26/11/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils

class PesionDetailSkillView: UIView {
    
    private var mainStackView = UIStackView()
    private var title = HeaderLabel()
    private var subTitle = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        squircle()
        backgroundColor = ColorConstant.BGNhat
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 12,
                                                   left: 16,
                                                   bottom: 12,
                                                   right: 16)
        mainStackView.spacing = 12
        mainStackView.axis = .vertical
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        mainStackView.addArrangedSubview(title)
        mainStackView.addArrangedSubview(subTitle)
        
        title.text = "Chi tiết kỹ năng"
        subTitle.font = Fonts.defaultFont(ofSize: .default)
        subTitle.textColor = .text
        subTitle.numberOfLines = 0
        
    }
    
    public func updateView(subTitle: String) {
        self.subTitle.text = subTitle
    }
}
