//
//  RankJobView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 26/11/2023.
//

import UIKit
import Utils

class RankJobView: UIView {

    private var item: DetailJobLevelViewModel.Item
    
    private var mainStackView = UIStackView()
    private var levelTitle = UILabel()
    private var knowledgeTitle = UILabel()
    private var knowledgeValue = UILabel()
    private var practiceTitle = UILabel()
    private var practiceValue = UILabel()
    
    init(item: DetailJobLevelViewModel.Item) {
        self.item = item
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        mainStackView.addArrangedSubview(levelTitle)
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
        
        levelTitle.text = item.level
        levelTitle.textColor = .text
        levelTitle.font = Fonts.boldFont(ofSize: .title)
        levelTitle.textAlignment = .center
        
        knowledgeValue.text = item.knowledge
        practiceValue.text = item.practice
    }
    
}
