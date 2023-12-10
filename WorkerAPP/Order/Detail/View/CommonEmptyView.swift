//
//  CommonEmptyView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 26/11/2023.
//

import UIKit
import Utils

class CommonEmptyView: UIView {
    
    private var mainStackView = UIStackView()
    private var emptyImageView = UIImageView()
    private var subtitlelabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        mainStackView.alignment = .center
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainStackView.addArrangedSubview(emptyImageView)
        mainStackView.addArrangedSubview(subtitlelabel)
        
        emptyImageView.snp.makeConstraints({
            $0.height.width.equalTo(240)
        })
        emptyImageView.contentMode = .scaleAspectFill
        emptyImageView.image = ImageConstant.imgEmptySearchResult
        
        subtitlelabel.font = Fonts.defaultFont(ofSize: .subtitle)
        subtitlelabel.numberOfLines = 0
        subtitlelabel.textColor = .text
        subtitlelabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(24)
        })
        subtitlelabel.textAlignment = .center
        subtitlelabel.text = "Bạn chưa có đơn hàng nào"
    }

}
