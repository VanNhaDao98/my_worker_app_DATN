//
//  DegreeGroupView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/10/2023.
//

import UIKit
import Utils

class DegreeGroupView: UIView {
    
    private var mainStackView = UIStackView()
    private var degreeStackView = UIStackView()

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
        mainStackView.axis = .vertical
        mainStackView.snp.makeConstraints({
            $0.edges.equalToSuperview().priority(.init(999))
        })
        
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        mainStackView.spacing = 12
        
        let title = UILabel()
        title.text = "Bằng cấp"
        title.font = Fonts.boldFont(ofSize: .title)
        title.textColor = ColorConstant.text
        title.setContentHuggingPriority(.required, for: .vertical)
        title.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        mainStackView.addArrangedSubview(title)
        mainStackView.addArrangedSubview(degreeStackView)
        
        degreeStackView.spacing = 8
        degreeStackView.axis = .vertical
        
        backgroundColor = ColorConstant.BGNhat
        squircle(radius: 8)
    }
    
    public func updateView(datas: [DetailPesionalViewModel.Degree]) {
        if datas.isEmpty {
            let emptyView = EmptyDegreeView()
            degreeStackView.addArrangedSubview(emptyView)
        }
        degreeStackView.removeSubviews()
        for (_, value) in datas.enumerated() {
            let view = DegreeView()
            view.updateView(data: value)
            degreeStackView.addArrangedSubview(view)
        }
    }

}
