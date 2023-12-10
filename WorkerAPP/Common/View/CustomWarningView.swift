//
//  CustomWarningView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 13/10/2023.
//

import UIKit
import Presentation
import Utils

class CustomWarningView: CustomXibView {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var iconView: UIImageView!
    override func configeViews() {
        super.configeViews()
        setupView()
    }
    
    private func setupView() {
        titleLabel.textColor = ColorConstant.text
        titleLabel.font = Fonts.defaultFont(ofSize: .small)
    }
    
    public func updateView(icon: UIImage?, title: String) {
        iconView.image = icon
        titleLabel.text = title
    }

}
