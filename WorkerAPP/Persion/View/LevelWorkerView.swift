//
//  LevelWorkerView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 26/11/2023.
//

import UIKit
import Utils
import UIComponents

class LevelWorkerView: UIView {
    
    private var mainStackView = UIStackView()
    private var levelTitle = HeaderLabel()
    private var moreButton = AppBaseButton()
    private var knowledgeTitle = UILabel()
    private var knowledgeValue = UILabel()
    
    private var practiceTitle = UILabel()
    private var practiceValue = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var action: (() -> Void)? {
        get { moreButton.action }
        set { moreButton.action = newValue }
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
        
        let titleStackView = UIStackView(arrangedSubviews: [levelTitle, moreButton])
        titleStackView.axis = .horizontal
        titleStackView.alignment = .center
        moreButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        moreButton.setContentHuggingPriority(.required, for: .horizontal)
        moreButton.setTitle(title: "Xem cấp bậc")
        moreButton.setTitleColor(.primary, for: .normal)
        moreButton.titleLabel?.font = Fonts.defaultFont(ofSize: .default)
        mainStackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        mainStackView.addArrangedSubview(titleStackView)
        mainStackView.addArrangedSubview(knowledgeTitle)
        mainStackView.addArrangedSubview(knowledgeValue)
        mainStackView.addArrangedSubview(practiceTitle)
        mainStackView.addArrangedSubview(practiceValue)
        
        [knowledgeTitle, practiceTitle].forEach {
            $0.textColor = .text
            $0.font = Fonts.mediumFont(ofSize: .default)
            $0.textAlignment = .left
        }
        
        knowledgeTitle.text = "Hiểu biết"
        practiceTitle.text = "Làm được"
        
        [knowledgeValue, practiceValue].forEach {
            $0.textColor = .text50
            $0.font = Fonts.defaultFont(ofSize: .subtitle)
            $0.textAlignment = .left
            $0.numberOfLines = 0
        }
    }
    
    public func updateView(data: DetailPesionalViewModel.Level) {
        levelTitle.text = data.level
        knowledgeValue.text = data.knowledge
        practiceValue.text = data.practice
    }
    
}
