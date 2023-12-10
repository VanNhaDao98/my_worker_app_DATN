//
//  FeatureAccountCell.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 18/10/2023.
//

import UIKit
import UIComponents
import Utils

class FeatureAccountCell: UITableViewCell {
    @IBOutlet private var rateVIew: TagView!

    @IBOutlet private var bottomView: LeftRightLabelView!
    @IBOutlet private var viewTop: LeftRightLabelView!
    @IBOutlet private var accountImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupView() {
        rateVIew.backgroundColor = .hex(0xFFBF44)
        rateVIew.text = "5.0"
        rateVIew.textColor = .white
        
        viewTop.leftText = "Đào Văn Nhạ"
        viewTop.rightText = "123 Hợp đồng"
        viewTop.leftTextFont = Fonts.defaultFont(ofSize: .default)
        viewTop.rightTextFont = Fonts.defaultFont(ofSize: .subtitle)
        
        bottomView.leftText = "Hà Nội"
        bottomView.rightText = "Thợ điện"
        bottomView.rightTextFont = Fonts.defaultFont(ofSize: .subtitle)
        bottomView.leftTextFont = Fonts.defaultFont(ofSize: .subtitle)
        bottomView.rightTextColor = ColorConstant.grayText
        bottomView.leftIcon = ImageConstant.locationPin
        bottomView.rightIcon = ImageConstant.electricCircle
        bottomView.rightIconPosition = .left
    }
    
}
