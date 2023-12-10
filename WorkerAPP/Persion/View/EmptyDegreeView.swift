//
//  EmptyDegreeView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 05/11/2023.
//

import UIKit
import Presentation
import Utils

class EmptyDegreeView: CustomXibView {

    @IBOutlet private var titleLabel: UILabel!
    override func configeViews() {
        super.configeViews() 
        titleLabel.text = "Chúng chưa ghi nhận bằng cấp của bạn. Nếu có hãy cập nhật ngay nhé"
        titleLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        titleLabel.textColor = ColorConstant.text50
    }

}
