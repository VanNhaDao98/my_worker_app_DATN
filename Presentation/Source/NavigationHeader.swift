//
//  NavigationHeader.swift
//  Presentation
//
//  Created by Dao Van Nha on 12/10/2023.
//

import UIKit
import UIComponents
import SnapKit
import Utils

open class NavigationHeader: UIView {
    
    private var backgroundImageView = UIImageView()
    private var mainStackView = UIStackView()
    private var headerStackView = UIStackView()
    private var leftButton = AppBaseButton()
    private var titleLabel = UILabel()
    private var rightStackView = UIStackView()
    
    var extraHeight: CGFloat {
        if safeAreaInsets.top > 0 {
            return safeAreaInsets.top
        } else {
            return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        }
    }
    
    public var isHiddenLeftButton: Bool {
        get { leftButton.isHidden }
        set { leftButton.isHidden = newValue}
    }
    
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var backGroundImage: UIImage? {
        didSet {
            backgroundImageView.image = backGroundImage
        }
    }

    public var leftAction: (() -> Void)? {
        get { leftButton.action }
        set { leftButton.action = newValue}
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundImageView.image = ImageConstant.defaultHeader
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        mainStackView.axis = .vertical
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16)
        mainStackView.spacing = 16
       
        mainStackView.addArrangedSubview(headerStackView)
        mainStackView.addArrangedSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.font = Fonts.boldFont(ofSize: .headerTitle)
        
        let spacingView = UIView()
        spacingView.backgroundColor = .clear
        headerStackView.axis = .horizontal
        headerStackView.spacing = 8
        headerStackView.addArrangedSubview(leftButton)
        headerStackView.addArrangedSubview(spacingView)
        headerStackView.addArrangedSubview(rightStackView)
        leftButton.setContentHuggingPriority(.required, for: .horizontal)
        leftButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        leftButton.setImage(ImageConstant.chevronLeft, for: .normal)
        leftButton.tintColor = .white
        leftButton.setTitle(title: "Quay lại")
        rightStackView.setContentHuggingPriority(.init(999), for: .horizontal)
        rightStackView.setContentCompressionResistancePriority(.init(999), for: .horizontal)
    }
    
    public func setBackButton(icon: UIImage?) {
        leftButton.setImage(icon, for: .normal)
        leftButton.setTitle(title: nil)
    }
}
