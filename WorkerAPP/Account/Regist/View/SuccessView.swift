//
//  SuccessView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 05/11/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils

class SuccessView: CustomXibView {

    @IBOutlet private var subTitleLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    
    override func configeViews() {
        super.configeViews()
        
        titleLabel.text = "Tạo tài khoản thành công"
        titleLabel.font = Fonts.mediumFont(ofSize: .title)
        titleLabel.textColor = ColorConstant.text
        
        subTitleLabel.text = "Chúc bạn có một trải nghiệm tuyệt vời cùng với sản phẩm của chúng tôi"
        subTitleLabel.font = Fonts.defaultFont(ofSize: .subtitle)
        subTitleLabel.textColor = ColorConstant.text50
    }

}
