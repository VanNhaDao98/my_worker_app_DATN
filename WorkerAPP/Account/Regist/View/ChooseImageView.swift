//
//  ChooseImageView.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 14/10/2023.
//

import UIKit
import Presentation
import Utils
import UIComponents

class ChooseImageView: CustomXibView {

    @IBOutlet private var chooseButton: AppBaseButton!
    @IBOutlet private var note2Label: UILabel!
    @IBOutlet private var note1label: UILabel!
    @IBOutlet private var avatarImageView: UIImageView!
    
    var chooseImageAction: (() -> Void)? {
        get { chooseButton.action }
        set { chooseButton.action = newValue }
    }
    
    override func configeViews() {
        super.configeViews()
        
        avatarImageView.squircle()
        [note1label, note2Label].forEach {
            $0?.font = Fonts.defaultFont(ofSize: .subtitle)
            $0?.textColor = ColorConstant.grayText
        }
        note1label.text = "Chúng tôi sẽ giảm dung lượng ảnh của bạn để tối ưu hệ thống"
        note1label.numberOfLines = 0
        note2Label.text = "File đuôi jpg, png"
        chooseButton.setTitle(title: "Chọn ảnh")
        chooseButton.setTitleColor(ColorConstant.primary, for: .normal)
    }
    
    public func updateView(image: UIImage?) {
        self.avatarImageView.image = image == nil ? ImageConstant.imageEmpty : image
    }

}
