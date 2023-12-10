//
//  DetailLevelView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 25/11/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils

class DetailLevelView: CustomXibView {
    
    @IBOutlet private var jobImageView: UIImageView!
    @IBOutlet private var jobNameView: UILabel!
    @IBOutlet private var selectButton: AppBaseButton!
    @IBOutlet private var levelTitleLabel: UILabel!
    @IBOutlet private var levelButton: Button!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var textView: TextView!
    @IBOutlet private var skillTitleLabel: UILabel!
    @IBOutlet weak var knowledgeTitle: UILabel!
    @IBOutlet weak var knowledgeValue: UILabel!
    @IBOutlet weak var practiceTitle: UILabel!
    @IBOutlet weak var practiceValue: UILabel!
    
    struct Action {
        var selected: () -> Void
        var selectLevel: () -> Void
        var updateSkill: (String?) -> Void
    }
    
    var action: Action?
    
    override func configeViews() {
        super.configeViews()
        jobImageView.squircle()
        jobNameView.textColor = .text
        jobNameView.font = Fonts.mediumFont(ofSize: .default)
        
        selectButton.action = { [weak self] in
            self?.action?.selected()
        }
        
        selectButton.setTitle(title: "Chọn lại")
        
        levelTitleLabel.textColor = .text
        levelTitleLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        levelTitleLabel.text = "Cấp bậc nghề nghiệp"
        
        priceLabel.textColor = .text
        priceLabel.font = Fonts.mediumFont(ofSize: .default)
        
        levelButton.title = 1.currencyFormat()
        levelButton.action = { [weak self] in
            self?.action?.selectLevel()
        }
        
        levelButton.config.style = .outline
        levelButton.rightIcon = ImageConstant.chevronDown
        levelButton.squircle(radius: 24)
        
        skillTitleLabel.textColor = .grayText
        skillTitleLabel.font = Fonts.italicFont(ofSize: .small)
        
        skillTitleLabel.attributedText = AttributedStringMaker(string: "Chi tiết kỹ năng nghề nghiệp *")
            .font(Fonts.defaultFont(ofSize: .subtitle))
            .color(ColorConstant.grayText).first(match: "*", maker: {
                $0.color(.red)
            }).build()
        textView.textDidChanged = { [weak self] text in
            self?.action?.updateSkill(text)
        }
        
        textView.maxCharactorCount = 500
        
        [knowledgeTitle, practiceTitle].forEach {
            $0?.textColor = .text
            $0?.font = Fonts.mediumFont(ofSize: .default)
        }
        
        knowledgeTitle.text = "Hiểu biết"
        practiceTitle.text = "Làm được"
        
        [knowledgeValue, practiceValue].forEach {
            $0?.textColor = .text50
            $0?.font = Fonts.defaultFont(ofSize: .subtitle)
        }
        
    }
    
    public func upateView(item: CreateWorkerJobDetailViewModel.Item) {
        jobImageView.image = item.icon
        jobNameView.text = item.jobName
        levelButton.title = item.level
        priceLabel.text = "\(item.price)/h"
        textView.text = item.detailLevel
        self.knowledgeValue.text = item.knowledge
        self.practiceValue.text = item.practice
    }

}
