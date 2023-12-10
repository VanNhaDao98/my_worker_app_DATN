//
//  CancelOrderPopupView.swift
//  CustomerApp
//
//  Created by Dao Van Nha on 26/10/2023.
//

import UIKit
import Utils

open class ConfirmPopupView: UIView {
    
    private var mainStackView = UIStackView()
    private var titlelabel = UILabel()
    private var subTitleLabel = UILabel()
    private var returnButton = Button()
    private var confirmButton = Button()
    private var dismissButton = AppBaseButton()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public var returnAction: (() -> Void)? {
        get { returnButton.action }
        set { returnButton.action = newValue }
    }
    
    public var confirmAction: (() -> Void)? {
        get { confirmButton.action }
        set { confirmButton.action = newValue }
    }
    
    public var dismissAction: (() -> Void)? {
        get { dismissButton.action }
        set { dismissButton.action = newValue }
    }
    
    public var title: String? {
        get { titlelabel.text }
        set { titlelabel.text = newValue }
    }
    
    public var subTitle: String? {
        get { subTitleLabel.text }
        set { subTitleLabel.text = newValue }
    }
    
    private func setupView() {
        backgroundColor = .white
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints({
            $0.edges.equalToSuperview().priority(.init(999))
        })
        
        dismissButton.setImage(ImageConstant.icClose, for: .normal)
        dismissButton.setContentHuggingPriority(.required, for: .horizontal)
        dismissButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        let titleStackView = UIStackView(arrangedSubviews: [titlelabel, dismissButton])
        titleStackView.spacing = 12
        
        let buttonStackView = UIStackView(arrangedSubviews: [returnButton, confirmButton])
        buttonStackView.spacing = 12
        buttonStackView.distribution = .fillEqually
        
        mainStackView.addArrangedSubview(titleStackView)
        mainStackView.addArrangedSubview(subTitleLabel)
        mainStackView.addArrangedSubview(buttonStackView)
        
        returnButton.title = "Trở về"
        returnButton.config.style = .outline
        returnButton.config.primaryColor = .red
        
        confirmButton.title = "Xác nhận"
        confirmButton.config.primaryColor = .red
        confirmButton.setTitleColor(.white, for: .normal)
        
        [returnButton, confirmButton].forEach({
            $0.snp.makeConstraints({ make in
                make.height.equalTo(48)
            })
            
            $0.squircle(radius: 24)
        })
        
        titlelabel.textColor = ColorConstant.text
        titlelabel.font = Fonts.semiboldFont(ofSize: .default)
        
        subTitleLabel.textColor = ColorConstant.text
        subTitleLabel.font = Fonts.defaultFont(ofSize: .default)
        subTitleLabel.numberOfLines = 0
    }
    

}
